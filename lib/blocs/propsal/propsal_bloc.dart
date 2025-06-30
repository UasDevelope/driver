import 'dart:developer';
import 'package:driver/blocs/propsal/proposal_state.dart';
import 'package:driver/blocs/propsal/propsal_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProposalBloc extends Bloc<ProposalEvent, ProposalState> {
  final TextEditingController Nohrs = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController writeSomething = TextEditingController();
  final TextEditingController date = TextEditingController();
  DateTime? selectedDate;

  ProposalBloc() : super(ProposalState()) {
    on<UpdateDateTime>(updateTime);
    on<ClearController>(clearController);
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
