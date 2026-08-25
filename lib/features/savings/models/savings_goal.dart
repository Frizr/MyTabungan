/// Whether a [SavingsGoal] is a target-based Tabungan (has a target amount
/// and optional target date) or a target-free Dompet (just holds a balance).
enum GoalType {
  tabungan,
  dompet;

  String get label => this == GoalType.tabungan ? 'Tabungan' : 'Dompet';

  String get toStorage => name;

  static GoalType fromStorage(String? value) {
    return value == 'dompet' ? GoalType.dompet : GoalType.tabungan;
  }
}

class SavingsGoal {
  final String id;
  final String title;
  final GoalType type;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdAt;
  final DateTime? targetDate;

  SavingsGoal({
    required this.id,
    required this.title,
    this.type = GoalType.tabungan,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.createdAt,
    this.targetDate,
  });

  bool get isWallet => type == GoalType.dompet;

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount) : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type.toStorage,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdAt': createdAt.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map, String documentId) {
    return SavingsGoal(
      id: documentId,
      title: map['title'] ?? '',
      // Data lama tidak punya field 'type' — dianggap Tabungan (perilaku lama).
      type: GoalType.fromStorage(map['type'] as String?),
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      currentAmount: (map['currentAmount'] ?? 0).toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      targetDate: map['targetDate'] != null
          ? DateTime.parse(map['targetDate'])
          : null,
    );
  }
}
