import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class Employee extends HiveObject with EquatableMixin {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  Employee({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [id, name, startDate, endDate];

  Employee copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate:  DateTime.fromMillisecondsSinceEpoch(map['endDate']) ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, startDate: $startDate, endDate: $endDate)';
  }
}

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    return Employee(
      id: reader.readInt(),
      name: reader.readString(),
      startDate: DateTime.parse(reader.readString()),
      endDate:  DateTime.parse(reader.readString()) ,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.startDate.toIso8601String());
  
    writer.writeString(obj.endDate.toIso8601String());
  }
}
