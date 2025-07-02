import 'package:driver/blocs/profile/profile_bloc.dart';
import 'package:driver/models/profile_model.dart';
import 'package:driver/utils/const/app_string.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:driver/utils/const/toast_helper.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/review_model_class.dart';
import '../../utils/const/app_img.dart';
import '../home/drawer.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({super.key});

  final ReviewData reviewData = ReviewData.defaultData();

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(GetProfileEvent());
    return Scaffold(
       drawer: CustomDrawer(
      userName: "Joseph",
      profileImage: AppImages.person,
    ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.appColor),
              );
            } else if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder:
                          (context) =>
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                              color: Colors.black,
                            ),
                          ),
                    ),
                    _buildUserHeader(state.profile.user.fullName),
                    const SizedBox(height: 30),
                    _buildStatsRow(
                      state.profile.rating ?? 0.0,
                      state.profile.satisfaction,
                      state.profile.cancellationRate,
                    ),
                    const SizedBox(height: 30),
                    _buildReviewsSection(state.profile.reviews),
                    const SizedBox(height: 30),
                    _buildAchievementsSection(state.profile.achievements),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              ToastHelper.showToast(message: state.message);
              return Center(child: AppText(text: state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Builder(
      builder:
          (context) => Container(
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

  Widget _buildUserHeader(String userName) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColor.appColor,
            child: AppText(
              text: userName.isNotEmpty ? userName[0].toUpperCase() : '',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          AppText(text: userName, fontSize: 20, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    double rating,
    String satisfaction,
    String cancellation,
  ) {
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
          children: [
            _buildStatCard(
              rating.toString(),
              "Ratings",
              'asset/image/reviewimg.png',
            ),
            _buildStatCard(
              satisfaction,
              "Satisfaction",
              "asset/image/satisfactionimg.png",
            ),
            _buildStatCard(
              cancellation,
              "Cancellation Rate",
              "asset/image/cancellationimg.png",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String rating, String name, String logo) {
    return Expanded(
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
              child: Image.asset(logo, width: 30, height: 30),
            ),
            const SizedBox(height: 10),
            AppText(text: rating, fontSize: 16, fontWeight: FontWeight.bold),
            AppText(text: name, fontSize: 12, color: AppColor.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(List<ReviewModel> reviews) {
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
            AppText(text: AppStrings.seeAll, color: AppColor.appColor),
          ],
        ),
        const SizedBox(height: 10),
        reviews.isNotEmpty
            ? SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 250,
                    child: ReviewCard(review: reviews[index]),
                  );
                },
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildAchievementsSection(List<String> achievement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: AppStrings.achievements,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        ...achievement.map(
          (achievement) => Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: AppColor.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                AppText(text: "😍", fontSize: 24),
                const SizedBox(width: 10),
                AppText(text: achievement, fontSize: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({required this.review, super.key});

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
                backgroundColor: AppColor.appColor,
                child: AppText(
                  text:
                      review.reviewer.isNotEmpty
                          ? review.reviewer[0].toUpperCase()
                          : '',
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              AppText(text: review.reviewer, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              ...List.generate(
                review.rating,
                (index) =>
                    const Icon(Icons.star, size: 14, color: Colors.amber),
              ),
              const SizedBox(width: 6),
              AppText(
                text: DateFormat('dd MMM yyyy').format(review.date),
                fontSize: 10,
                color: AppColor.grey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(text: review.comment, fontSize: 14),
        ],
      ),
    );
  }
}
