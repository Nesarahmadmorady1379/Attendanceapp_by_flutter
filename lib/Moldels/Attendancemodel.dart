class Attendance {
  final int? id;
  final String department;
  final String semester;
  final String subject;
  final String startDate;
  final String endDate;
  final List<String> studentIds; // List of student IDs

  Attendance({
    this.id,
    required this.department,
    required this.semester,
    required this.subject,
    required this.startDate,
    required this.endDate,
    required this.studentIds, // Add this parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'semester': semester,
      'subject': subject,
      'startDate': startDate,
      'endDate': endDate,
      'studentIds': studentIds.join(','), // Convert list to string
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      department: map['department'],
      semester: map['semester'],
      subject: map['subject'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      studentIds: map['studentIds'] != null
          ? map['studentIds'].split(',')
          : [], // Convert string back to list
    );
  }
}
