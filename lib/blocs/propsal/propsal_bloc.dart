import 'dart:developer';
import 'package:driver/blocs/propsal/proposal_state.dart';
import 'package:driver/blocs/propsal/propsal_event.dart';
import 'package:driver/repositories/booking_proposal_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../api/api_exception.dart';

class ProposalBloc extends Bloc<ProposalEvent, ProposalState> {
  BookingProposalRepository proposalRepo = BookingProposalRepository();
  final TextEditingController Nohrs = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController writeSomething = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();
  DateTime? selectedDate;

  ProposalBloc() : super(ProposalState()) {
    on<UpdateDateTime>(updateTime);
    on<ClearController>(clearController);
    on<SubmitProposalEvent>(submitProposal);
  }

  void submitProposal(SubmitProposalEvent event, Emitter<ProposalState> emit) async {
    emit(LoadingProposalSend());
    try {
      final response = await proposalRepo.submitBookingProposal(event.proposalModel);
      log("Proposal submission response: $response");
      emit(LoadedProposalSend(response));
      emit(ProposalError(response["message"]));
    } catch (e) {
      if (e is ApiException) {
        log("Error in submitProposal: ${e.message}");
        emit(ProposalError(e.message));
      } else {
        log("Error in submitProposal: $e");
        emit(ProposalError(e.toString()));
      }

    }
  }


  void updateTime(UpdateDateTime event, Emitter<ProposalState> emit) {
    selectedDate = event.dateTime;
    final formatted = DateFormat("yyyy-MM-dd HH:mm").format(event.dateTime);
    date.text = formatted;
    emit(UpdateDateTimeState(dateTime: event.dateTime));
    log("Selected date: $formatted");
  }

  void clearController(ClearController event, Emitter<ProposalState> emit) {
    Nohrs.clear();
    price.clear();
    writeSomething.clear();
    date.clear();
  }
}
