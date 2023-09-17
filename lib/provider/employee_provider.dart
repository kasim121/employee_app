import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/employee.dart';

import 'database_provider.dart';

class EmployeeProvider with ChangeNotifier {
  List<Datum> _employees = [];
 bool loading = false;
  List<Datum> get employees => _employees;
 bool isLoading = false;
  bool isExpanded = false;
  Future<void> fetchEmployees() async {
    String url = 'https://reqres.in/api/users?page=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      _employees = responseData.map((data) => Datum.fromJson(data)).toList();

 
      final db = await DatabaseHelper.instance.database;
      await db.delete('employees');
      for (var employee in _employees) {
        await db.insert('employees', employee.toJson());
      }
      
      notifyListeners();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> loadEmployeesFromLocalDatabase() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('employees');

    _employees = List.generate(maps.length, (i) {
      return Datum(
        id: maps[i]['id'],
        email: maps[i]['email'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
        avatar: maps[i]['avatar'],
      );
    });

    notifyListeners();
  }
  
  void deleteEmployee(int employeeId) {
    final index = _employees.indexWhere((employee) => employee.id == employeeId);
    if (index != -1) {
      final deletedEmployee = _employees.removeAt(index);


      _deleteEmployeeFromLocalDatabase(deletedEmployee.id);

      notifyListeners();
    }
  }


  Future<void> _deleteEmployeeFromLocalDatabase(int employeeId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }
  void editEmployee(Datum updatedEmployee) {
  final index =
      _employees.indexWhere((employee) => employee.id == updatedEmployee.id);
  if (index != -1) {
    _employees[index] = updatedEmployee;

   
    _updateLocalDatabase(updatedEmployee);

    notifyListeners();
  }
}

Future<void> _updateLocalDatabase(Datum updatedEmployee) async {
  final db = await DatabaseHelper.instance.database;
  await db.update(
    'employees',
    updatedEmployee.toJson(),
    where: 'id = ?',
    whereArgs: [updatedEmployee.id],
  );
}
  List<Datum> filterEmployeesByName(String employeeName) {
    return _employees.where((employee) => employee.firstName == employeeName).toList();
  }
 Future<void> refreshEmployees() async {
  try {
    
    await Future.delayed(const Duration(seconds: 2));
    await fetchEmployees(); 
    notifyListeners();
  } catch (error) {
    // ignore: use_rethrow_when_possible
    throw error;
  }
}

  
}
