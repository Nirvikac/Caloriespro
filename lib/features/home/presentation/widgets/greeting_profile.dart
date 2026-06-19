import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GreetingProfile extends StatelessWidget {
  const GreetingProfile({super.key, this.name = 'User', this.showDate = true});

  final String name;
  final bool showDate;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 4),
        if (showDate)
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        const SizedBox(height: 2),
        Text(
          '$_greeting, $name! ',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
