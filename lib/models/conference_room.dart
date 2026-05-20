class ConferenceRoom {
  const ConferenceRoom({
    required this.id,
    required this.name,
    required this.capacity,
    required this.pricePerDay,
    required this.isAvailable,
    this.description = '',
  });

  final String id;
  final String name;
  final int capacity;
  final String pricePerDay;
  final bool isAvailable;
  final String description;

  ConferenceRoom copyWith({bool? isAvailable}) {
    return ConferenceRoom(
      id: id,
      name: name,
      capacity: capacity,
      pricePerDay: pricePerDay,
      isAvailable: isAvailable ?? this.isAvailable,
      description: description,
    );
  }
}
