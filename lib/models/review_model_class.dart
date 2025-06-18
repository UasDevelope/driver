import 'package:flutter/material.dart';

class ReviewData {
  final String userName;
  final List<OverviewStat> stats;
  final List<Review> reviews;
  final List<Achievement> achievements;

  const ReviewData({
    required this.userName,
    required this.stats,
    required this.reviews,
    required this.achievements,
  });

  // Factory method to create default data
  factory ReviewData.defaultData() {
    return const ReviewData(
      userName: "Joseph",
      stats: [
        OverviewStat(
          imgIcon: "asset/image/reviewimg.png",
          value: "5.0",
          label: "Ratings",
          isHighlighted: true,
        ),
        OverviewStat(
          imgIcon: "asset/image/satisfactionimg.png",
          value: "60%",
          label: "Satisfaction",
        ),
        OverviewStat(
          imgIcon: "asset/image/cancellationimg.png",
          value: "8%",
          label: "Cancellation Rate",
        ),
      ],
      reviews: [
        Review(
          name: "Nana Haley",
          daysAgo: "1 day ago",
          text: "ok ok ok",
          initial: "N",
          color: Colors.blue,
        ),
        Review(
          name: "Alex Wall",
          daysAgo: "1 day ago",
          text: "Good service",
          initial: "A",
          color: Colors.teal,
        ),
        Review(
          name: "Liam Smith",
          daysAgo: "2 days ago",
          text: "Very helpful!",
          initial: "L",
          color: Colors.orange,
        ),
      ],
      achievements: [
        Achievement(
          emoji: "😊",
          title: "Friendly Trainer",
        ),
      ],
    );
  }
}

class OverviewStat {
  final String imgIcon;
  final String value;
  final String label;
  final bool isHighlighted;

  const OverviewStat({
    required this.imgIcon,
    required this.value,
    required this.label,
    this.isHighlighted = false,
  });
}

class Review {
  final String name;
  final String daysAgo;
  final String text;
  final String initial;
  final Color color;

  const Review({
    required this.name,
    required this.daysAgo,
    required this.text,
    required this.initial,
    required this.color,
  });
}

class Achievement {
  final String emoji;
  final String title;

  const Achievement({
    required this.emoji,
    required this.title,
  });
}