import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/inbox/bloc.dart';
import '../../blocs/inbox/event.dart';
import '../../blocs/inbox/state.dart';
import '../../utils/const/app_color.dart';
import '../../utils/const/app_img.dart';
import '../../widgets/app_text.dart';
import '../../widgets/form_field.dart';

class ChatInbox extends StatefulWidget {
  final String bookingId;
  const ChatInbox({super.key, required this.bookingId});

  @override
  State<ChatInbox> createState() => _ChatInboxState();
}

class _ChatInboxState extends State<ChatInbox> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load chat and join room on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatInboxBloc>().add(ChatLoadedEvent(bookingId: widget.bookingId));
      context.read<ChatInboxBloc>().add(JoinChatRoomEvent(bookingId: widget.bookingId));
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                AppImages.person1,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppText(
                  text: "Orlando Diggs",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                AppText(text: "Online", fontSize: 12, color: Colors.green),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatInboxBloc, ChatInboxState>(
        listener: (context, state) {
          if (state is ChatInboxLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          if (state is ChatInboxLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatInboxLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: state.chatInbox.length,
                    itemBuilder: (context, index) {
                      final message = state.chatInbox[index];
                      return Align(
                        alignment: message.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: message.isMe
                                ? AppColor.appColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(
                                message.isMe ? 16 : 0,
                              ),
                              bottomRight: Radius.circular(
                                message.isMe ? 0 : 16,
                              ),
                            ),
                          ),
                          child: AppText(
                            text: message.message,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: _controller,
                          hintText: "Write you'r message",
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (_controller.text.trim().isNotEmpty) {
                            context.read<ChatInboxBloc>().add(
                                  SendChatMessageEvent(
                                    senderId: "", // Not used
                                    message: _controller.text.trim(),
                                    bookingId: widget.bookingId,
                                  ),
                                );
                            _controller.clear();
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            AppImages.send,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
