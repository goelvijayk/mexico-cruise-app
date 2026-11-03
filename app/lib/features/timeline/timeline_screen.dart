import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mexico_cruise/data/db/app_database.dart';
import 'package:mexico_cruise/data/db/tables.dart';
import 'package:mexico_cruise/domain/timeline/multi_day.dart';
import 'package:mexico_cruise/providers/app_providers.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripProvider);
    return tripAsync.when(
      data: (trip) {
        if (trip == null) {
          return const Center(child: Text('No trip loaded'));
        }
        final tabs = dayTabs(
          tripStart: trip.startDate,
          tripEnd: trip.endDate,
        );
        final selected = ref.watch(selectedDayProvider);
        final effectiveDay = selected ??
            defaultTimelineDay(
              tripStart: trip.startDate,
              tripEnd: trip.endDate,
              now: DateTime.now(),
            );

        final eventsAsync = ref.watch(eventsForDayProvider(selected));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (final day in tabs)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(DateFormat.MMMd().format(day)),
                        selected: selected != null &&
                            day.year == selected.year &&
                            day.month == selected.month &&
                            day.day == selected.day,
                        onSelected: (_) => ref
                            .read(selectedDayProvider.notifier)
                            .state = day,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: selected == null,
                      onSelected: (_) => ref
                          .read(selectedDayProvider.notifier)
                          .state = null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const Center(child: Text('No events this day'));
                  }
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final dayForCard = selected ?? effectiveDay;
                      final seg = segmentForDay(
                        startLocal: event.startLocal,
                        endLocal: event.endLocal,
                        day: dayForCard,
                      );
                      return EventCard(
                        event: event,
                        segment: seg,
                        day: dayForCard,
                        onTap: () => Navigator.of(context).pushNamed(
                          '/event',
                          arguments: event.id,
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.segment,
    required this.day,
    required this.onTap,
  });

  final Event event;
  final MultiDaySegment segment;
  final DateTime day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final location = decodeMap(event.locationJson)['name']?.toString();
    final timeLabel = _timeLabel(event, segment, day);
    final badges = <Widget>[];
    if (event.status == 'tentative') {
      badges.add(_badge('Tentative', Colors.orange));
    }
    if (event.status == 'cancelled') {
      badges.add(_badge('Cancelled', Colors.grey));
    }
    if (event.reviewState == 'revised') {
      badges.add(_badge('Revised — check it', Colors.blue));
    }
    if (event.reviewState == 'flagged') {
      badges.add(_badge('Flagged', Colors.red));
    }
    if (event.reviewState == 'needs_human') {
      badges.add(_badge('Needs manual fix', Colors.deepOrange));
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(timeLabel,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(
                segment == MultiDaySegment.middle
                    ? stripLabelForEvent(
                        title: event.title,
                        startLocal: event.startLocal,
                        endLocal: event.endLocal,
                        day: day,
                      )
                    : event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: event.status == 'cancelled'
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              if (location != null) Text(location),
              if (event.bookingRef != null)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: event.bookingRef!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking ref copied')),
                    );
                  },
                  child: Text('Ref: ${event.bookingRef}',
                      style: const TextStyle(color: Colors.indigo)),
                ),
              if (event.updatedBy != 'ingestion' &&
                  event.updatedBy != 'sample')
                Text(
                  'Edited by ${event.updatedBy} · ${DateFormat.jm().format(event.updatedAt.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              Wrap(spacing: 6, children: badges),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(Event event, MultiDaySegment segment, DateTime day) {
    if (event.allDay || segment == MultiDaySegment.middle) {
      return 'All day';
    }
    if (segment == MultiDaySegment.last && event.endLocal != null) {
      return DateFormat.jm().format(event.endLocal!);
    }
    return DateFormat.jm().format(event.startLocal);
  }

  Widget _badge(String label, Color color) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}
