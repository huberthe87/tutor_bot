import 'dart:io';
import 'dart:ui';

class Worksheet {
  final String id;
  final String title;
  final File imageFile;
  final List<Rect> regions;
  final List<GradeResult>? gradeResults;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Worksheet({
    required this.id,
    required this.title,
    required this.imageFile,
    required this.regions,
    this.gradeResults,
    required this.createdAt,
    this.updatedAt,
  });
  
  Worksheet copyWith({
    String? id,
    String? title,
    File? imageFile,
    List<Rect>? regions,
    List<GradeResult>? gradeResults,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Worksheet(
      id: id ?? this.id,
      title: title ?? this.title,
      imageFile: imageFile ?? this.imageFile,
      regions: regions ?? this.regions,
      gradeResults: gradeResults ?? this.gradeResults,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imageFile.path,
      'regions': regions.map((r) => {
        'left': r.left,
        'top': r.top,
        'right': r.right,
        'bottom': r.bottom,
      }).toList(),
      'gradeResults': gradeResults?.map((g) => g.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  factory Worksheet.fromJson(Map<String, dynamic> json) {
    return Worksheet(
      id: json['id'],
      title: json['title'],
      imageFile: File(json['imagePath']),
      regions: (json['regions'] as List).map((r) => Rect.fromLTRB(
        r['left'],
        r['top'],
        r['right'],
        r['bottom'],
      )).toList(),
      gradeResults: json['gradeResults'] != null
          ? (json['gradeResults'] as List).map((g) => GradeResult.fromJson(g)).toList()
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class GradeResult {
  final String grade;
  final double confidence;
  final Map<String, dynamic>? metadata;
  
  GradeResult({
    required this.grade,
    required this.confidence,
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'grade': grade,
      'confidence': confidence,
      'metadata': metadata,
    };
  }
  
  factory GradeResult.fromJson(Map<String, dynamic> json) {
    return GradeResult(
      grade: json['grade'],
      confidence: json['confidence'],
      metadata: json['metadata'],
    );
  }
} 