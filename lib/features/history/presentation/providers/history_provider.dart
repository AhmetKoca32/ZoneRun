import 'package:flutter/foundation.dart';

import '../../../../core/models/polygon_model.dart';
import '../../data/services/history_service.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();
  
  List<PolygonModel> _polygons = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  List<PolygonModel> get polygons => _polygons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  HistoryProvider() {
    loadHistory();
  }
  
  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _polygons = await _historyService.getHistory();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Geçmiş yüklenemedi: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> deletePolygon(int id) async {
    try {
      await _historyService.deletePolygon(id);
      // Reload history after deletion
      await loadHistory();
      return true;
    } catch (e) {
      _errorMessage = 'Polygon silinemedi: $e';
      notifyListeners();
      return false;
    }
  }
}
