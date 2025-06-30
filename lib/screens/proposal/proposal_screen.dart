import 'dart:developer';
import 'package:driver/blocs/propsal/proposal_state.dart';
import 'package:driver/blocs/propsal/propsal_bloc.dart';
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
  const ProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocListener<ProposalBloc, ProposalState>(
        listener: (context, state) {},
        child: BlocBuilder<ProposalBloc, ProposalState>(
          builder: (context, state) {
            final proposalBloc = context.read<ProposalBloc>();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    AppText(
                      text: "Send Proposal",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    SizedBox(height: 6),
                    AppText(text: "Edit this according to your choice"),
                    SizedBox(height: 20),
                    AppTextFormField(
                      onTap: () {},
                      controller: proposalBloc.Nohrs,
                      hintText: "Enter No. of Hours",
                      isNumeric: true,
                      validator: AppValidators.validateRequired,
                      prefixIcon: AppImages.time,
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      controller: proposalBloc.date,
                      hintText: "Select date",
                      prefixIcon: AppImages.calendar,
                      readOnly: true,
                      onTap: () async {
                        final picked = await DateTimeHelper.pickDateTime(context);
                        if (picked != null) {
                          final formatted = DateFormat(
                            "dd MMM yyyy – hh:mm a",
                          ).format(picked);
                          proposalBloc.date.text = formatted;
                          log(formatted);
                          context.read<ProposalBloc>().add(
                            UpdateDateTime(dateTime: picked),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      controller: proposalBloc.price,
                      isNumeric: true,
                      hintText: "Enter price",
                      validator: AppValidators.validateRequired,
                      prefixIcon: AppImages.coin,
                    ),
                    const SizedBox(height: 12),
                    AppTextFormField(
                      controller: proposalBloc.writeSomething,
                      hintText: "Enter Requirements",
                    ),

                    SizedBox(height: 24),
                    AppButton(
                      text: "Send Proposal",
                      onPressed: () {},
                      backgroundColor: AppColor.appColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
