import 'department_model.dart';

class Process {
  String id;
  Department department;
  String userId;
  DateTime start;
  DateTime end;
  String responsible;
  String observations;

  get getId => this.id;
  set setId(String id) => this.id = id;

  get getUserId => this.userId;
  set setUserId(String userId) => this.userId = userId;

  get getResponsible => this.responsible;
  set setResponsible(responsible) => this.responsible = responsible;

  get getDepartment => this.department;
  set setDepartment(Department department) => this.department = department;

  get getStart => this.start;
  set setStart(start) => this.start = start;

  get getEnd => this.end;
  set setEnd(end) => this.end = end;

  get getObservations => this.observations;
  set setObservations(String observations) => this.observations = observations;

  Process();

  Process.fromJson(Map<String, dynamic> json)
      : department = Department.fromJson(json['department']),
        userId = json['userId'],
        start = DateTime.parse(json['start'].toDate().toString()),
        observations = json['observations'],
        end = json['end'] == null
            ? null
            : DateTime.parse(json['end'].toDate().toString()),
        responsible = json['responsible'];

  Map<String, dynamic> toJson() => {
        'department': department.toJson(),
        'userId': userId,
        'start': start,
        'end': end,
        'responsible': responsible
      };
}
