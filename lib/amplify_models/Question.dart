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


/** This is an auto generated class representing the Question type in your schema. */
class Question extends amplify_core.Model {
  static const classType = const _QuestionModelType();
  final String id;
  final String? _text;
  final String? _correctAnswer;
  final List<String>? _options;
  final String? _explanation;
  final GradeResult? _gradeResult;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  QuestionModelIdentifier get modelIdentifier {
      return QuestionModelIdentifier(
        id: id
      );
  }
  
  String get text {
    try {
      return _text!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get correctAnswer {
    try {
      return _correctAnswer!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String> get options {
    try {
      return _options!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get explanation {
    return _explanation;
  }
  
  GradeResult? get gradeResult {
    return _gradeResult;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Question._internal({required this.id, required text, required correctAnswer, required options, explanation, gradeResult, createdAt, updatedAt}): _text = text, _correctAnswer = correctAnswer, _options = options, _explanation = explanation, _gradeResult = gradeResult, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Question({String? id, required String text, required String correctAnswer, required List<String> options, String? explanation, GradeResult? gradeResult}) {
    return Question._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      text: text,
      correctAnswer: correctAnswer,
      options: options != null ? List<String>.unmodifiable(options) : options,
      explanation: explanation,
      gradeResult: gradeResult);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Question &&
      id == other.id &&
      _text == other._text &&
      _correctAnswer == other._correctAnswer &&
      DeepCollectionEquality().equals(_options, other._options) &&
      _explanation == other._explanation &&
      _gradeResult == other._gradeResult;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Question {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("text=" + "$_text" + ", ");
    buffer.write("correctAnswer=" + "$_correctAnswer" + ", ");
    buffer.write("options=" + (_options != null ? _options!.toString() : "null") + ", ");
    buffer.write("explanation=" + "$_explanation" + ", ");
    buffer.write("gradeResult=" + (_gradeResult != null ? _gradeResult!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Question copyWith({String? text, String? correctAnswer, List<String>? options, String? explanation, GradeResult? gradeResult}) {
    return Question._internal(
      id: id,
      text: text ?? this.text,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      explanation: explanation ?? this.explanation,
      gradeResult: gradeResult ?? this.gradeResult);
  }
  
  Question copyWithModelFieldValues({
    ModelFieldValue<String>? text,
    ModelFieldValue<String>? correctAnswer,
    ModelFieldValue<List<String>?>? options,
    ModelFieldValue<String?>? explanation,
    ModelFieldValue<GradeResult?>? gradeResult
  }) {
    return Question._internal(
      id: id,
      text: text == null ? this.text : text.value,
      correctAnswer: correctAnswer == null ? this.correctAnswer : correctAnswer.value,
      options: options == null ? this.options : options.value,
      explanation: explanation == null ? this.explanation : explanation.value,
      gradeResult: gradeResult == null ? this.gradeResult : gradeResult.value
    );
  }
  
  Question.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _text = json['text'],
      _correctAnswer = json['correctAnswer'],
      _options = json['options']?.cast<String>(),
      _explanation = json['explanation'],
      _gradeResult = json['gradeResult'] != null
        ? json['gradeResult']['serializedData'] != null
          ? GradeResult.fromJson(new Map<String, dynamic>.from(json['gradeResult']['serializedData']))
          : GradeResult.fromJson(new Map<String, dynamic>.from(json['gradeResult']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'text': _text, 'correctAnswer': _correctAnswer, 'options': _options, 'explanation': _explanation, 'gradeResult': _gradeResult?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'text': _text,
    'correctAnswer': _correctAnswer,
    'options': _options,
    'explanation': _explanation,
    'gradeResult': _gradeResult,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<QuestionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<QuestionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TEXT = amplify_core.QueryField(fieldName: "text");
  static final CORRECTANSWER = amplify_core.QueryField(fieldName: "correctAnswer");
  static final OPTIONS = amplify_core.QueryField(fieldName: "options");
  static final EXPLANATION = amplify_core.QueryField(fieldName: "explanation");
  static final GRADERESULT = amplify_core.QueryField(
    fieldName: "gradeResult",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GradeResult'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Question";
    modelSchemaDefinition.pluralName = "Questions";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Question.TEXT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Question.CORRECTANSWER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Question.OPTIONS,
      isRequired: true,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Question.EXPLANATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Question.GRADERESULT,
      isRequired: false,
      targetNames: ['gradeResultId'],
      ofModelName: 'GradeResult'
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

class _QuestionModelType extends amplify_core.ModelType<Question> {
  const _QuestionModelType();
  
  @override
  Question fromJson(Map<String, dynamic> jsonData) {
    return Question.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Question';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Question] in your schema.
 */
class QuestionModelIdentifier implements amplify_core.ModelIdentifier<Question> {
  final String id;

  /** Create an instance of QuestionModelIdentifier using [id] the primary key. */
  const QuestionModelIdentifier({
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
  String toString() => 'QuestionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is QuestionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}