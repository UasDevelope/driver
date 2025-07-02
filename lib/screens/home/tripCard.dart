import 'package:driver/blocs/home/bloc.dart';
import 'package:driver/blocs/home/state.dart';
import 'package:driver/blocs/location/state.dart';
import 'package:driver/models/order.dart';
import 'package:driver/screens/proposal/proposal_screen.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:geocoding/geocoding.dart';

import '../../blocs/home/event.dart';
import '../../widgets/custom_button.dart';

class TripCard extends StatelessWidget {
  final OrdersModel data;

  TripCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(
      FetchLocationDetailsEvent(
        latitude: data.latitude!,
        longitude: data.longitude!,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: '\$${data.price?.toStringAsFixed(2) ?? '0.00'}',
                  color: AppColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade200,
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                //   child: Row(
                //     children: [
                //       const Icon(Icons.person, size: 20, color: Colors.grey),
                //       const SizedBox(width: 4),
                //       const Icon(Icons.star, size: 16, color: Colors.amber),
                //       const SizedBox(width: 4),
                //       Text(
                //         data.studentRating.toStringAsFixed(1),
                //         style: const TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    Dash(
                      direction: Axis.vertical,
                      length: 50,
                      dashLength: 5,
                      dashColor: Colors.black,
                    ),
                    const Icon(Icons.location_on, color: Colors.black),
                  ],
                ),
                const SizedBox(width: 12),

                // Address texts
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen:
                        (previous, current) =>
                            current is LocationLoading ||
                            current is LocationLoaded,
                    builder: (context, state) {
                      if (state is LocationLoading) {
                        return Center(
                          child: AppText(
                            text: "Loading...",
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      } else if (state is LocationLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "${state.country} ${state.city}" ?? "Start Address",
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: state.address ?? "",
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 12),
                            AppText(
                              text:
                              data.locationName ??
                                  "End Address",
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: data.locationName ?? "",
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: data.locationName ?? "Start Address",
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: data.locationName ?? "",
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 12),
                            AppText(
                              text: "No End Address",
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: "",
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColor.appColor,
                    child: AppText(
                      text:
                          (data.customerName?.isNotEmpty ?? false)
                              ? data.customerName![0].toUpperCase()
                              : 'U',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: data.customerName ?? 'User Name',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 100,
                        child: AppText(
                          text: 'ID: ${data.bookingId?.substring(data.bookingId!.length - 5) ?? 'Unknown'}',
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    child: AppText(
                      text: 'No of Hours : ${data.hours ?? 0}',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                backgroundColor: AppColor.appColor,
                width: 200,
                text: "Send Proposal",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ProposalScreen(bookingId: data.bookingId, noOfHours: data.hours!,dateTime: data.date!,price: data.price!,time: data.time!,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
