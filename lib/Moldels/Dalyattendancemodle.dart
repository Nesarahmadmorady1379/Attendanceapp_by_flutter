class DailyAttendance {
  final int? id;
  final int attendanceId; // Foreign key to Attendance
  final String studentId;
  bool isPresent;
  final String date;

  DailyAttendance({
    this.id,
    required this.attendanceId,
    required this.studentId,
    required this.isPresent,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attendanceId': attendanceId,
      'studentId': studentId,
      'isPresent': isPresent ? 1 : 0, // SQLite doesn't have a boolean type
      'date': date,
    };
  }

  factory DailyAttendance.fromMap(Map<String, dynamic> map) {
    return DailyAttendance(
      id: map['id'],
      attendanceId: map['attendanceId'],
      studentId: map['studentId'],
      isPresent: map['isPresent'] == 1,
      date: map['date'],
    );
  }
}
