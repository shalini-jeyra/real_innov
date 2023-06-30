import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

class Employee extends HiveObject with EquatableMixin {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime? endDate;

  Employee({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [id, name, startDate, endDate];
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
      endDate: reader.readBool() ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.startDate.toIso8601String());
    writer.writeBool(obj.endDate != null);
    if (obj.endDate != null) {
      writer.writeString(obj.endDate!.toIso8601String());
    }
  }
}
