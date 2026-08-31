import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/model/chat_message.dart';
import 'package:saigon_tour_guide/screen/chat_list_screen.dart';
import 'package:saigon_tour_guide/screen/place_detail_screen.dart';
import 'package:saigon_tour_guide/widget/chat_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  final int? sessionId;
  const ChatbotScreen({super.key, this.sessionId});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  int? _sessionId;
  bool _sending = false;
  bool _loadingHistory = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sessionId = widget.sessionId;
    if (_sessionId != null) {
      _loadHistory(_sessionId!);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: text));
      _sending = true;
      _inputController.clear();
    });

    _scrollToBottom();
    try {
      final res = await context.read<ApiClient>().dio.post(
        '/chat',
        data: {
          'message': text,
          if (_sessionId != null) 'session_id': _sessionId,
        },
      );
      if (!mounted) return;
      final data = res.data as Map<String, dynamic>;
      _sessionId = data['session_id'] as int;
      final places = (data['places'] as List)
          .map((p) => ChatPlaceCard.fromJson(p as Map<String, dynamic>))
          .toList();
      setState(() {
        _messages.add(
          ChatMessage(
            sender: ChatSender.bot,
            text: data['answer'] as String,
            places: places,
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(sender: ChatSender.bot, text: getErrorMessage(e)),
        );
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }

  void _openPlace(int placeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: placeId)),
    );
  }

  Future<void> _loadHistory(int sessionId) async {
    setState(() => _loadingHistory = true);
    try {
      final res = await context.read<ApiClient>().dio.get(
        '/chat/sessions/$sessionId',
      );
      final data = res.data as Map<String, dynamic>;

      final history = (data['messages'] as List).map((m) {
        final map = m as Map<String, dynamic>;
        return ChatMessage(
          sender: map['user_role'] == 'USER' ? ChatSender.user : ChatSender.bot,
          text: map['content'] as String,
        );
      }).toList();

      if (!mounted) return;
      setState(() => _messages.addAll(history));
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(sender: ChatSender.bot, text: getErrorMessage(e)),
        );
      });
    } finally {
      if (mounted) setState(() => _loadingHistory = false);
    }
  }

  Future<void> _openHistory() async {
    final selectedId = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => const ChatListScreen()),
    );
    if (selectedId != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatbotScreen(sessionId: selectedId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        actions: [
          IconButton(onPressed: _openHistory, icon: const Icon(Icons.history)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_loadingHistory) const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.smart_button_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('Hỏi tôi về các địa điểm ở Sài Gòn...'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, idx) => ChatBubble(
                        message: _messages[idx],
                        onPlaceTap: _openPlace,
                      ),
                    ),
            ),
            if (_sending) const LinearProgressIndicator(minHeight: 2),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: const InputDecoration(
                        hintText: 'Soạn tin nhắn...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
