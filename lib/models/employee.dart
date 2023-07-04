import 'dart:convert';

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endDate;

  @HiveField(4)
  String designation;

  Employee({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.designation,
  });

  Employee copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? designation,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      designation: designation ?? this.designation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'designation': designation,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endDate']) : null,
      designation: map['designation'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, startDate: $startDate, endDate: $endDate, designation: $designation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Employee &&
      other.id == id &&
      other.name == name &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.designation == designation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      designation.hashCode;
  }
}

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    final fields = reader.readMap();
    return Employee(
      id: fields['id'] as String,
      name: fields['name'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(fields['startDate'] as int),
      endDate: fields['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields['endDate'] as int)
          : null,
      designation: fields['designation'] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer.writeMap({
      'id': obj.id,
      'name': obj.name,
      'startDate': obj.startDate.millisecondsSinceEpoch,
      'endDate': obj.endDate?.millisecondsSinceEpoch,
      'designation': obj.designation,
    });
  }
}
