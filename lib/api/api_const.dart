import 'package:equatable/equatable.dart';

abstract class ApiConstants extends Equatable {
  // Primary server (currently down)
  static get primaryBaseUrl => "http://54.198.124.181:5000/api";
  // Alternative server (Vercel deployment)
  static get alternativeBaseUrl => "https://training-syste-be.vercel.app/api";
  // Current active server (will be set dynamically)
  static String _currentBaseUrl = primaryBaseUrl;
  static String get baseUrl => _currentBaseUrl;
  // Method to switch to alternative server
  static void switchToAlternativeServer() {
    _currentBaseUrl = alternativeBaseUrl;
  }
  // Method to switch back to primary server
  static void switchToPrimaryServer() {
    _currentBaseUrl = primaryBaseUrl;
  }
  // API endpoints using dynamic base URL
  static String get register => '$baseUrl/auth/register';
  static String get login => "$baseUrl/auth/login";
  static String get updateLocation => "$baseUrl/users/location";
  static String get makeBooking => "$baseUrl/bookings";
  static String get feedback => "$baseUrl/feedback";
  static String get submitProposal => "$baseUrl/bookings/proposals";
  static String get fetchBooking => "$baseUrl/Bookings";
  static String get pendingBookings => "$baseUrl/bookings/pending";
  static String get submittedBookings => "$baseUrl/bookings/submitted";
  static String get rejectedBookings => "$baseUrl/bookings/rejected";
  static String get getProfile => "$baseUrl/users/profile";
  static String get inProgressBookings => "$baseUrl/bookings/inprogress";
  static String get completedBookings => "$baseUrl/bookings/completed";
  static String get fetchEarnings => "$baseUrl/service-providers/earnings";
  static String get fetchRecentOrders =>
      "$baseUrl/service-providers/completed-bookings";
  static String get getHistory => "$baseUrl/users/transaction-history";
  static String get getChatHistory => "$baseUrl/chat";
  static String get sendChatMessage => "$baseUrl/chat/message";
  static String get getChatMessages => "$baseUrl/chat/messages";
  static String get deleteAccount => "$baseUrl/auth/delete";

  // Socket URLs
  static String get socketUrl => _currentBaseUrl.replaceAll('/api', '');
  static String get socketUrlAlternative =>
      "https://training-syste-be.vercel.app";
}
