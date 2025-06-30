class BookingProposalModel {
  final String bookingId;
  final int hours;
  final String date;
  final String time;
  final int price;
  final String specialRequirements;

  BookingProposalModel({
    required this.bookingId,
    required this.hours,
    required this.date,
    required this.time,
    required this.price,
    required this.specialRequirements,
  });

  factory BookingProposalModel.fromJson(Map<String, dynamic> json) {
    return BookingProposalModel(
      bookingId: json['bookingId'] ?? '',
      hours: json['hours'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      price: json['price'] ?? 0,
      specialRequirements: json['specialRequirements'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'hours': hours,
      'date': date,
      'time': time,
      'price': price,
      'specialRequirements': specialRequirements,
    };
  }
}
