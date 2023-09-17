
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/employee.dart';
import '../provider/employee_provider.dart';
import '../screens/employee_detail_screen.dart';


class MobileScreen extends StatefulWidget {
  const MobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
 String? _selectedEmployeeName; 
 
  bool isLoading = false;
  bool isExpanded = false;
 bool _isRefreshing = false;
  @override
  void initState() {
    _tabController = TabController(length: 14, vsync: this);
    callEmployeeApi();

    super.initState();
  }

  void callEmployeeApi() async {
    Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
  }


  void refreshEmployeeData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      await Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
    } catch (error) {
    
      debugPrint('Error refreshing employee data: $error');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }


  List<String> getUniqueEmployeeNames(List<Datum> employees) {
    return employees.map((employee) => employee.firstName).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    // var myHeight = MediaQuery.of(context).size.height;
    // var myWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: getUniqueEmployeeNames(employeeProvider.employees).length,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const Drawer(),
        appBar: AppBar(
          title: const Text(
            "HomePage",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions:  [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: (){
                     
                setState(() {
                  _isRefreshing = true;
                });
                employeeProvider.refreshEmployees().then((_) {
                  setState(() {
                    _isRefreshing = false; 
                  });
                });
                },
                child:
              
              _isRefreshing
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.refresh)),
            )
          ],
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs:
                getUniqueEmployeeNames(employeeProvider.employees).map((name) {
              return Tab(text: name);
            }).toList(),
              onTap: (index) {
              setState(() {
                _selectedEmployeeName = getUniqueEmployeeNames(
                    employeeProvider.employees)[index]; 
              });
            },
          ),
        ),
        body: 
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                getUniqueEmployeeNames(employeeProvider.employees).length,
            child: Column(
              children: [
                
                if (_selectedEmployeeName != null)
                  EmployeeListView(employeeName: _selectedEmployeeName!),
              ],
            ),
          ),
        ),
      
      ),
   
    );
  }

 
}

