import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  List<Employee> previousEmployees = [];
  List<Employee> currentEmployees = [];

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

  void _updateEmployeesList(List<Employee> employees) {
    final currentDate = DateTime.now();
    final List<Employee> previous = [];
    final List<Employee> current = [];

    for (final employee in employees) {
      if (employee.endDate == null) {
        current.add(employee);
      } else if (employee.endDate!.isBefore(currentDate)) {
        previous.add(employee);
      } else {
        current.add(employee);
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        previousEmployees = previous;
        currentEmployees = current;
      });
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoadedState) {
            final List<Employee> employees =
                List<Employee>.from(state.employees);
            _updateEmployeesList(employees);

            if (employees.isEmpty) {
              return Center(
                child: Image.asset(
                  'assets/not_found.png',
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildEmployeeList(currentEmployees, 'Current Employees'),
                const SizedBox(height: 16.0),
                _buildEmployeeList(previousEmployees, 'Previous Employees'),
              ],
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

  Widget _buildEmployeeList(List<Employee> employees, String heading) {
    if (employees.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Text(heading, style: HeaderFonts.seconadryText),
        ),
        const SizedBox(height: 8.0),
        ListView.separated(
          shrinkWrap: true,
          itemCount: employees.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final employee = employees[index];
            final startDateFormatted =
                DateFormat('dd MMM, yyyy').format(employee.startDate);
            String endDateFormatted = '';
            if (heading == "Previous Employees") {
              endDateFormatted =
                  DateFormat('dd MMM, yyyy').format(employee.endDate!);
            }
            return Dismissible(
              key: Key(employee.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: ErrorColor.primaryColor,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(Icons.delete, color: IconColor.primaryColor),
              ),
              onDismissed: (direction) {
                setState(() {
                  employees.removeAt(index);
                });
                _deleteEmployee(employee);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Employee data has been deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                   textColor: TextColor.ternaryColor,
                      onPressed: () {
                        employeeBloc.add(AddEmployeeEvent(employee));
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  employee.name,
                  style: TextFonts.primaryText,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.designation,
                      style: HintFonts.primaryText,
                    ),
                    if (heading == "Current Employees") ...[
                      Text(
                        "From $startDateFormatted",
                        style: HintFonts.secondaryText,
                      ),
                    ] else ...[
                      Text(
                        '$startDateFormatted - $endDateFormatted',
                        style: HintFonts.secondaryText,
                      ),
                    ]
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddEmployeeDetailsPage(employee: employee),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
