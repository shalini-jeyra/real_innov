import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/employee.dart';
import '../../services/employee_bloc_service.dart';

class AddEmployeeDetailsPage extends StatefulWidget {
  @override
  _AddEmployeeDetailsPageState createState() => _AddEmployeeDetailsPageState();
}

class _AddEmployeeDetailsPageState extends State<AddEmployeeDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isCurrentEmployee = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: DateTime.now().microsecondsSinceEpoch,
        name: _nameController.text,
        startDate: _startDate,
        endDate: _isCurrentEmployee ? null : _endDate,
      );
      BlocProvider.of<EmployeeBloc>(context).add(AddEmployeeEvent(employee));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Start Date'),
              TextButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                  }
                },
                child: Text(DateFormat.yMMMd().format(_startDate)),
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Current Employee'),
                value: _isCurrentEmployee,
                onChanged: (value) {
                  setState(() {
                    _isCurrentEmployee = value ?? false;
                  });
                },
              ),
              if (!_isCurrentEmployee) ...[
                Text('End Date'),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _endDate = selectedDate;
                      });
                    }
                  },
                  child: Text(DateFormat.yMMMd().format(_endDate)),
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}