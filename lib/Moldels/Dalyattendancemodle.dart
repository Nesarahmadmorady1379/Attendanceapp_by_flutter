class Dalyattendancemodle {
  int? id;
  String name;
  String studentId;
  bool isPresent;

  Dalyattendancemodle({
    this.id,
    required this.name,
    required this.studentId,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'isPresent': isPresent ? 1 : 0,
    };
  }

  factory Dalyattendancemodle.fromMap(Map<String, dynamic> map) {
    return Dalyattendancemodle(
      id: map['id'],
      name: map['name'],
      studentId: map['studentId'],
      isPresent: map['isPresent'] == 1,
    );
  }
}
