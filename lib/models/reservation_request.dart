enum ReservationStatus { pending, accepted, rejected }

class ReservationRequest {
  const ReservationRequest({
    required this.id,
    required this.propertyTitle,
    required this.location,
    required this.price,
    required this.tenantName,
    required this.tenantPhone,
    required this.catalogPropertyId,
    required this.requestedAt,
    this.status = ReservationStatus.pending,
    this.ownerPropertyId,
  });

  final String id;
  final String propertyTitle;
  final String location;
  final String price;
  final String tenantName;
  final String tenantPhone;
  final String catalogPropertyId;
  final String requestedAt;
  final ReservationStatus status;
  final String? ownerPropertyId;

  ReservationRequest copyWith({
    ReservationStatus? status,
    String? ownerPropertyId,
  }) {
    return ReservationRequest(
      id: id,
      propertyTitle: propertyTitle,
      location: location,
      price: price,
      tenantName: tenantName,
      tenantPhone: tenantPhone,
      catalogPropertyId: catalogPropertyId,
      requestedAt: requestedAt,
      status: status ?? this.status,
      ownerPropertyId: ownerPropertyId ?? this.ownerPropertyId,
    );
  }
}
