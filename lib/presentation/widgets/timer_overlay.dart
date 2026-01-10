import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';

class TimerOverlay extends StatefulWidget {
  const TimerOverlay({
    super.key,
    required this.initialSeconds,
    required this.onComplete,
  });

  final int initialSeconds;
  final VoidCallback onComplete;

  @override
  State<TimerOverlay> createState() => _TimerOverlayState();
}

class _TimerOverlayState extends State<TimerOverlay> {
  Timer? _timer;
  int _remaining = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.initialSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _isRunning = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() {
          _remaining = 0;
          _isRunning = false;
        });
        HapticFeedback.heavyImpact();
        SystemSound.play(SystemSoundType.alert);
        widget.onComplete();
      } else {
        setState(() {
          _remaining -= 1;
        });
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.initialSeconds;
      _isRunning = false;
    });
  }

  String _format(int seconds) {
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(strings.text('timer')),
      content: Text(
        _format(_remaining),
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: _isRunning ? _pause : _start,
          child: Text(_isRunning ? strings.text('pause') : strings.text('start')),
        ),
        TextButton(
          onPressed: _reset,
          child: Text(strings.text('reset')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.text('done')),
        ),
      ],
    );
  }
}
