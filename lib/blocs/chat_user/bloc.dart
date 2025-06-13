import 'dart:developer';

import 'package:driver/blocs/chat_user/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy/chat_user.dart';
import '../../models/user_model.dart';
import 'event.dart';


class ChatUserBloc extends Bloc<ChatUserEvent, ChatuserState> {
  ChatUserBloc() : super(ChatUserInitialStat()) {
    on<ChatUserLoadedEvent>((event, emit) {
      emit(chatUserLoadingState());
      try {
        final ChatUser dummyMaps = ChatUser();
        final chatData =
            dummyMaps.chatUser.map((e) => ChatUserModel.fromMap(e)).toList();
        log(chatData.toString());
        emit(ChatUserLoadedState(chatUserModel: chatData));
      } catch (e) {
        log("$e");
      }
    });
  }
}
