import 'payment_record.dart';
import 'room_detail.dart';

enum PropertyCategory { home, hotel, apartment }

extension PropertyCategoryLabel on PropertyCategory {
  String get label {
    switch (this) {
      case PropertyCategory.home:
        return 'Maison';
      case PropertyCategory.hotel:
        return 'Hôtel';
      case PropertyCategory.apartment:
        return 'Appartement';
    }
  }
}

class PropertyItem {
  const PropertyItem({
    required this.id,
    required this.title,
    required this.location,
    required this.area,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.totalRooms,
    required this.toilets,
    required this.hasKitchen,
    required this.hasGarage,
    this.roomDetails = const [],
    this.images = const [],
    this.rentOptions = const [],
    this.hasWifi = false,
    this.isFurnished = false,
    this.ownerPhone = '+222 45 00 00 00',
    this.isAvailable = true,
    this.isOwnerProperty = false,
    this.currentTenantName,
    this.monthlyPayments = const [],
    this.rating = 0,
    this.beds = 0,
    this.baths = 0,
  });

  final String id;
  final String title;
  final String location;
  final String area;
  final String price;
  final String image;
  final PropertyCategory category;
  final String description;
  final int totalRooms;
  final int toilets;
  final bool hasKitchen;
  final bool hasGarage;
  final List<RoomDetail> roomDetails;
  final List<String> images;
  final List<String> rentOptions;
  final bool hasWifi;
  final bool isFurnished;
  final String ownerPhone;
  final bool isAvailable;
  final bool isOwnerProperty;
  final String? currentTenantName;
  final List<PaymentRecord> monthlyPayments;
  final double rating;
  final int beds;
  final int baths;

  String get locationFull => area.isNotEmpty ? '$area, $location' : location;

  PropertyItem copyWith({
    bool? isAvailable,
    String? currentTenantName,
    bool clearTenant = false,
    List<PaymentRecord>? monthlyPayments,
    String? newImage,
    List<String>? newImages,
  }) {
    return PropertyItem(
      id: id,
      title: title,
      location: location,
      area: area,
      price: price,
      image: newImage ?? this.image,
      category: category,
      description: description,
      totalRooms: totalRooms,
      toilets: toilets,
      hasKitchen: hasKitchen,
      hasGarage: hasGarage,
      roomDetails: roomDetails,
      images: newImages ?? this.images,
      rentOptions: rentOptions,
      hasWifi: hasWifi,
      isFurnished: isFurnished,
      ownerPhone: ownerPhone,
      isAvailable: isAvailable ?? this.isAvailable,
      isOwnerProperty: isOwnerProperty,
      currentTenantName:
          clearTenant ? null : (currentTenantName ?? this.currentTenantName),
      monthlyPayments: monthlyPayments ?? this.monthlyPayments,
      rating: rating,
      beds: beds,
      baths: baths,
    );
  }
}
