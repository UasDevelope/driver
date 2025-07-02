import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../widgets/app_text.dart';

class BookingCard extends StatelessWidget {
  final OrdersModel item;
  final VoidCallback? onPaymentPressed;

  const BookingCard({
    super.key,
    required this.item,
    this.onPaymentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColor.appColor,
                  child: AppText(
                    text:item.customerName?.substring(0, 1).toUpperCase() ?? '?',
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width* 0.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppText(
                              text: item.customerName ?? 'Unknown',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          AppText(
                            text: "No of Hours: ${item.hours ?? "-"}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ],
                      ),
                    ),
                    AppText(
                      text: 'ID: ${item.bookingId ?? "-"}',
                      color: AppColor.grey,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppText(
              text: "Assigned Driver: ${item.assignedDriver ?? "Not assigned"}",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.black,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  AppImages.driving,
                  color: AppColor.blue,
                  height: 30,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text:
                    "Driving Permit Number: ${item.driverPermitNumber ?? "-"}",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Image.asset(
                  AppImages.mylocation,
                  color: AppColor.blue,
                  height: 30,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AppText(
                    text: item.locationName!, // Consider using location
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Image.asset(
                  AppImages.calendar,
                  height: 30,
                  color: AppColor.blue,
                ),
                const SizedBox(width: 6),
                AppText(
                  text: item.date != null
                      ? DateFormat('dd/MMM/yyyy').format(item.date!)
                      : '-',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 30),
                const SizedBox(width: 4),
                AppText(
                  text: item.time ?? "-",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColor.black,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Price: ',
                children: [
                  TextSpan(
                    text: "${item.price?.toStringAsFixed(1) ?? "-"}\$",
                    style: TextStyle(
                      color: AppColor.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //
            // const SizedBox(height: 10),
            //
            // SizedBox(
            //   width: double.infinity,
            //   child: AppButton(
            //     borderRadius: 16,
            //     backgroundColor: Colors.white,
            //     border: const BorderSide(width: 1),
            //     textColor: AppColor.black,
            //     text: AppStrings.labelPayment,
            //     onPressed: onPaymentPressed ?? () {},
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
