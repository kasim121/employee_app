/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_provider.dart';
import '../screens/employee_edit_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    if (employeeProvider.employees.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Employee List'),
        ),
        body: ListView.builder(
          itemCount: employeeProvider.employees.length,
          itemBuilder: (context, index) {
            final employee = employeeProvider.employees[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(employee.avatar),
              ),
              title: Text('${employee.firstName} ${employee.lastName}'),
              subtitle: Text(employee.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                         Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeScreen(employee: employee),
      ),
    );
                      // // Call the edit function in the provider
                      // employeeProvider.editEmployee(employee);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Call the delete function in the provider
                      employeeProvider.deleteEmployee(employee.id);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/employee.dart';
import '../provider/employee_provider.dart';
import '../screens/employee_edit_screen.dart';
import '../utils/shimmer.dart';

class MobileScreen extends StatefulWidget {
  MobileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedTabIndex = -1;
  int selectedIndexForTakeMeToClub = 8;
  bool isLoading = false;
  bool isExpanded = false;

  @override
  void initState() {
    _tabController = TabController(length: 14, vsync: this);
    callEmployeeApi();

    super.initState();
  }

  void callEmployeeApi() async {
    Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
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
    var myHeight = MediaQuery.of(context).size.height;
    var myWidth = MediaQuery.of(context).size.width;
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
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.refresh),
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
                _selectedTabIndex = index; // Update the selected tab index
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
            child: TabBarView(
              controller: TabController(
                length: getUniqueEmployeeNames(employeeProvider.employees).length,
                initialIndex: _selectedTabIndex, vsync: this,
              ),
              children: getUniqueEmployeeNames(employeeProvider.employees)
                  .map((name) {
                return EmployeeListView(employeeName: name);
              }).toList(),
            ),
          ),
        ),
        // TabBarView(
          
        //   children:
        //       getUniqueEmployeeNames(employeeProvider.employees).map((name) {
        //     return EmployeeListView(employeeName: name);
        //   }).toList(),
        // ),
      ),
   
    );
  }

 
}

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
            itemCount: provider.employees.length,
            itemBuilder: (BuildContext context, int index) {
              var employeeData = provider.employees[index];

              return 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditEmployeeScreen(employee: employeeData),
                              ),
                            );
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
                    Text(employeeData.firstName.toString()),
                    Text(employeeData.lastName.toString()),
                    Text(employeeData.email.toString()),
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
*/