class Attendance {
  final int? id;
  final String department;
  final String semester;
  final String subject;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> students; // This should remain a List<String>

  Attendance({
    this.id,
    required this.department,
    required this.semester,
    required this.subject,
    required this.startDate,
    required this.endDate,
    required this.students,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'semester': semester,
      'subject': subject,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'students': students.join(','), // Convert list to a string
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      department: map['department'],
      semester: map['semester'],
      subject: map['subject'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      students: map['students'].split(','), // Convert string back to list
    );
  }
}
