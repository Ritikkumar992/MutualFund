import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/network_constants.dart';
import '../../../core/database_service.dart';
import '../models/scheme_model.dart';


List<Scheme> parseSchemes(String responseBody) {
  final List<dynamic> data = json.decode(responseBody);
  return data.map((json) => Scheme.fromJson(json)).toList();
}

SchemeDetailResponse parseSchemeDetails(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  return SchemeDetailResponse.fromJson(data);
}

class SchemesViewModel extends ChangeNotifier {
  List<Scheme> _allSchemes = [];
  List<Scheme> _filteredSchemes = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  List<Scheme> get schemes => _filteredSchemes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SchemeDetailResponse? _selectedSchemeDetail;
  bool _isLoadingDetail = false;
  String? _detailErrorMessage;

  SchemeDetailResponse? get selectedSchemeDetail => _selectedSchemeDetail;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailErrorMessage => _detailErrorMessage;

  Future<void> fetchSchemes() async {
    if (_allSchemes.isNotEmpty) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dbService = DatabaseService();
      final hasLocalData = await dbService.hasSchemes();

      if (hasLocalData) {
        _allSchemes = await dbService.getAllSchemes();
        _filteredSchemes = _allSchemes;
        debugPrint('Fetched ${_filteredSchemes.length} schemes from local database');

        // test to print 100 schemes
        for (int i = 0; i < 100 && i < _allSchemes.length; i++) {
          debugPrint('SchemeLocal $i: ${_allSchemes[i].schemeCode} - ${_allSchemes[i].schemeName}');
        }
      } else {
        final response = await http.get(Uri.parse(NetworkConstants.allSchemes));
        
        if (response.statusCode == 200) {
          // compute to parse JSON in a background isolate
          _allSchemes = await compute(parseSchemes, response.body);
          _filteredSchemes = _allSchemes;
          
          debugPrint('Fetched ${_allSchemes.length} schemes from network');

          // test to print 100 schemes
          for (int i = 0; i < 100 && i < _allSchemes.length; i++) {
            debugPrint('SchemeApi $i: ${_allSchemes[i].schemeCode} - ${_allSchemes[i].schemeName}');
          }

          // save all schemes to local Hive DB for instant offline loading
          await dbService.insertSchemes(_allSchemes);
        } else {
          _errorMessage = 'Failed to load schemes (Status: ${response.statusCode})';
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred while fetching schemes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterSchemes(String query) {
    if (query.isEmpty) {
      _filteredSchemes = _allSchemes;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredSchemes = _allSchemes.where((scheme) {
        return scheme.schemeName.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchSchemeDetails(int schemeCode) async {
    _isLoadingDetail = true;
    _detailErrorMessage = null;
    _selectedSchemeDetail = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(NetworkConstants.schemeDetails(schemeCode)));

      debugPrint("SchemeDetails: $response");
      
      if (response.statusCode == 200) {
        // Use compute to parse JSON in a background isolate
        _selectedSchemeDetail = await compute(parseSchemeDetails, response.body);
      } else {
        _detailErrorMessage = 'Failed to load details (Status: ${response.statusCode})';
      }
    } catch (e) {
      _detailErrorMessage = 'An error occurred while fetching details: $e';
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
