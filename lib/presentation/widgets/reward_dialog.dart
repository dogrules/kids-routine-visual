import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(strings.text('rewardTitle')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.text('dailyReward')),
          const SizedBox(height: 16),
          ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.1).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: const Icon(Icons.stars, size: 96, color: Colors.amber),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onDone,
          child: Text(strings.text('rewardDone')),
        ),
      ],
    );
  }
}
