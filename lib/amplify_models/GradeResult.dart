/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the GradeResult type in your schema. */
class GradeResult extends amplify_core.Model {
  static const classType = const _GradeResultModelType();
  final String id;
  final String? _userId;
  final double? _score;
  final int? _totalQuestions;
  final int? _correctAnswers;
  final amplify_core.TemporalDateTime? _timestamp;
  final List<Question>? _questions;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GradeResultModelIdentifier get modelIdentifier {
      return GradeResultModelIdentifier(
        id: id
      );
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get score {
    try {
      return _score!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get totalQuestions {
    try {
      return _totalQuestions!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get correctAnswers {
    try {
      return _correctAnswers!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Question>? get questions {
    return _questions;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const GradeResult._internal({required this.id, required userId, required score, required totalQuestions, required correctAnswers, required timestamp, questions, createdAt, updatedAt}): _userId = userId, _score = score, _totalQuestions = totalQuestions, _correctAnswers = correctAnswers, _timestamp = timestamp, _questions = questions, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory GradeResult({String? id, required String userId, required double score, required int totalQuestions, required int correctAnswers, required amplify_core.TemporalDateTime timestamp, List<Question>? questions}) {
    return GradeResult._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      timestamp: timestamp,
      questions: questions != null ? List<Question>.unmodifiable(questions) : questions);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GradeResult &&
      id == other.id &&
      _userId == other._userId &&
      _score == other._score &&
      _totalQuestions == other._totalQuestions &&
      _correctAnswers == other._correctAnswers &&
      _timestamp == other._timestamp &&
      DeepCollectionEquality().equals(_questions, other._questions);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("GradeResult {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("score=" + (_score != null ? _score!.toString() : "null") + ", ");
    buffer.write("totalQuestions=" + (_totalQuestions != null ? _totalQuestions!.toString() : "null") + ", ");
    buffer.write("correctAnswers=" + (_correctAnswers != null ? _correctAnswers!.toString() : "null") + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  GradeResult copyWith({String? userId, double? score, int? totalQuestions, int? correctAnswers, amplify_core.TemporalDateTime? timestamp, List<Question>? questions}) {
    return GradeResult._internal(
      id: id,
      userId: userId ?? this.userId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      timestamp: timestamp ?? this.timestamp,
      questions: questions ?? this.questions);
  }
  
  GradeResult copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<double>? score,
    ModelFieldValue<int>? totalQuestions,
    ModelFieldValue<int>? correctAnswers,
    ModelFieldValue<amplify_core.TemporalDateTime>? timestamp,
    ModelFieldValue<List<Question>?>? questions
  }) {
    return GradeResult._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      score: score == null ? this.score : score.value,
      totalQuestions: totalQuestions == null ? this.totalQuestions : totalQuestions.value,
      correctAnswers: correctAnswers == null ? this.correctAnswers : correctAnswers.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      questions: questions == null ? this.questions : questions.value
    );
  }
  
  GradeResult.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _score = (json['score'] as num?)?.toDouble(),
      _totalQuestions = (json['totalQuestions'] as num?)?.toInt(),
      _correctAnswers = (json['correctAnswers'] as num?)?.toInt(),
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _questions = json['questions']  is Map
        ? (json['questions']['items'] is List
          ? (json['questions']['items'] as List)
              .where((e) => e != null)
              .map((e) => Question.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['questions'] is List
          ? (json['questions'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Question.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'score': _score, 'totalQuestions': _totalQuestions, 'correctAnswers': _correctAnswers, 'timestamp': _timestamp?.format(), 'questions': _questions?.map((Question? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'score': _score,
    'totalQuestions': _totalQuestions,
    'correctAnswers': _correctAnswers,
    'timestamp': _timestamp,
    'questions': _questions,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GradeResultModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GradeResultModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final SCORE = amplify_core.QueryField(fieldName: "score");
  static final TOTALQUESTIONS = amplify_core.QueryField(fieldName: "totalQuestions");
  static final CORRECTANSWERS = amplify_core.QueryField(fieldName: "correctAnswers");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final QUESTIONS = amplify_core.QueryField(
    fieldName: "questions",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Question'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "GradeResult";
    modelSchemaDefinition.pluralName = "GradeResults";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GradeResult.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GradeResult.SCORE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GradeResult.TOTALQUESTIONS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GradeResult.CORRECTANSWERS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: GradeResult.TIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: GradeResult.QUESTIONS,
      isRequired: false,
      ofModelName: 'Question',
      associatedKey: Question.GRADERESULT
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _GradeResultModelType extends amplify_core.ModelType<GradeResult> {
  const _GradeResultModelType();
  
  @override
  GradeResult fromJson(Map<String, dynamic> jsonData) {
    return GradeResult.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'GradeResult';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [GradeResult] in your schema.
 */
class GradeResultModelIdentifier implements amplify_core.ModelIdentifier<GradeResult> {
  final String id;

  /** Create an instance of GradeResultModelIdentifier using [id] the primary key. */
  const GradeResultModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'GradeResultModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GradeResultModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}