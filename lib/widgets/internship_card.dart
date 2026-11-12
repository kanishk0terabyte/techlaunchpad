import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/internship_model.dart';

class InternshipCard extends StatelessWidget {
  final InternshipModel internship;
  final VoidCallback? onBookmarkToggle;
  final bool isBookmarked;

  const InternshipCard({
    super.key,
    required this.internship,
    this.onBookmarkToggle,
    this.isBookmarked = false,
  });

  Future<void> _openApplyLink() async {
    final uri = Uri.tryParse(internship.applyLink);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpired = DateTime.now().isAfter(internship.deadline);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A73E8), Color(0xFF00BFA5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      internship.company.isNotEmpty ? internship.company[0].toUpperCase() : 'C',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        internship.role,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        internship.company,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onBookmarkToggle != null)
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                      color: isBookmarked ? theme.colorScheme.primary : theme.hintColor,
                    ),
                    onPressed: onBookmarkToggle,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Tags row: Type, Location, Stipend, Duration
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildTag(
                  internship.type == 'Remote' ? Icons.home_work_outlined : Icons.location_on_outlined,
                  '${internship.type}${internship.location.isNotEmpty ? " • ${internship.location}" : ""}',
                  Colors.blue,
                ),
                if (internship.stipend.isNotEmpty)
                  _buildTag(Icons.payments_outlined, internship.stipend, Colors.green),
                if (internship.duration.isNotEmpty)
                  _buildTag(Icons.calendar_today_outlined, internship.duration, Colors.orange),
              ],
            ),
            if (internship.skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: internship.skills
                    .take(4)
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(skill, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.alarm_rounded,
                  size: 14,
                  color: isExpired ? Colors.red : theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  isExpired
                      ? 'Expired'
                      : 'Deadline: ${DateFormat('dd MMM yyyy').format(internship.deadline)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isExpired ? Colors.red : theme.hintColor,
                    fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: isExpired ? null : _openApplyLink,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
