import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/chat_message.dart';
import '../models/conference_room.dart';
import '../models/hotel.dart';
import '../models/payment_record.dart';
import '../models/property.dart';
import '../models/reservation_request.dart';
import '../models/tenant_booking.dart';
import '../models/user_role.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String? firstName;
  String? lastName;
  String? userPhone;
  String? hotelName;
  String? hotelEmail;
  UserRole? role;

  final Set<String> favoriteIds = {};
  List<PropertyItem> catalogProperties =
      List.from(MockData.catalogProperties);
  List<HotelItem> hotels = List.from(MockData.hotels);
  final List<PropertyItem> ownerProperties =
      List.from(MockData.ownerProperties);
  final List<ReservationRequest> reservationRequests =
      List.from(MockData.initialReservationRequests);
  final List<TenantBooking> tenantBookings = [];
  List<ConferenceRoom> hotelConferenceRooms =
      List.from(MockData.defaultConferenceRooms);
  List<HotelRoom> managedHotelRooms = [];
  String? managedHotelId;

  List<ChatConversation> conversations = _initialChats();

  String get userName {
    if (role == UserRole.hotel) return hotelName ?? 'Hôtel';
    final f = firstName ?? '';
    final l = lastName ?? '';
    return '$f $l'.trim().isEmpty ? 'Utilisateur' : '$f $l'.trim();
  }

  void loginPerson({
    required String prenom,
    required String nom,
    required String phone,
    required UserRole userRole,
  }) {
    isLoggedIn = true;
    role = userRole;
    firstName = prenom;
    lastName = nom;
    userPhone = phone;
    hotelName = null;
    hotelEmail = null;
    notifyListeners();
  }

  void loginHotel({
    required String name,
    required String email,
    required String phone,
  }) {
    isLoggedIn = true;
    role = UserRole.hotel;
    hotelName = name;
    hotelEmail = email;
    userPhone = phone;
    firstName = null;
    lastName = null;
    managedHotelId = 'ht1';
    final hotel = hotels.firstWhere(
      (h) => h.id == managedHotelId,
      orElse: () => hotels.first,
    );
    managedHotelId = hotel.id;
    managedHotelRooms = List.from(hotel.rooms);
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    firstName = null;
    lastName = null;
    userPhone = null;
    hotelName = null;
    hotelEmail = null;
    role = null;
    managedHotelId = null;
    managedHotelRooms = [];
    favoriteIds.clear();
    notifyListeners();
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<PropertyItem> get favoriteProperties =>
      catalogProperties.where((p) => favoriteIds.contains(p.id)).toList();

  List<PropertyItem> propertiesByCategory(PropertyCategory category) =>
      catalogProperties.where((p) => p.category == category).toList();

  List<PropertyItem> get availableOwnerProperties =>
      ownerProperties.where((p) => p.isAvailable).toList();

  List<PropertyItem> get unavailableOwnerProperties =>
      ownerProperties.where((p) => !p.isAvailable).toList();

  void _setCatalogAvailability(String? catalogId, bool available) {
    if (catalogId == null || catalogId.startsWith('hotel_')) return;
    final i = catalogProperties.indexWhere((p) => p.id == catalogId);
    if (i != -1) {
      catalogProperties[i] =
          catalogProperties[i].copyWith(isAvailable: available);
    }
  }

  List<ReservationRequest> get pendingReservations => reservationRequests
      .where((r) => r.status == ReservationStatus.pending)
      .toList();

  int get pendingReservationCount => pendingReservations.length;

  List<ReservationRequest> get hotelPendingReservations => reservationRequests
      .where(
        (r) =>
            r.status == ReservationStatus.pending &&
            r.catalogPropertyId.startsWith('hotel_'),
      )
      .toList();

  List<TenantBooking> get myBookings => tenantBookings
      .where((b) => b.tenantPhone == userPhone && b.isActive)
      .toList();

  List<TenantBooking> get pendingPayments => myBookings
      .where((b) => b.paymentStatus == PaymentStatus.pending)
      .toList();

  List<HotelRoom> get availableHotelRooms =>
      managedHotelRooms.where((r) => r.isAvailable).toList();

  List<HotelRoom> get unavailableHotelRooms =>
      managedHotelRooms.where((r) => !r.isAvailable).toList();

  void submitReservation(PropertyItem property) {
    if (!property.isAvailable) return;
    reservationRequests.insert(
      0,
      ReservationRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        propertyTitle: property.title,
        location: property.locationFull,
        price: property.price,
        tenantName: userName,
        tenantPhone: userPhone ?? '',
        catalogPropertyId: property.id,
        requestedAt: _formatNow(),
      ),
    );
    notifyListeners();
  }

  void submitHotelReservation(HotelItem hotel, HotelRoom room) {
    if (!room.isAvailable) return;
    reservationRequests.insert(
      0,
      ReservationRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        propertyTitle: '${hotel.name} — ${room.name}',
        location: hotel.locationLabel,
        price: room.price,
        tenantName: userName,
        tenantPhone: userPhone ?? '',
        catalogPropertyId: 'hotel_${hotel.id}_${room.id}',
        requestedAt: _formatNow(),
      ),
    );
    notifyListeners();
  }

  bool acceptReservation(String requestId, String ownerPropertyId) {
    final index = reservationRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return false;
    final request = reservationRequests[index];
    final propertyIndex =
        ownerProperties.indexWhere((p) => p.id == ownerPropertyId);
    if (propertyIndex == -1) return false;
    final property = ownerProperties[propertyIndex];
    if (!property.isAvailable) return false;

    ownerProperties[propertyIndex] = property.copyWith(
      isAvailable: false,
      currentTenantName: request.tenantName,
      monthlyPayments: [
        PaymentRecord(
          monthLabel: 'Mai 2026',
          tenantName: request.tenantName,
          amountMru: property.price,
          isPaid: false,
          paidAt: 'En attente',
        ),
        ...property.monthlyPayments,
      ],
    );

    _setCatalogAvailability(request.catalogPropertyId, false);

    reservationRequests[index] = request.copyWith(
      status: ReservationStatus.accepted,
      ownerPropertyId: property.id,
    );

    tenantBookings.insert(
      0,
      TenantBooking(
        id: 'book_${request.id}',
        propertyTitle: request.propertyTitle,
        location: request.location,
        amountMru: request.price,
        acceptedAt: _formatNow(),
        tenantPhone: request.tenantPhone,
        catalogPropertyId: request.catalogPropertyId,
        ownerPropertyId: property.id,
      ),
    );
    notifyListeners();
    return true;
  }

  void acceptHotelReservation(String requestId) {
    final index = reservationRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;
    final request = reservationRequests[index];
    final raw = request.catalogPropertyId.replaceFirst('hotel_', '');
    final roomSep = raw.indexOf('_');
    if (roomSep > 0 && roomSep < raw.length - 1) {
      final roomId = raw.substring(roomSep + 1);
      _setHotelRoomAvailability(roomId, false);
    }
    reservationRequests[index] =
        request.copyWith(status: ReservationStatus.accepted);
    notifyListeners();
  }

  void rejectReservation(String requestId) {
    final index = reservationRequests.indexWhere((r) => r.id == requestId);
    if (index == -1) return;
    reservationRequests[index] = reservationRequests[index]
        .copyWith(status: ReservationStatus.rejected);
    notifyListeners();
  }

  void payBooking(String bookingId) {
    final i = tenantBookings.indexWhere((b) => b.id == bookingId);
    if (i == -1) return;
    tenantBookings[i] =
        tenantBookings[i].copyWith(paymentStatus: PaymentStatus.paid);
    notifyListeners();
  }

  void endRentalByOwner(String ownerPropertyId) {
    final i = ownerProperties.indexWhere((p) => p.id == ownerPropertyId);
    if (i == -1) return;
    final p = ownerProperties[i];
    ownerProperties[i] = p.copyWith(isAvailable: true, clearTenant: true);
    _setCatalogAvailability(_catalogIdForOwner(p.id), true);
    _deactivateBookingsForProperty(ownerPropertyId);
    notifyListeners();
  }

  void endRentalByTenant(String bookingId) {
    final bi = tenantBookings.indexWhere((b) => b.id == bookingId);
    if (bi == -1) return;
    final booking = tenantBookings[bi];
    tenantBookings[bi] = booking.copyWith(isActive: false);
    if (booking.ownerPropertyId != null) {
      endRentalByOwner(booking.ownerPropertyId!);
    } else {
      _setCatalogAvailability(booking.catalogPropertyId, true);
    }
    notifyListeners();
  }

  void _deactivateBookingsForProperty(String ownerPropertyId) {
    for (var i = 0; i < tenantBookings.length; i++) {
      if (tenantBookings[i].ownerPropertyId == ownerPropertyId) {
        tenantBookings[i] = tenantBookings[i].copyWith(isActive: false);
      }
    }
  }

  String? _catalogIdForOwner(String ownerId) {
    if (ownerId == 'o1') return 'h1';
    if (ownerId == 'o2') return 'a1';
    return null;
  }

  void addOwnerProperty({
    required String title,
    required String location,
    required String price,
    required PropertyCategory category,
    List<String> photoPaths = const [],
  }) {
    final mainImage =
        photoPaths.isNotEmpty ? photoPaths.first : MockData.placeholderImage;
    ownerProperties.add(
      PropertyItem(
        id: 'o_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        location: location.contains('Nouakchott') ? 'Nouakchott' : location,
        area: location,
        price: price.endsWith('MRU') ? price : '$price MRU',
        image: mainImage,
        images: photoPaths.isNotEmpty ? photoPaths : [MockData.placeholderImage],
        category: category,
        description: category == PropertyCategory.apartment
            ? 'Appartement meublé avec wifi.'
            : 'Bien non meublé — sans wifi.',
        totalRooms: 2,
        toilets: 1,
        hasKitchen: true,
        hasGarage: false,
        isAvailable: true,
        isOwnerProperty: true,
        ownerPhone: userPhone ?? '+222 45 00 00 00',
        isFurnished: category == PropertyCategory.apartment,
        hasWifi: category == PropertyCategory.apartment,
        rentOptions: category == PropertyCategory.apartment
            ? ['24h', '48h', '1 mois']
            : const [],
      ),
    );
    notifyListeners();
  }

  void _setHotelRoomAvailability(String roomId, bool available) {
    final i = managedHotelRooms.indexWhere((r) => r.id == roomId);
    if (i != -1) {
      managedHotelRooms[i] =
          managedHotelRooms[i].copyWith(isAvailable: available);
    }
    final hi = hotels.indexWhere((h) => h.id == managedHotelId);
    if (hi != -1) {
      final h = hotels[hi];
      hotels[hi] = HotelItem(
        id: h.id,
        name: h.name,
        city: h.city,
        area: h.area,
        coverImage: h.coverImage,
        galleryImages: h.galleryImages,
        restaurantInfo: h.restaurantInfo,
        ownerPhone: h.ownerPhone,
        rooms: managedHotelRooms,
      );
    }
  }

  void toggleHotelRoomAvailability(String roomId) {
    final i = managedHotelRooms.indexWhere((r) => r.id == roomId);
    if (i == -1) return;
    _setHotelRoomAvailability(
      roomId,
      !managedHotelRooms[i].isAvailable,
    );
    notifyListeners();
  }

  void toggleConferenceAvailability(String roomId) {
    final i = hotelConferenceRooms.indexWhere((r) => r.id == roomId);
    if (i == -1) return;
    hotelConferenceRooms[i] = hotelConferenceRooms[i].copyWith(
      isAvailable: !hotelConferenceRooms[i].isAvailable,
    );
    notifyListeners();
  }

  void sendChatMessage(String conversationId, String text) {
    final i = conversations.indexWhere((c) => c.id == conversationId);
    if (i == -1) return;
    final c = conversations[i];
    final updated = [
      ...c.messages,
      ChatMessage(text: text, isMe: true, time: _timeNow()),
    ];
    conversations[i] = ChatConversation(
      id: c.id,
      contactName: c.contactName,
      contactRole: c.contactRole,
      lastMessage: text,
      timeLabel: 'Maintenant',
      messages: updated,
    );
    notifyListeners();
  }

  String? suggestOwnerPropertyId(ReservationRequest request) {
    final byTitle = ownerProperties.indexWhere(
      (p) =>
          p.isAvailable &&
          (p.title == request.propertyTitle ||
              request.propertyTitle.contains(p.title)),
    );
    if (byTitle != -1) return ownerProperties[byTitle].id;
    return ownerProperties.where((p) => p.isAvailable).firstOrNull?.id;
  }

  static List<ChatConversation> _initialChats() {
    return [
      ChatConversation(
        id: 'ch1',
        contactName: 'محمد الأمين',
        contactRole: 'Allongement',
        lastMessage: 'السلام عليكم، المنزل مازال متوفر؟',
        timeLabel: '14:32',
        unread: 2,
        messages: const [
          ChatMessage(
            text: 'السلام عليكم',
            isMe: false,
            time: '14:30',
          ),
          ChatMessage(
            text: 'السلام عليكم، المنزل مازال متوفر؟',
            isMe: false,
            time: '14:32',
          ),
        ],
      ),
      ChatConversation(
        id: 'ch2',
        contactName: 'Propriétaire — Villa TZ',
        contactRole: 'Propriétaire',
        lastMessage: 'Oui, visite possible demain 10h',
        timeLabel: 'Hier',
        unread: 0,
        messages: const [
          ChatMessage(
            text: 'Bonjour, je souhaite visiter la villa',
            isMe: true,
            time: '09:15',
          ),
          ChatMessage(
            text: 'Oui, visite possible demain 10h',
            isMe: false,
            time: '09:22',
          ),
        ],
      ),
      ChatConversation(
        id: 'ch3',
        contactName: 'Réception Monotel',
        contactRole: 'Hôtel',
        lastMessage: 'Votre chambre est confirmée',
        timeLabel: 'Lun',
        unread: 1,
        messages: const [
          ChatMessage(
            text: 'Bonjour, réservation pour 2 nuits',
            isMe: true,
            time: '11:00',
          ),
          ChatMessage(
            text: 'Votre chambre est confirmée',
            isMe: false,
            time: '11:05',
          ),
        ],
      ),
    ];
  }

  String _formatNow() {
    final n = DateTime.now();
    return '${n.day.toString().padLeft(2, '0')}/${n.month.toString().padLeft(2, '0')}/${n.year}';
  }

  String _timeNow() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
  }
}
