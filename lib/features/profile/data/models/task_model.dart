/// Tek bir görevin tanımı (uygulama içi sabit liste)
class TaskDefinition {
  final String id;
  final String title;
  final String? description;
  final String taskType; // one_time, daily, weekly, monthly
  final String rewardType; // avatar, banner, title
  final String rewardId; // avatar index (int as string), banner id, title id
  final TaskTarget target;

  const TaskDefinition({
    required this.id,
    required this.title,
    this.description,
    required this.taskType,
    required this.rewardType,
    required this.rewardId,
    required this.target,
  });
}

/// Görev hedefi: ne ölçülecek ve hedef değer
class TaskTarget {
  final String type; // total_distance_m, polygon_count, streak_days, today_count, week_count, month_count
  final num value;

  const TaskTarget({required this.type, required this.value});
}

/// Kullanıcının bir görevdeki ilerlemesi
class TaskProgress {
  final TaskDefinition definition;
  final num current;
  final num target;
  final bool completed;
  final bool rewardClaimed;

  const TaskProgress({
    required this.definition,
    required this.current,
    required this.target,
    required this.completed,
    required this.rewardClaimed,
  });

  double get progressFraction =>
      target > 0 ? (current.clamp(0, target) / target).toDouble() : 0.0;
}
