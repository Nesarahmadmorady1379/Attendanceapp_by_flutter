class Student {
  final int?
      id; // SQLite automatically generates id, so it's nullable for new entries
  final String name;
  final String studentId;
  final String semester;
  final String department;

  Student({
    this.id,
    required this.name,
    required this.studentId,
    required this.semester,
    required this.department,
  });

  // Convert Student object to Map for saving to database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'semester': semester,
      'department': department,
    };
  }

  // Create a Student object from a Map retrieved from database
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentId: map['studentId'],
      semester: map['semester'],
      department: map['department'],
    );
  }
}
