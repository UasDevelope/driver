import 'package:equatable/equatable.dart';

import '../../models/booking_proposal_model.dart';

abstract class ProposalEvent extends Equatable{
  const ProposalEvent();
  @override
  List<Object?> get props => [];
}
class UpdateDateTime extends ProposalEvent {
  final DateTime dateTime;
  const UpdateDateTime({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
class SubmitProposalEvent extends ProposalEvent{
  BookingProposalModel proposalModel;
  SubmitProposalEvent({required this.proposalModel});
  @override
  List<Object?> get props => [proposalModel];
}
class ClearController extends ProposalEvent{}