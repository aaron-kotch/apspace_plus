class Course {

  final String courseCode;
  final String module;
  final String subjectCode;
  final String tp;
  final int percentage;
  final int semester;
  final int totalClass;
  final int totalAbsent;

  Course({this.courseCode, this.module, this.subjectCode, this.tp, this.percentage, this.semester, this.totalClass, this.totalAbsent});

  factory Course.fromJson(Map<String, dynamic> json) {

    return Course(

      courseCode: json['COURSE_CODE'],
      module: json['MODULE_ATTENDANCE'],
      subjectCode: json['SUBJECT_CODE'],
      tp: json['STUDENT_NUMBER'],
      percentage: json['PERCENTAGE'],
      semester: json['SEMESTER'],
      totalClass: json['TOTAL_CLASSES'],
      totalAbsent: json['TOTAL_ABSENT']

    );

  }

}