import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../amplify_models/ModelProvider.dart';

class AmplifyGraphQLService {
  static const String _createGradeResult = r'''
    mutation CreateGradeResult(
      $input: CreateGradeResultInput!
    ) {
      createGradeResult(input: $input) {
        id
        userId
        score
        totalQuestions
        correctAnswers
        timestamp
      }
    }
  ''';

  static const String _getGradeResult = r'''
    query GetGradeResult($id: ID!) {
      getGradeResult(id: $id) {
        id
        userId
        score
        totalQuestions
        correctAnswers
        timestamp
        questions {
          items {
            id
            text
            correctAnswer
            options
            explanation
          }
        }
      }
    }
  ''';

  static const String _listGradeResults = r'''
    query ListGradeResults(
      $filter: ModelGradeResultFilterInput
      $limit: Int
      $nextToken: String
    ) {
      listGradeResults(filter: $filter, limit: $limit, nextToken: $nextToken) {
        items {
          id
          userId
          score
          totalQuestions
          correctAnswers
          timestamp
        }
        nextToken
      }
    }
  ''';

  static const String _createQuestion = r'''
    mutation CreateQuestion(
      $input: CreateQuestionInput!
    ) {
      createQuestion(input: $input) {
        id
        text
        correctAnswer
        options
        explanation
        gradeResultId
      }
    }
  ''';

  static const String _getQuestion = r'''
    query GetQuestion($id: ID!) {
      getQuestion(id: $id) {
        id
        text
        correctAnswer
        options
        explanation
        gradeResultId
      }
    }
  ''';

  static const String _listQuestions = r'''
    query ListQuestions(
      $filter: ModelQuestionFilterInput
      $limit: Int
      $nextToken: String
    ) {
      listQuestions(filter: $filter, limit: $limit, nextToken: $nextToken) {
        items {
          id
          text
          correctAnswer
          options
          explanation
          gradeResultId
        }
        nextToken
      }
    }
  ''';

  // GradeResult operations
  Future<GradeResult> createGradeResult(GradeResult gradeResult) async {
    try {
      final request = GraphQLRequest<String>(
        document: _createGradeResult,
        variables: {
          'input': gradeResult.toJson(),
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      return GradeResult.fromJson(data['createGradeResult']);
    } catch (e) {
      safePrint('Error creating grade result: $e');
      rethrow;
    }
  }

  Future<GradeResult?> getGradeResult(String id) async {
    try {
      final request = GraphQLRequest<String>(
        document: _getGradeResult,
        variables: {
          'id': id,
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      return data['getGradeResult'] != null
          ? GradeResult.fromJson(data['getGradeResult'])
          : null;
    } catch (e) {
      safePrint('Error getting grade result: $e');
      rethrow;
    }
  }

  Future<List<GradeResult>> listGradeResults({
    Map<String, dynamic>? filter,
    int? limit,
    String? nextToken,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: _listGradeResults,
        variables: {
          'filter': filter,
          'limit': limit,
          'nextToken': nextToken,
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      final items = data['listGradeResults']['items'] as List;
      return items.map((item) => GradeResult.fromJson(item)).toList();
    } catch (e) {
      safePrint('Error listing grade results: $e');
      rethrow;
    }
  }

  // Question operations
  Future<Question> createQuestion(Question question) async {
    try {
      final request = GraphQLRequest<String>(
        document: _createQuestion,
        variables: {
          'input': question.toJson(),
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      return Question.fromJson(data['createQuestion']);
    } catch (e) {
      safePrint('Error creating question: $e');
      rethrow;
    }
  }

  Future<Question?> getQuestion(String id) async {
    try {
      final request = GraphQLRequest<String>(
        document: _getQuestion,
        variables: {
          'id': id,
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      return data['getQuestion'] != null
          ? Question.fromJson(data['getQuestion'])
          : null;
    } catch (e) {
      safePrint('Error getting question: $e');
      rethrow;
    }
  }

  Future<List<Question>> listQuestions({
    Map<String, dynamic>? filter,
    int? limit,
    String? nextToken,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: _listQuestions,
        variables: {
          'filter': filter,
          'limit': limit,
          'nextToken': nextToken,
        },
      );

      final response = await Amplify.API.query(request: request).response;
      final data = jsonDecode(response.data ?? '{}');
      final items = data['listQuestions']['items'] as List;
      return items.map((item) => Question.fromJson(item)).toList();
    } catch (e) {
      safePrint('Error listing questions: $e');
      rethrow;
    }
  }
}
