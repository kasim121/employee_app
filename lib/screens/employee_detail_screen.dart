import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_provider.dart';
import 'employee_edit_screen.dart';

class EmployeeListView extends StatelessWidget {
  final String employeeName;

  const EmployeeListView({super.key, required this.employeeName});

  @override
  Widget build(BuildContext context) {
    var myWidth = MediaQuery.of(context).size.width;
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        final employees = provider.filterEmployeesByName(employeeName);

        if (employees.isEmpty) {
          return Center(
              child: Text('No employees with the name $employeeName.'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: employees.length,
            itemBuilder: (BuildContext context, int index) {
              var employeeData = employees[index]; 

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditEmployeeScreen(employee: employeeData),
                              ),
                            );
                          },
                          child: const Text(
                            "Edit",
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.020,
                        ),
                        ElevatedButton(
                          onPressed: () {
                       provider.deleteEmployee(employeeData.id);
                          },
                          child: const Text("Delete"),
                        ),
                        SizedBox(
                          width: myWidth * 0.10,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(employeeData.avatar.toString()),
                        ),
                      ],
                    ),
                    Text("First name: ${employeeData.firstName.toString()}"),
                    Text("Last name: ${employeeData.lastName.toString()}"),
                    Text("Email: ${employeeData.email.toString()}"),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
