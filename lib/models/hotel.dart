class HotelRoom {
  const HotelRoom({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.images = const [],
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String price;
  final String description;
  final List<String> images;
  final bool isAvailable;

  HotelRoom copyWith({bool? isAvailable}) {
    return HotelRoom(
      id: id,
      name: name,
      price: price,
      description: description,
      images: images,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class HotelItem {
  const HotelItem({
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.coverImage,
    required this.galleryImages,
    required this.restaurantInfo,
    required this.rooms,
    this.ownerPhone = '+222 45 00 00 00',
  });

  final String id;
  final String name;
  final String city;
  final String area;
  final String coverImage;
  final List<String> galleryImages;
  final String restaurantInfo;
  final List<HotelRoom> rooms;
  final String ownerPhone;

  String get locationLabel => '$area, $city';
}
