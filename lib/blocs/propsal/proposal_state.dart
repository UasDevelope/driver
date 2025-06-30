import 'package:equatable/equatable.dart';

class ProposalState extends Equatable{
  @override
  List<Object?> get props => [];

}
class UpdateDateTimeState extends ProposalState {
  final DateTime dateTime;
 UpdateDateTimeState({required this.dateTime});
  UpdateDateTimeState copyWith({DateTime? dateTime}) {
    return UpdateDateTimeState(dateTime: dateTime!);
  }
  List<Object> get props => [dateTime];
}