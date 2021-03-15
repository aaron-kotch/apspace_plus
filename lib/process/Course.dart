class Course {

  final String courseCode;
  final String module;
  final String subjectCode;
  final String tp;
  final int percentage;

  Course({this.courseCode, this.module, this.subjectCode, this.tp, this.percentage});

  factory Course.fromJson(Map<String, dynamic> json) {

    return Course(

        courseCode: json['COURSE_CODE'],
        module: json['MODULE_ATTENDANCE'],
        subjectCode: json['SUBJECT_CODE'],
        tp: json['STUDENT_NUMBER'],
        percentage: json['PERCENTAGE']);

  }

}