class ClassScheduleModel {
  final String id;
  final String monHoc;
  final String phong;
  final String thoiGian;
  final DateTime ngay;

  ClassScheduleModel({
    required this.id,
    required this.monHoc,
    required this.phong,
    required this.thoiGian,
    required this.ngay,
  });

  Map<String, dynamic> toMap() {
    return {
      'monHoc': monHoc,
      'phong': phong,
      'thoiGian': thoiGian,
      'ngay': ngay.toIso8601String(),
    };
  }

  factory ClassScheduleModel.fromMap(String id, Map<String, dynamic> map) {
    return ClassScheduleModel(
      id: id,
      monHoc: map['monHoc'],
      phong: map['phong'],
      thoiGian: map['thoiGian'],
      ngay: DateTime.parse(map['ngay']),
    );
  }
}
