import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:real_innov/styles/styles.dart';

import '../../bloc/employee_bloc.dart';
import '../../models/employee.dart';

class AddEmployeeDetailsPage extends StatefulWidget {
  final Employee? employee;

  AddEmployeeDetailsPage({this.employee});

  @override
  _AddEmployeeDetailsPageState createState() => _AddEmployeeDetailsPageState();
}

class _AddEmployeeDetailsPageState extends State<AddEmployeeDetailsPage> {
  late EmployeeBloc employeeBloc;
  final _formKey = GlobalKey<FormState>();
  int _employeeCounter = 0;
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime? _endDate;
  late String _designation;
  late String _startDateText;
  late String _endDateText;
  List<String> roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner",
  ];
  @override
  void initState() {
    super.initState();
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _nameController = TextEditingController();
    _startDate = DateTime.now();
    _endDate = null;
    _designation = '';
    _startDateText = 'Today';
    _endDateText = 'No Date';

    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _startDate = widget.employee!.startDate;
      _endDate = widget.employee!.endDate;
      _designation = widget.employee!.designation;
      _startDateText = DateFormat('dd MMM yyyy').format(_startDate);
      _endDateText =
          _endDate != null ? DateFormat('dd MMM yyyy').format(_endDate!) : 'No Date';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      if (widget.employee != null) {
        print('-------------------update');
        final oldEmployee = widget.employee!;
        final newEmployee = Employee(
          id: widget.employee!.id,
          name: _nameController.text,
          startDate: _startDate,
          endDate: _endDate != null ? _endDate : null,
          designation: _designation,
        );
        print(oldEmployee);
        print(newEmployee);
        BlocProvider.of<EmployeeBloc>(context)
            .add(UpdateEmployeeEvent(oldEmployee, newEmployee));
      } else {
        final employee = Employee(
          id: _generateUniqueID(),
          name: _nameController.text,
          startDate: _startDate,
          endDate: _endDate != null ? _endDate : null,
          designation: _designation,
        );
        print('----------new');
        print(employee);
        BlocProvider.of<EmployeeBloc>(context).add(AddEmployeeEvent(employee));
      }

      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pop(context);
      BlocProvider.of<EmployeeBloc>(context).add(LoadEmployeeEvent());
    }
  }

  int _generateUniqueID() {
    _employeeCounter++;
    return _employeeCounter;
  }

  void showDesignationBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final double itemHeight = 56.0;
          final double maxHeight = MediaQuery.of(context).size.height * 0.6;
          final double sheetHeight = roles.length * itemHeight;
          final double height =
              sheetHeight > maxHeight ? maxHeight : sheetHeight;

          return Container(
            height: height,
            child: ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return ListTile(
                    title: Center(child: Text(role)),
                    onTap: () {
                      setState(() {
                        _designation = role;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        
        backgroundColor: AppColor.secondaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          widget.employee != null
              ? 'Edit Employee Details'
              : 'Add Employee Details',
          style: HeaderFonts.primaryText,
        ),
        actions: [
          if (widget.employee != null)
            IconButton(
                onPressed: () {
                  employeeBloc.add(DeleteEmployeeEvent(widget.employee!));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(child: Column(children: [
                TextFormField(
                   style: TextFonts.specialText,
                controller: _nameController,
                decoration:  InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HintColor.primaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: HintColor.primaryColor,
                      ),
                    ),
                    hintText: 'Employee name',
                    hintStyle: HintFonts.primaryText,
                    prefixIcon: const Icon(
                      Icons.person_2_outlined,
                      color: IconColor.secondaryColor,
                      
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration:  InputDecoration(
                  prefixIcon: const Icon(Icons.work_outline,
                      color: IconColor.secondaryColor),
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: HintColor.primaryColor,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: HintColor.primaryColor,
                    ),
                  ),
                  hintText: 'Select role',
                  hintStyle: HintFonts.primaryText,
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      color: IconColor.secondaryColor),
                ),
                onTap: showDesignationBottomSheet,
                controller:
                          TextEditingController(text: _designation),
                style: TextFonts.specialText,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      readOnly: true,
                       style: TextFonts.specialText,
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: const Icon(Icons.event,
                            color: IconColor.secondaryColor),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: HintColor.primaryColor,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: HintColor.primaryColor,
                          ),
                        ),
                        hintStyle: HintFonts.primaryText,
                      ),
                      
                      controller:
                          TextEditingController(text: _startDateText),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _startDate = selectedDate;
                            _startDateText =
                                DateFormat('dd MMM yyyy').format(_startDate);
                          });
                        }
                      },
                    ),
                  ),
                  const Expanded(
                      child: Icon(Icons.arrow_right_alt,
                          color: IconColor.secondaryColor)),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                       style:_endDateText=="No Date"?HintFonts.primaryText: TextFonts.specialText,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.event,
                            color: IconColor.secondaryColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: HintColor.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: HintColor.primaryColor,
                          ),
                        ),
                      ),
                      controller: TextEditingController(text: _endDateText),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _endDate = selectedDate;
                            _endDateText =
                                DateFormat('dd MMM yyyy').format(_endDate!);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],)),
      
             
              Column(
                children: [
                  const Divider(thickness: 0.5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: ButtonFonts.secondaryText,
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BoxBorders.primaryBoxBorders,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ButtonColor.primaryColor),
                        ),
                        onPressed: _saveEmployee,
                        child: Text(
                          widget.employee != null ? 'Update' : 'Save',
                          style: ButtonFonts.primaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
