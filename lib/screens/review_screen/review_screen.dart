import 'package:driver/screens/home/drawer.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:driver/utils/const/app_string.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../models/review_model_class.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final ReviewData reviewData = ReviewData.defaultData();

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
             // _buildMenuButton(context),
              const SizedBox(height: 30),
              _buildUserHeader(),
              const SizedBox(height: 30),
              _buildStatsRow(),
              const SizedBox(height: 30),
              _buildReviewsSection(),
              const SizedBox(height: 30),
              _buildAchievementsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          icon: Icon(Icons.menu, color: AppColor.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColor.light_grey,
            child: Image.asset(AppImages.userimg),
          ),
          const SizedBox(height: 10),
          AppText(
            text: reviewData.userName,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppStrings.overview,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: reviewData.stats.map((stat) => _buildStatCard(stat)).toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(OverviewStat stat) {
    return Expanded(
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          color: AppColor.light_grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                // color: stat.isHighlighted
                //     ? AppColor.appColor.withOpacity(0.4)
                //     : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(stat.imgIcon, width: 30, height: 30),
            ),
            const SizedBox(height: 10),
            AppText(
              text: stat.value,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: stat.label,
              fontSize: 12,
              color: AppColor.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: AppStrings.reviews,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: AppStrings.seeAll,
              color: AppColor.appColor,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviewData.reviews.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                width: 250,
                child: ReviewCard(review: reviewData.reviews[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppStrings.achievements,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        ...reviewData.achievements.map((achievement) =>
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 30,
                bottom: 30,
              ),
              decoration: BoxDecoration(
                color: AppColor.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AppText(text: achievement.emoji, fontSize: 24),
                  const SizedBox(width: 10),
                  AppText(
                    text: achievement.title,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    required this.review,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: review.color,
                child: AppText(
                  text: review.initial,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              AppText(
                text: review.name,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(
                5,
                    (index) => const Icon(Icons.star, size: 14, color: Colors.amber),
              ),
              const SizedBox(width: 6),
              AppText(
                text: review.daysAgo,
                fontSize: 10,
                color: AppColor.grey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            text: review.text,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}