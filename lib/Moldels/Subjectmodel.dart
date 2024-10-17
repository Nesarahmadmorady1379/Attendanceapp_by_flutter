class Subject {
  final int? id;
  final String department;
  final String name;
  final String credit;

  Subject(
      {this.id,
      required this.department,
      required this.name,
      required this.credit});

  // Convert a Subject object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'department': department,
      'name': name,
      'credit': credit,
    };
  }

  // Convert a Map object into a Subject object
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      department: map['department'],
      name: map['name'],
      credit: map['credit'],
    );
  }
}
