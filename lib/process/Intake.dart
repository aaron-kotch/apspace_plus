class Intake {

  final String courseDesc;
  final String intakeCode;
  final int intakeNum;
  final String tpNum;

  Intake({this.courseDesc, this.intakeCode, this.intakeNum, this.tpNum});

  factory Intake.fromJson(Map<String, dynamic> json) {

    return Intake(

      courseDesc: json['COURSE_DESCRIPTION'],
      intakeCode: json['INTAKE_CODE'],
      intakeNum: json['INTAKE_NUMBER'],
      tpNum: json['STUDENT_NUMBER']

    );

  }


}