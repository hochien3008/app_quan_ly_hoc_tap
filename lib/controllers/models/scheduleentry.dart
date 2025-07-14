class ScheduleEntry {
  final String subject;
  final String startTime;
  final String endTime;
  final String location;

  ScheduleEntry({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
    };
  }

  factory ScheduleEntry.fromMap(Map<String, dynamic> map) {
    return ScheduleEntry(
      subject: map['subject'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      location: map['location'],
    );
  }
}
