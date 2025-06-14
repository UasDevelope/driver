import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Sample list of review data
  final List<Map<String, dynamic>> reviews = const [
    {
      "name": "Nana Haley",
      "daysAgo": "1 day ago",
      "review": "ok ok ok",
      "initial": "N",
      "color": Colors.blue,
    },
    {
      "name": "Alex Wall",
      "daysAgo": "1 day ago",
      "review": "Good service",
      "initial": "A",
      "color": Colors.teal,
    },
    {
      "name": "Liam Smith",
      "daysAgo": "2 days ago",
      "review": "Very helpful!",
      "initial": "L",
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xffE4E9F2),
                  child: Icon(Icons.person, size: 50, color: Color(0xff2A66B6)),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Joseph',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _overviewCard(Icons.star, "5.0", "Ratings", true),
                  _overviewCard(Icons.person, "60%", "Satisfy", false),
                  _overviewCard(Icons.cancel_outlined, "8%", "Cancel", false),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("See all", style: TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final item = reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 250,
                      child: ReviewCard(
                        name: item["name"],
                        daysAgo: item["daysAgo"],
                        review: item["review"],
                        initial: item["initial"],
                        color: item["color"],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text("Achievements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Text("😊", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 10),
                    Text("Friendly Trainer", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _overviewCard(IconData icon, String value, String label, bool check) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xfff8f7fb),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          check
              ? Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xff7FBD42).withOpacity(0.4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: const Color(0xff7FBD42), size: 20),
          )
              : Icon(icon, color: const Color(0xff7FBD42), size: 20),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String daysAgo;
  final String review;
  final String initial;
  final Color color;

  const ReviewCard({
    required this.name,
    required this.daysAgo,
    required this.review,
    required this.initial,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: 220,
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row with Avatar and Name
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: color,
                child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),

          // Rating Row
          Row(
            children: [
              ...List.generate(
                5,
                    (index) => const Icon(Icons.star, size: 14, color: Colors.amber),
              ),
              const SizedBox(width: 6),
              Text(daysAgo, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),

          // Review Text
          Text(
            review,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

