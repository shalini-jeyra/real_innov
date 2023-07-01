import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/employee.dart';
import '../services/employee_service.dart';

part 'employee_event.dart';
part 'employee_state.dart';



class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeService database = EmployeeService();

  EmployeeBloc() : super(EmployeeLoadingState()) {
    on<LoadEmployeeEvent>(_mapLoadEmployeeEventToState);
    on<AddEmployeeEvent>(_mapAddEmployeeEventToState);
    on<UpdateEmployeeEvent>(_mapUpdateEmployeeEventToState);
    on<DeleteEmployeeEvent>(_mapDeleteEmployeeEventToState);
  }

  Future<void> _mapLoadEmployeeEventToState(
    LoadEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoadingState());
    try {
      await database.open();
      final employees = await database.getEmployees();
      emit(EmployeeLoadedState(employees));
    } catch (e) {
      emit(EmployeeErrorState('Failed to load employees'));
    }
  }

  Future<void> _mapAddEmployeeEventToState(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoadingState());
    try {
      
      await database.addEmployee(event.employee);
      final employees = await database.getEmployees();
      print(employees);
      emit(EmployeeLoadedState(employees));
    } catch (e) {
      emit(EmployeeErrorState('Failed to add employee'));
    }
  }

  Future<void> _mapUpdateEmployeeEventToState(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoadingState());
    try {
      await database.updateEmployee(event.employee);
      final employees = await database.getEmployees();
      emit(EmployeeLoadedState(employees));
    } catch (e) {
      emit(EmployeeErrorState('Failed to update employee'));
    }
  }

  Future<void> _mapDeleteEmployeeEventToState(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoadingState());
    try {
      await database.deleteEmployee(event.employee);
      final employees = await database.getEmployees();
      emit(EmployeeLoadedState(employees));
    } catch (e) {
      emit(EmployeeErrorState('Failed to delete employee'));
    }
  }

  @override
  Future<void> close() async {
    await database.close();
    super.close();
  }
}
