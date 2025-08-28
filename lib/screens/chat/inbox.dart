import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/chat/bloc.dart';
import '../../blocs/chat/event.dart';
import '../../blocs/chat/state.dart';
import '../../utils/const/app_color.dart';

import '../../widgets/app_text.dart';
import '../../widgets/form_field.dart';

class ChatInbox extends StatefulWidget {
  const ChatInbox({super.key});

  @override
  State<ChatInbox> createState() => _ChatInboxState();
}

class _ChatInboxState extends State<ChatInbox> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Prevent multiple rapid sends
  bool _isSending = false;
  DateTime? _lastSendTime;

  @override
  void initState() {
    super.initState();
    log("ChatInbox initState called");

    // Load chat and join room on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("ChatInbox post frame callback");

      // Try multiple ways to get arguments
      final route = ModalRoute.of(context);
      log("Route: $route");
      log("Route settings: ${route?.settings}");
      log("Route arguments: ${route?.settings.arguments}");

      final Map<String, dynamic>? arguments =
          route?.settings.arguments as Map<String, dynamic>?;
      final String? bookingId = arguments?['bookingId'];
      final String? customerName = arguments?['customerName'];

      log("Arguments received: $arguments");
      log("Booking ID: $bookingId");
      log("Customer Name: $customerName");

      if (bookingId != null) {
        log("Loading chat messages for booking: $bookingId");
        context
            .read<ChatBloc>()
            .add(LoadChatMessagesEvent(bookingId: bookingId));
        context.read<ChatBloc>().add(ConnectToChatEvent(bookingId: bookingId));
      } else {
        log("ERROR: Booking ID is null!");
      }
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      // Today - show time only
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days - show date and time
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    log("ChatInbox build method called");

    // Get arguments passed from booking card
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? bookingId = arguments?['bookingId'];
    final String? customerName = arguments?['customerName'] ?? "Customer";

    log("Build - Booking ID: $bookingId, Customer Name: $customerName");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                log("Manual back button pressed");
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText(
                    text: "Booking ${bookingId?.substring(0, 5) ?? ''}",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  AppText(
                    text: "Booking ID: ${bookingId?.substring(0, 5) ?? ''}",
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(listener: (context, state) {
        log("ChatInbox BlocListener state: ${state.runtimeType}");

        if (state is ChatMessagesLoadedState) {
          log("Messages loaded, scrolling to bottom");
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToBottom());
        } else if (state is MessageSentState) {
          log("Message sent successfully");
          // Show success feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Message sent: ${state.message.message}"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ChatErrorState) {
          log("Chat error state: ${state.message}");
          // Show error feedback but don't close screen
          String errorMessage = state.message;
          if (errorMessage.contains("Unauthorized") ||
              errorMessage.contains("unauthorized")) {
            errorMessage =
                "You don't have permission to chat for this booking. Please contact support.";
          } else if (errorMessage.contains("Booking not found")) {
            errorMessage = "This booking is no longer available for chat.";
          } else if (errorMessage.contains("Network")) {
            errorMessage =
                "Network error. Please check your connection and try again.";
          } else if (errorMessage.contains("Failed to send message")) {
            errorMessage = "Message could not be sent. Please try again.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  // Try to reconnect
                  if (bookingId != null) {
                    context
                        .read<ChatBloc>()
                        .add(ConnectToChatEvent(bookingId: bookingId));
                  }
                },
              ),
            ),
          );
        } else if (state is ChatConnectedState) {
          log("Chat connected state received - keeping screen open");
        } else if (state is ChatDisconnectedState) {
          log("Chat disconnected state received - keeping screen open");
        } else if (state is ChatLoadingState) {
          log("Chat loading state - keeping screen open");
        }
      }, builder: (context, state) {
        log("ChatInbox builder called with state: ${state.runtimeType}");

        if (state is ChatLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatMessagesLoadedState) {
          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No messages yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Start the conversation by sending a message",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: state.messages.length,
                                                itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar (only for other users' messages)
                                if (!message.isMe) ...[
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColor.appColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                // Message content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: message.isMe 
                                        ? CrossAxisAlignment.end 
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: message.isMe 
                                              ? AppColor.appColor 
                                              : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.message,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: message.isMe 
                                                    ? Colors.white 
                                                    : Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              _formatTime(message.timestamp),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: message.isMe 
                                                    ? Colors.white70 
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (message.isMe) ...[
                                        SizedBox(height: 2),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (message.status == 'sending')
                                              SizedBox(
                                                width: 10,
                                                height: 10,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                                ),
                                              )
                                            else if (message.status == 'sent')
                                              Icon(Icons.check, size: 10, color: Colors.white70)
                                            else if (message.status == 'delivered')
                                              Icon(Icons.done_all, size: 10, color: Colors.white70)
                                            else if (message.status == 'failed')
                                              Icon(Icons.error_outline, size: 10, color: Colors.red[300]),
                                            SizedBox(width: 4),
                                            Text(
                                              message.status == 'sending' ? 'Sending...' :
                                              message.status == 'sent' ? 'Sent' :
                                              message.status == 'delivered' ? 'Delivered' :
                                              message.status == 'failed' ? 'Failed' : '',
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Avatar for own messages (on the right)
                                if (message.isMe) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColor.appColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ],
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, chatState) {
                        final isLoading = chatState is MessageSendingState;

                        return GestureDetector(
                          onTap: (isLoading || _isSending)
                              ? null
                              : () {
                                  log("Send button tapped!");
                                  log("Message text: ${_controller.text.trim()}");
                                  log("Booking ID: $bookingId");

                                  // Prevent rapid sends
                                  final now = DateTime.now();
                                  if (_lastSendTime != null && 
                                      now.difference(_lastSendTime!).inMilliseconds < 1000) {
                                    log("⚠️ Rapid send prevented");
                                    return;
                                  }

                                  if (_controller.text.trim().isNotEmpty) {
                                    if (bookingId != null) {
                                      log("Sending message via ChatBloc...");
                                      
                                      // Set sending state
                                      setState(() {
                                        _isSending = true;
                                        _lastSendTime = now;
                                      });
                                      
                                      context.read<ChatBloc>().add(
                                            SendMessageEvent(
                                              bookingId: bookingId,
                                              message: _controller.text.trim(),
                                            ),
                                          );
                                      _controller.clear();
                                      
                                      // Reset sending state after a delay
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        if (mounted) {
                                          setState(() {
                                            _isSending = false;
                                          });
                                        }
                                      });
                                    } else {
                                      log("Booking ID is null, cannot send message");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Cannot send message: Booking ID not found"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    log("Message is empty");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please enter a message"),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: (isLoading || _isSending) ? Colors.grey : AppColor.appColor,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: (isLoading || _isSending)
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        } else if (state is ChatConnectedState) {
          // Show chat interface even when connecting
          // This prevents the loading screen from appearing
          return Column(
            children: [
              // Booking info header
              if (bookingId != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.appColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.assignment, color: AppColor.appColor, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Active Booking",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.appColor,
                            ),
                            AppText(
                              text: "ID: $bookingId",
                              fontSize: 10,
                              color: AppColor.grey,
                            ),
                          ],
                        ),
                      ),
                      // Connection status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: state.isSocketConnected ? Colors.green : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            text: state.isSocketConnected ? "Connecting..." : "API Only",
                            fontSize: 10,
                            color: state.isSocketConnected ? Colors.green : Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              // Messages area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        "Connecting to chat...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Please wait while we establish the connection",
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Message input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: _controller,
                        hintText: "Write your message",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        } else if (state is ChatErrorState) {
          // Show error but keep screen open with a more user-friendly interface
          return Column(
            children: [
              // Keep the booking info header
              if (bookingId != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColor.appColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        color: AppColor.appColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Active Booking",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColor.appColor,
                            ),
                            AppText(
                              text: "ID: $bookingId",
                              fontSize: 10,
                              color: AppColor.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Error message in the center
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.orange),
                      SizedBox(height: 16),
                      Text(
                        "Chat Temporarily Unavailable",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Try to reconnect
                          context.read<ChatBloc>().add(
                              ConnectToChatEvent(bookingId: bookingId ?? ""));
                        },
                        child: Text("Retry Connection"),
                      ),
                    ],
                  ),
                ),
              ),
              // Keep the message input area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: _controller,
                        hintText: "Write your message",
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (_controller.text.trim().isNotEmpty &&
                            bookingId != null) {
                          context.read<ChatBloc>().add(
                                SendMessageEvent(
                                  bookingId: bookingId,
                                  message: _controller.text.trim(),
                                ),
                              );
                          _controller.clear();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        } else {
          // Default case - show loading
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void dispose() {
    log("ChatInbox dispose called - screen is being closed");
    _controller.dispose();
    _scrollController.dispose();
    // Disconnect from chat when screen is closed
    context.read<ChatBloc>().add(const DisconnectFromChatEvent());
    super.dispose();
  }
}
