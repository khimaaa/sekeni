class PaymentRecord {
  const PaymentRecord({
    required this.monthLabel,
    required this.tenantName,
    required this.amountMru,
    required this.isPaid,
    required this.paidAt,
  });

  final String monthLabel;
  final String tenantName;
  final String amountMru;
  final bool isPaid;
  final String paidAt;
}
