class SavingsTransaction {
  final String id;
  final String savingsGoalId;
  final double amount; // Positive for deposit, negative for withdrawal
  final String note;
  final DateTime date;

  SavingsTransaction({
    required this.id,
    required this.savingsGoalId,
    required this.amount,
    this.note = '',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'savingsGoalId': savingsGoalId,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory SavingsTransaction.fromMap(Map<String, dynamic> map, String documentId) {
    return SavingsTransaction(
      id: documentId,
      savingsGoalId: map['savingsGoalId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      note: map['note'] ?? '',
      date: map['date'] != null 
          ? DateTime.parse(map['date']) 
          : DateTime.now(),
    );
  }
}
