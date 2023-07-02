import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:real_innov/pages/pages.dart';
import 'package:real_innov/styles/styles.dart';

import '../../bloc/employee_bloc.dart';
import '../../models/employee.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  late EmployeeBloc employeeBloc;
List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(LoadEmployeeEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

 void _deleteEmployee(Employee employee) {
    employeeBloc.add(DeleteEmployeeEvent(employee));
  }

  void _updateEmployeesList(List<Employee> updatedEmployees) {
    setState(() {
      employees = updatedEmployees;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        title: Text(
          'Employee List',
          style: HeaderFonts.primaryText,
        ),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        bloc: employeeBloc,
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoadedState) {
               employees = List<Employee>.from(state.employees);
   print(employees);
            if (employees.isEmpty) {
              return Center(
                child: Image.asset(
                  'assets/not_found.png',
                ),
              );
            }

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                final startDateFormatted =
                    DateFormat.yMMMd().format(employee.startDate);
                final endDateFormatted =
                    DateFormat.yMMMd().format(employee.endDate);

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                
                  
                        _deleteEmployee(employee);
                          setState(() {
                      employees.removeAt(index);
                    });
                   _updateEmployeesList(employees);
                    print(employees);
                  },
                  child: ListTile(
                    title: Text(employee.name),
                    subtitle: Text(
                      'Start Date: $startDateFormatted\nEnd Date: $endDateFormatted',
                    ),
                  ),
                );
              },
            );
          } else if (state is EmployeeErrorState) {
            return Center(child: Text(state.errorMessage));
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ButtonColor.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddEmployeeDetailsPage(),
            ),
          );
        },
        tooltip: 'Add employee details',
        child: const Icon(
          Icons.add,
          color: IconColor.primaryColor,
        ),
      ),
    );
  }
}
