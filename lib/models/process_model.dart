import 'department_model.dart';

class Process {
  String id;
  String departmentId;
  String userId;
  DateTime start;
  DateTime end;
  String responsible;

  get getId => this.id;
  set setId(String id) => this.id = id;

  get getUserId => this.userId;
  set setUserId(String userId) => this.userId = userId;

  get getResponsible => this.responsible;
  set setResponsible(responsible) => this.responsible = responsible;

  get getDepartmentId => this.departmentId;
  set setDepartmentId(String departmentId) => this.departmentId = departmentId;

  get getStart => this.start;
  set setStart(start) => this.start = start;

  get getEnd => this.end;
  set setEnd(end) => this.end = end;

  Process();

  Process.fromJson(Map<String, dynamic> json)
      : departmentId = json['departmentId'],
        userId = json['userId'],
        start = DateTime.parse(json['start'].toDate().toString()),
        end = json['end'] == null
            ? null
            : DateTime.parse(json['end'].toDate().toString()),
        responsible = json['responsible'];

  Map<String, dynamic> toJson() => {
        'departmentId': departmentId,
        'start': start,
        'end': end,
        'responsible': responsible
      };
}
