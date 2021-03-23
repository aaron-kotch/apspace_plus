class UpdateAttendance {

  final String attendance;
  final String classType;
  final String classCode;
  final String date;
  final String endTime;
  final String id;
  final String startTime;
  final String typeName;
  final String message;

  UpdateAttendance({this.attendance, this.classType, this.classCode, this.date, this.endTime, this.id, this.startTime, this.typeName, this.message});

  factory UpdateAttendance.fromJson(Map<String, dynamic> json) {

    return UpdateAttendance(
      attendance: 'attendance',
      classType: 'classType',
      classCode: 'classCode',
      date: 'date',
      endTime: 'endTime',
      id: 'id',
      startTime: 'startTime',
      typeName: '__typename',
      message: json['errors']
    );
  }
}