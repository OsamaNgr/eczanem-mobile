import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eczanem_mobile/core/constants/app_colors.dart';
import 'package:eczanem_mobile/src/Cubits/AI/ai_assistant_cubit.dart';
import 'package:eczanem_mobile/src/model/chat_message.dart';
import 'package:eczanem_mobile/src/view/helpers/show_snack_bar.dart';
import 'dart:io';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        if (mounted) {
          BlocProvider.of<AIAssistantCubit>(context)
              .sendImageMessage(File(image.path));
          _scrollToBottom();
        }
      }
    } catch (e) {
      showSnackBar(
          "failedToPickImage".tr, SnackBarMessageType.error);
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("selectImageSource".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primaryColor),
              title: Text("camera".tr),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: Text("gallery".tr),
              onTap: () {
                Navigator. pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim(). isEmpty) return;
    
    BlocProvider.of<AIAssistantCubit>(context)
        .sendTextMessage(_messageController.text.trim());
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Quick Action Buttons
          _QuickActionsBar(
            onImageTap: _showImageSourceDialog,
            onQRTap: () {
              // TODO: Implement QR Scanner
              showSnackBar("qrScannerComingSoon".tr, SnackBarMessageType.info);
            },
          ),
          
          // Chat Messages
          Expanded(
            child: BlocConsumer<AIAssistantCubit, AIAssistantState>(
              listener: (context, state) {
                if (state is AIAssistantError) {
                  showSnackBar(state.error, SnackBarMessageType.error);
                }
                if (state is AIAssistantMessageSent || state is AIAssistantResponseReceived) {
                  Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
                }
              },
              builder: (context, state) {
                final messages = BlocProvider.of<AIAssistantCubit>(context).messages;
                
                if (messages.isEmpty) {
                  return _EmptyStateView();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _ChatBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),

          // Loading Indicator
          BlocBuilder<AIAssistantCubit, AIAssistantState>(
            builder: (context, state) {
              if (state is AIAssistantLoading) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors. primaryColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "aiThinking".tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox. shrink();
            },
          ),

          // Input Bar
          _MessageInputBar(
            controller: _messageController,
            onSend: _sendMessage,
            onImageTap: _showImageSourceDialog,
          ),
        ],
      ),
    );
  }
}

class _QuickActionsBar extends StatelessWidget {
  final VoidCallback onImageTap;
  final VoidCallback onQRTap;

  const _QuickActionsBar({
    required this.onImageTap,
    required this.onQRTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: Icons.camera_alt,
              label: "scanMedicine".tr,
              onTap: onImageTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.qr_code_scanner,
              label: "scanPrescription". tr,
              onTap: onQRTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets. symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors. primaryColor. withOpacity(0.1),
          borderRadius: BorderRadius. circular(12),
          border: Border.all(
            color: AppColors.primaryColor. withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight. w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              "aiAssistantWelcome".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "aiAssistantDescription".tr,
              style: const TextStyle(
                fontSize: 14,
                color: Colors. grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _SuggestionChip(text: "whatIsPanadol".tr),
            const SizedBox(height: 8),
            _SuggestionChip(text: "howToUseMedicine".tr),
            const SizedBox(height: 8),
            _SuggestionChip(text: "checkSideEffects".tr),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;

  const _SuggestionChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<AIAssistantCubit>(context).sendTextMessage(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor. withOpacity(0.2),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (! isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors. primaryColor,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment. start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primaryColor
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.imagePath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(message.imagePath!),
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (message.text.isNotEmpty) const SizedBox(height: 8),
                      ],
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors. black87,
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors. grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors. primaryColor,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return "justNow".tr;
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}${"minutesAgo".tr}";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}${"hoursAgo". tr}";
    } else {
      return "${time.hour}:${time.minute. toString().padLeft(2, '0')}";
    }
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onImageTap;

  const _MessageInputBar({
    required this.controller,
    required this.onSend,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: onImageTap,
              icon: const Icon(
                Icons.image,
                color: AppColors.primaryColor,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "typeMessage".tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.send,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}