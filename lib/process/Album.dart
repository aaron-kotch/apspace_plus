class Album {

  final String intake;
  final String moduleId;
  final String day;
  final String location;
  final String room;
  final String lecturerId;
  final String lecturerName;
  final String lecturerAcc;
  final String date;
  final String dateIso;
  final String startTime;
  final String endTime;
  final String startTimeIso;
  final String endTimeIso;
  final String classCode;
  final String grouping;
  final String color;

  Album({this.intake, this.moduleId, this.day, this.location, this.room, this.lecturerId, this.lecturerName, this.lecturerAcc, this.date, this.dateIso, this.startTime, this.endTime, this.startTimeIso, this.endTimeIso, this.classCode, this.grouping, this.color});

  factory Album.fromJson(Map<String, dynamic> json) {

    return Album(
      intake: json['INTAKE'],
      moduleId: json['MODID'],
      day: json['DAY'],
      location: json['LOCATION'],
      room: json['ROOM'],
      lecturerId: json['LECTID'],
      lecturerName: json['NAME'],
      lecturerAcc: json['SAMACCOUNTNAME'],
      date: json['DATESTAMP'],
      dateIso: json['DATESTAMP_ISO'],
      startTime: json['TIME_FROM'],
      endTime: json['TIME_TO'],
      startTimeIso: json['TIME_FROM_ISO'],
      endTimeIso: json['TIME_TO_ISO'],
      classCode: json['CLASS_CODE'],
      grouping: json['GROUPING'],
      color: json['COLOR'],
    );
  }
}