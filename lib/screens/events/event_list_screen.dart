import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/event_card.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final List<String> _types = ['All', 'Hackathon', 'Contest', 'Workshop', 'Webinar'];

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hackathons & Events 🏆'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final type = _types[idx];
                final isSelected = eventProvider.selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => eventProvider.filterByType(type),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: eventProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : eventProvider.eventsList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_events_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No upcoming events found', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => eventProvider.fetchEvents(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: eventProvider.eventsList.length,
                          itemBuilder: (context, idx) {
                            final event = eventProvider.eventsList[idx];
                            return EventCard(
                              event: event,
                              isBookmarked: bookmarkProvider.isBookmarked(event.id),
                              onBookmarkToggle: () => bookmarkProvider.toggleBookmark(event.id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
