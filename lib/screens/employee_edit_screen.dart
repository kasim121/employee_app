import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/employee.dart';
import '../provider/employee_provider.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Datum employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  // ignore: library_private_types_in_public_api
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.employee.firstName;
    lastNameController.text = widget.employee.lastName;
    emailController.text = widget.employee.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
         
                final updatedEmployee = Datum(
                  id: widget.employee.id,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  avatar: widget.employee.avatar,
                );

        
                Provider.of<EmployeeProvider>(context, listen: false)
                    .editEmployee(updatedEmployee);

                Navigator.pop(context); 
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
