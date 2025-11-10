import 'package:flutter/material.dart';

enum LeaveType { casual, sick, earned }
enum LeaveStatus { pending, approved, declined }

extension LeaveTypeX on LeaveType {
  String get label => switch (this) {
    LeaveType.casual => 'Casual',
    LeaveType.sick => 'Sick',
    LeaveType.earned => 'Earned',
  };
  IconData get icon => switch (this) {
    LeaveType.casual => Icons.beach_access_outlined,
    LeaveType.sick => Icons.healing_outlined,
    LeaveType.earned => Icons.card_travel_outlined,
  };
  Color color(ColorScheme cs) => switch (this) {
    LeaveType.casual => cs.primary,
    LeaveType.sick => cs.tertiary,
    LeaveType.earned => cs.secondary,
  };
}

extension LeaveStatusX on LeaveStatus {
  String get label => switch (this) {
    LeaveStatus.pending => 'Awaiting',
    LeaveStatus.approved => 'Approved',
    LeaveStatus.declined => 'Declined',
  };
  Color chipColor(ColorScheme cs) => switch (this) {
    LeaveStatus.pending => cs.secondaryContainer,
    LeaveStatus.approved => Colors.green.withOpacity(.18),
    LeaveStatus.declined => Colors.red.withOpacity(.18),
  };
  Color textColor(ColorScheme cs) => switch (this) {
    LeaveStatus.pending => cs.onSecondaryContainer,
    LeaveStatus.approved => Colors.green.shade800,
    LeaveStatus.declined => Colors.red.shade700,
  };
}

class LeaveRequest {
  final String id;
  final LeaveType type;
  final String cause;
  final DateTime from;
  final TimeOfDay fromTime;
  final DateTime to;
  final TimeOfDay toTime;
  final int totalDays; // calendar days (inclusive)
  final LeaveStatus status;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.cause,
    required this.from,
    required this.fromTime,
    required this.to,
    required this.toTime,
    required this.totalDays,
    this.status = LeaveStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
