import 'package:flutter/material.dart';
import 'package:saigon_tour_guide/model/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final void Function(int placeId) onPlaceTap;

  const ChatBubble({
    super.key,
    required this.message,
    required this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(message.text),
          ),
        ),
        if (message.places.isNotEmpty)
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: message.places.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final place = message.places[idx];
                return InkWell(
                  onTap: () => onPlaceTap(place.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          place.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          place.ward,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (place.averageRating != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(place.averageRating!.toStringAsFixed(1), style: Theme.of(context).textTheme.bodySmall)
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
