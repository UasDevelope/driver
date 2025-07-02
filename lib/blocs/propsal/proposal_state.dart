import 'package:equatable/equatable.dart';

class ProposalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateDateTimeState extends ProposalState {
  final DateTime dateTime;

  UpdateDateTimeState({required this.dateTime});

  UpdateDateTimeState copyWith({DateTime? dateTime}) {
    return UpdateDateTimeState(dateTime: dateTime!);
  }
  @override
  List<Object> get props => [dateTime];
}

class LoadingProposalSend extends ProposalState{
  LoadingProposalSend();
  @override
  List<Object> get props => [];
}

class LoadedProposalSend extends ProposalState{
  Map<String, dynamic> response;
  LoadedProposalSend(this.response);
  @override
  List<Object> get props => [response];
}

class ProposalError extends ProposalState {
  final String message;
  ProposalError(this.message);
}
