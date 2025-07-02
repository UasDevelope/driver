import 'package:driver/blocs/propsal/proposal_state.dart';
import 'package:driver/blocs/propsal/propsal_bloc.dart';
import 'package:driver/models/booking_proposal_model.dart';
import 'package:driver/utils/const/toast_helper.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/propsal/propsal_event.dart';
import '../../services/dateTime.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/form_field.dart';

class ProposalScreen extends StatelessWidget {
  final String? bookingId;
  final int noOfHours;
  final DateTime dateTime;
  final int price;
  final String time;

  const ProposalScreen({
    super.key,
    this.bookingId,
    required this.noOfHours,
    required this.dateTime,
    required this.price,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    bool isInitialized = false;
    return Material(
      color: AppColor.white,
      child: BlocListener<ProposalBloc, ProposalState>(
        listener: (context, state) {},
        child: BlocListener<ProposalBloc, ProposalState>(
          listener: (context, state) {
            if (state is LoadedProposalSend) {
              ToastHelper.showToast(message: state.response["message"]);
              context.read<ProposalBloc>().add(ClearController());
              Navigator.pop(context);
            } else if (state is ProposalError) {
              ToastHelper.showToast(message: state.message);
              context.read<ProposalBloc>().add(ClearController());
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<ProposalBloc, ProposalState>(
            builder: (context, state) {
              final proposalBloc = context.read<ProposalBloc>();

              // ✅ Set initial values once (only when isInitialized is false)
              if (!isInitialized) {
                proposalBloc.Nohrs.text = noOfHours.toString();
                proposalBloc.selectedDate = dateTime;
                proposalBloc.date.text = DateFormat(
                  "dd/MMM/yyyy",
                ).format(dateTime);
                proposalBloc.time.text = time;
                proposalBloc.price.text = price.toString();
                isInitialized = true; // ensure it's not re-executed on rebuild
              }

              return state is LoadingProposalSend
                  ? Center(
                    child: CircularProgressIndicator(color: AppColor.appColor),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          AppText(
                            text: "Send Proposal",
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 6),
                          const AppText(
                            text: "Edit this according to your choice",
                          ),
                          const SizedBox(height: 20),

                          /// Hours
                          AppTextFormField(
                            controller: proposalBloc.Nohrs,
                            hintText: "Enter No. of Hours",
                            isNumeric: true,
                            validator: AppValidators.validateRequired,
                            prefixIcon: AppImages.time,
                          ),
                          const SizedBox(height: 12),

                          /// Date Picker
                          AppTextFormField(
                            controller: proposalBloc.date,
                            hintText: "Select date",
                            prefixIcon: AppImages.calendar,
                            readOnly: true,
                            onTap: () async {
                              final picked = await DateTimeHelper.pickDateTime(
                                context,
                              );
                              if (picked != null) {
                                // Update fields
                                proposalBloc.date.text = DateFormat(
                                  "dd/MMM/yyyy",
                                ).format(picked);
                                proposalBloc.time.text = DateFormat(
                                  "hh:mm a",
                                ).format(picked);
                                proposalBloc.selectedDate = picked;

                                // Notify Bloc (optional if needed)
                                context.read<ProposalBloc>().add(
                                  UpdateDateTime(dateTime: picked),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 12),

                          /// Price
                          AppTextFormField(
                            controller: proposalBloc.price,
                            isNumeric: true,
                            hintText: "Enter price",
                            validator: AppValidators.validateRequired,
                            prefixIcon: AppImages.coin,
                          ),
                          const SizedBox(height: 12),

                          /// Requirements
                          AppTextFormField(
                            controller: proposalBloc.writeSomething,
                            hintText: "Enter Requirements",
                          ),
                          const SizedBox(height: 24),

                          /// Submit
                          AppButton(
                            text: "Send Proposal",
                            onPressed: () {
                              final proposal = BookingProposalModel(
                                bookingId: bookingId!,
                                hours:
                                    int.tryParse(proposalBloc.Nohrs.text) ?? 0,
                                date: proposalBloc.date.text,
                                time: proposalBloc.time.text,
                                price:
                                    int.tryParse(proposalBloc.price.text) ?? 0,
                                specialRequirements:
                                    proposalBloc.writeSomething.text,
                              );

                              context.read<ProposalBloc>().add(
                                SubmitProposalEvent(proposalModel: proposal),
                              );
                            },
                            backgroundColor: AppColor.appColor,
                          ),
                        ],
                      ),
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }
}
