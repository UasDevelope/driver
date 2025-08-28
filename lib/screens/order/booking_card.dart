import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../chat/inbox.dart';
import '../proposal/proposal_screen.dart';
import '../../core/app_routes.dart';

class BookingCard extends StatelessWidget {
  final OrdersModel item;
  final VoidCallback? onPaymentPressed;
  final bool isPending;

  const BookingCard({
    super.key,
    required this.item,
    this.onPaymentPressed,
    this.isPending = false,
  });

    @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.appColor, AppColor.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.appColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.transparent,
                    child: AppText(
                      text: item.customerName?.substring(0, 1).toUpperCase() ?? '?',
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: AppColor.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
                          Row(
                            children: [
                              // Chat button - always visible for testing
                              GestureDetector(
                                onTap: () {
                                  print("Chat button tapped!");
                                  print("Booking ID: ${item.bookingId}");
                                  print("Customer Name: ${item.customerName}");
                                  print("Status: ${item.status}");
                                  
                                  print("About to navigate with arguments:");
                                  print("bookingId: ${item.bookingId}");
                                  print("customerName: ${item.customerName}");
                                  
                                  // Try direct navigation instead of named route
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ChatInbox(),
                                      settings: RouteSettings(
                                        name: AppRoutes.chatInbox,
                                        arguments: <String, dynamic>{
                                          'bookingId': item.bookingId,
                                          'customerName': item.customerName,
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.green, Colors.green.shade600],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              AppText(
                                text: "No of Hours: ${item.hours ?? "-"}",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColor.appColor,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          text: "Assigned Driver: ${item.assignedDriver ?? "Not assigned"}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AppImages.driving,
                          color: AppColor.blue,
                          height: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          text: "Driving Permit Number: ${item.driverPermitNumber ?? "-"}",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AppImages.mylocation,
                          color: Colors.green,
                          height: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          text: item.locationName ?? "Location not specified",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AppImages.calendar,
                          height: 16,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 12),
                      AppText(
                        text: item.date != null
                            ? DateFormat('dd/MMM/yyyy').format(item.date!)
                            : '-',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.access_time, size: 16, color: Colors.purple),
                      ),
                      SizedBox(width: 12),
                      AppText(
                        text: item.time ?? "-",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ],
                  ),
                            ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.appColor.withOpacity(0.1), AppColor.lightGreen.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.appColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.appColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Total Price",
                        fontSize: 12,
                        color: AppColor.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      AppText(
                        text: "\$${item.price?.toStringAsFixed(1) ?? "-"}",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.appColor,
                      ),
                    ],
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
            if (isPending) ...[
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: AppButton(
                  backgroundColor: AppColor.appColor,
                  borderRadius: 12,
                  text: "Send Proposal",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProposalScreen(
                          bookingId: item.bookingId,
                          noOfHours: item.hours!,
                          dateTime: item.date!,
                          price: item.price!,
                          time: item.time!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'inprogress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'submitted':
        return Colors.purple;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
