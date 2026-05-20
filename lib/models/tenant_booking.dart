enum PaymentStatus { pending, paid }

class TenantBooking {
  const TenantBooking({
    required this.id,
    required this.propertyTitle,
    required this.location,
    required this.amountMru,
    required this.acceptedAt,
    required this.tenantPhone,
    this.catalogPropertyId,
    this.ownerPropertyId,
    this.paymentStatus = PaymentStatus.pending,
    this.isActive = true,
  });

  final String id;
  final String propertyTitle;
  final String location;
  final String amountMru;
  final String acceptedAt;
  final String tenantPhone;
  final String? catalogPropertyId;
  final String? ownerPropertyId;
  final PaymentStatus paymentStatus;
  final bool isActive;

  TenantBooking copyWith({
    PaymentStatus? paymentStatus,
    bool? isActive,
  }) {
    return TenantBooking(
      id: id,
      propertyTitle: propertyTitle,
      location: location,
      amountMru: amountMru,
      acceptedAt: acceptedAt,
      tenantPhone: tenantPhone,
      catalogPropertyId: catalogPropertyId,
      ownerPropertyId: ownerPropertyId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isActive: isActive ?? this.isActive,
    );
  }
}
