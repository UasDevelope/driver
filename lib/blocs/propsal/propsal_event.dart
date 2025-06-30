import 'package:equatable/equatable.dart';

abstract class ProposalEvent extends Equatable{
  const ProposalEvent();
  @override
  List<Object> get props => [];
}
class UpdateDateTime extends ProposalEvent {
  final DateTime dateTime;
  const UpdateDateTime({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
class SubmitProposal extends ProposalEvent{}
class ClearController extends ProposalEvent{}