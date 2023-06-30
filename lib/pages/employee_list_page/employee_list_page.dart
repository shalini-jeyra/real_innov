import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:real_innov/pages/pages.dart';
import 'package:real_innov/styles/styles.dart';

import '../../services/employee_bloc_service.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({
    super.key,
  });

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
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoadedState) {
            final employees = state.employees;
            if (employees.isEmpty) {
          return    Center(
                child: Image.asset(
                  'assets/not_found.png',
                ),
              );
            }
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                final isCurrentEmployee = employee.endDate == null;
                final startDateFormatted =
                    DateFormat.yMMMd().format(employee.startDate);
                final endDateFormatted = isCurrentEmployee
                    ? 'Present'
                    : DateFormat.yMMMd().format(employee.endDate!);

                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text(
                      'Start Date: $startDateFormatted\nEnd Date: $endDateFormatted'),
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
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddEmployeeDetailsPage()));
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