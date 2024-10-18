class Attendance {
  int? id;
  String department;
  String semester;
  String subject;
  String startDate;
  String endDate;

  Attendance({
    this.id,
    required this.department,
    required this.semester,
    required this.subject,
    required this.startDate,
    required this.endDate,
  });

  // Convert a Attendance object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'semester': semester,
      'subject': subject,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  // Extract a Attendance object from a Map object
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      department: map['department'],
      semester: map['semester'],
      subject: map['subject'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
