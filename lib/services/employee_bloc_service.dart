
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_innov/services/employee_service.dart';

import '../models/employee.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployeeEvent extends EmployeeEvent {}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  UpdateEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  DeleteEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeLoadingState extends EmployeeState {}

class EmployeeLoadedState extends EmployeeState {
  final List<Employee> employees;

  EmployeeLoadedState(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;

  EmployeeErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeService database = EmployeeService();

  EmployeeBloc() : super(EmployeeLoadingState()) {
    add(LoadEmployeeEvent());
  }

  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is LoadEmployeeEvent) {
      yield* _mapLoadEmployeeEventToState();
    } else if (event is AddEmployeeEvent) {
      yield* _mapAddEmployeeEventToState(event.employee);
    } else if (event is UpdateEmployeeEvent) {
      yield* _mapUpdateEmployeeEventToState(event.employee);
    } else if (event is DeleteEmployeeEvent) {
      yield* _mapDeleteEmployeeEventToState(event.employee);
    }
  }

  Stream<EmployeeState> _mapLoadEmployeeEventToState() async* {
    yield EmployeeLoadingState();
    try {
      await database.open();
      final employees = await database.getEmployees();
      yield EmployeeLoadedState(employees);
    } catch (e) {
      yield EmployeeErrorState('Failed to load employees');
    }
  }

  Stream<EmployeeState> _mapAddEmployeeEventToState(Employee employee) async* {
    yield EmployeeLoadingState();
    try {
      await database.addEmployee(employee);
      final employees = await database.getEmployees();
      yield EmployeeLoadedState(employees);
    } catch (e) {
      yield EmployeeErrorState('Failed to add employee');
    }
  }

  Stream<EmployeeState> _mapUpdateEmployeeEventToState(Employee employee) async* {
    yield EmployeeLoadingState();
    try {
      await database.updateEmployee(employee);
      final employees = await database.getEmployees();
      yield EmployeeLoadedState(employees);
    } catch (e) {
      yield EmployeeErrorState('Failed to update employee');
    }
  }

  Stream<EmployeeState> _mapDeleteEmployeeEventToState(Employee employee) async* {
    yield EmployeeLoadingState();
    try {
      await database.deleteEmployee(employee);
      final employees = await database.getEmployees();
      yield EmployeeLoadedState(employees);
    } catch (e) {
      yield EmployeeErrorState('Failed to delete employee');
    }
  }

  @override
  Future<void> close() async {
    await database.close();
    super.close();
  }
}