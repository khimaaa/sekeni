import '../data/mock_data.dart';
import '../models/hotel.dart';
import '../models/property.dart';
import '../services/locale_service.dart';

extension PropertyL10n on PropertyItem {
  String localizedTitle(LocaleService l) {
    if (!l.isArabic) return title;
    return MockData.propertyTitleAr[id] ?? title;
  }
}

extension HotelL10n on HotelItem {
  String localizedName(LocaleService l) {
    if (!l.isArabic) return name;
    return MockData.hotelNameAr[id] ?? name;
  }
}
