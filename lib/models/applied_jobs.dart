import 'package:flutter/material.dart';

class AppliedJob {
  final String title;
  final String company;
  final String location;
  final String description;
  final String salary;
  final String imageUrl;
  final DateTime appliedAt;

  AppliedJob({
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    required this.imageUrl,
    DateTime? appliedAt,
  }) : appliedAt = appliedAt ?? DateTime.now();
}

/// Global observable list of applied jobs.
final ValueNotifier<List<AppliedJob>> appliedJobsNotifier =
    ValueNotifier<List<AppliedJob>>([]);

/// Adds a job to the applied list (prevents duplicates by title + company).
void applyForJob(AppliedJob job) {
  final list = List<AppliedJob>.from(appliedJobsNotifier.value);
  final alreadyApplied = list.any(
    (existing) =>
        existing.title == job.title && existing.company == job.company,
  );
  if (!alreadyApplied) {
    list.insert(0, job);
    appliedJobsNotifier.value = list;
  }
}
