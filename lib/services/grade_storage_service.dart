import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grade_result.dart';

class GradeStorageService {
  static const String _storageKey = 'grade_results';
  
  // Save a grade result to local storage
  Future<void> saveGradeResult(GradeResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing results
    List<GradeResult> results = await getGradeResults();
    
    // Add new result to the beginning of the list
    results.insert(0, result);
    
    // Convert to JSON and save
    final String jsonString = json.encode(
      results.map((result) => result.toMap()).toList(),
    );
    
    await prefs.setString(_storageKey, jsonString);
  }
  
  // Get the last 2 grade results from local storage
  Future<List<GradeResult>> getRecentGradeResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    debugPrint('jsonString: $jsonString');
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final allResults = jsonList.map((json) => GradeResult.fromMap(json)).toList();
      // Return only the last 2 results
      return allResults.take(2).toList();
    } catch (e) {
      debugPrint('Error parsing grade results: $e');
      return [];
    }
  }

  Future<List<GradeResult>> getGradeResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    
    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => GradeResult.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error parsing grade results: $e');
      return [];
    }
  }
  
  // Get a specific grade result by ID
  Future<GradeResult?> getGradeResultById(String id) async {
    final results = await getGradeResults();
    try {
      return results.firstWhere((result) => result.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Delete a grade result by ID
  Future<void> deleteGradeResult(String id) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing results
    List<GradeResult> results = await getGradeResults();
    
    // Remove the result with the matching ID
    results.removeWhere((result) => result.id == id);
    
    // Convert to JSON and save
    final String jsonString = json.encode(
      results.map((result) => result.toMap()).toList(),
    );
    
    await prefs.setString(_storageKey, jsonString);
  }
  
  // Clear all grade results
  Future<void> clearAllGradeResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
} 