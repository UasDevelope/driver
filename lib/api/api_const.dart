import 'package:equatable/equatable.dart';

abstract class ApiConstants extends Equatable {
  static get BASEURL => "https://training-syste-be.vercel.app/api";
  static get register => '$BASEURL/auth/register';
  static get login => "$BASEURL/auth/login";
  static get updateLocation => "$BASEURL/users/location";
  static get makeBooking => "$BASEURL/bookings";
  static get feedback => "$BASEURL/feedback";
  static get submitProposal => "$BASEURL/bookings/proposals";
  static get fetchBooking=>"$BASEURL/Bookings";
  static get pendingBookings =>"$BASEURL/bookings/pending";
  static get submittedBookings =>"$BASEURL/bookings/submitted";
  static get rejectedBookings =>"$BASEURL/bookings/rejected";
  static get getProfile =>"$BASEURL/users/profile";
  static get inProgressBookings =>"$BASEURL//bookings/inprogress";
  static get completedBookings =>"$BASEURL//bookings/completed";
  static get fetchEarnings =>"$BASEURL/service-providers/earnings";
  static get fetchRecentOrders =>"$BASEURL/service-providers/completed-bookings";
  static get getHistory => "$BASEURL/users/transaction-history";
}