class DailyAttendance {
  final int? id; // Optional ID for the record
  final int attendanceId; // Foreign key to Attendance
  final String studentId; // Student ID
  final String studentName; // Student Name
  bool isPresent; // Attendance status: present or absent
  final String date; // Date of attendance

  DailyAttendance({
    this.id,
    required this.attendanceId,
    required this.studentId,
    required this.studentName, // Add this line for the name
    required this.isPresent,
    required this.date,
  });

  // Converts a DailyAttendance object into a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attendanceId': attendanceId,
      'studentId': studentId,
      'studentName': studentName, // Add studentName to map
      'isPresent': isPresent
          ? 1
          : 0, // SQLite doesn't have a boolean type, so using 1 for true and 0 for false
      'date': date,
    };
  }

  // Creates a DailyAttendance object from a map (e.g., fetched from database)
  factory DailyAttendance.fromMap(Map<String, dynamic> map) {
    return DailyAttendance(
      id: map['id'],
      attendanceId: map['attendanceId'],
      studentId: map['studentId'],
      studentName:
          map['studentName'] ?? '', // Default to an empty string if null
      isPresent: map['isPresent'] == 1, // Convert integer to boolean
      date: map['date'],
    );
  }

  // Overriding toString to provide meaningful output
  @override
  String toString() {
    return 'DailyAttendance(id: $id, attendanceId: $attendanceId, studentId: $studentId, studentName: $studentName, isPresent: ${isPresent ? "Present" : "Absent"}, date: $date)';
  }
}
