import 'dart:developer';
import 'package:http/http.dart' as http;
import '../api/api_const.dart';

class ServerHealthChecker {
  static bool _isChecking = false;
  static bool _primaryServerHealthy = true;
  static bool _alternativeServerHealthy = true;
  
  /// Check if primary server is healthy
  static Future<bool> checkPrimaryServer() async {
    if (_isChecking) return _primaryServerHealthy;
    
    _isChecking = true;
    try {
      log("🔍 Checking primary server health...");
      
      final response = await http.get(
        Uri.parse('${ApiConstants.primaryBaseUrl.replaceAll('/api', '')}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      _primaryServerHealthy = response.statusCode == 200;
      log("✅ Primary server is ${_primaryServerHealthy ? 'healthy' : 'unhealthy'}");
      
      return _primaryServerHealthy;
    } catch (e) {
      log("❌ Primary server health check failed: $e");
      _primaryServerHealthy = false;
      return false;
    } finally {
      _isChecking = false;
    }
  }
  
  /// Check if alternative server is healthy
  static Future<bool> checkAlternativeServer() async {
    try {
      log("🔍 Checking alternative server health...");
      
      final response = await http.get(
        Uri.parse('${ApiConstants.alternativeBaseUrl.replaceAll('/api', '')}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      _alternativeServerHealthy = response.statusCode == 200;
      log("✅ Alternative server is ${_alternativeServerHealthy ? 'healthy' : 'unhealthy'}");
      
      return _alternativeServerHealthy;
    } catch (e) {
      log("❌ Alternative server health check failed: $e");
      _alternativeServerHealthy = false;
      return false;
    }
  }
  
  /// Auto-switch to best available server
  static Future<void> autoSwitchToBestServer() async {
    log("🔄 Auto-switching to best available server...");
    
    // Check primary server first
    final primaryHealthy = await checkPrimaryServer();
    if (primaryHealthy) {
      ApiConstants.switchToPrimaryServer();
      log("✅ Switched to primary server");
      return;
    }
    
    // If primary is down, check alternative
    final alternativeHealthy = await checkAlternativeServer();
    if (alternativeHealthy) {
      ApiConstants.switchToAlternativeServer();
      log("✅ Switched to alternative server");
      return;
    }
    
    // If both are down, stay with current (could be either)
    log("⚠️ Both servers appear to be down, staying with current server");
  }
  
  /// Get current server status
  static Map<String, bool> getServerStatus() {
    return {
      'primary': _primaryServerHealthy,
      'alternative': _alternativeServerHealthy,
      'current': ApiConstants.baseUrl == ApiConstants.primaryBaseUrl,
    };
  }
  
  /// Check if any server is available
  static bool get isAnyServerAvailable => _primaryServerHealthy || _alternativeServerHealthy;
  
  /// Get current server URL
  static String get currentServerUrl => ApiConstants.baseUrl;
}
