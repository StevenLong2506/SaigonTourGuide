import 'package:saigon_tour_guide/model/place.dart';

class PlaceImage {
  final int id;
  final String imgUrl;
  final String? caption;
  final bool isPrimary;

  PlaceImage({
    required this.id,
    required this.imgUrl,
    required this.caption,
    required this.isPrimary,
  });

  factory PlaceImage.fromJson(Map<String, dynamic> json) => PlaceImage(
    id: json['id'] as int,
    imgUrl: json['img_url'] as String,
    caption: json['caption'] as String?,
    isPrimary: json['is_primary'] as bool,
  );
}

class PlaceCategoryRef {
  final int id;
  final String name;

  PlaceCategoryRef({required this.id, required this.name});

  factory PlaceCategoryRef.fromJson(Map<String, dynamic> json) =>
      PlaceCategoryRef(id: json['id'] as int, name: json['name'] as String);
}

class PlaceTagRef {
  final int tagId;
  final String tagName;
  final double relevance;

  PlaceTagRef({
    required this.tagId,
    required this.tagName,
    required this.relevance,
  });

  factory PlaceTagRef.fromJson(Map<String, dynamic> json) => PlaceTagRef(
    tagId: (json['tag'] as Map<String, dynamic>)['id'] as int,
    tagName: (json['tag'] as Map<String, dynamic>)['name'] as String,
    relevance: double.tryParse(json['relevance'].toString()) ?? 0.0,
  );
}

class PlaceDetail {
  final int id;
  final String name;
  final String address;
  final String ward;
  final String description;
  final String linkGoogleMap;
  final String? phone;
  final String? website;
  final double priceMin;
  final double priceMax;
  final String openingTime;
  final String closingTime;
  final String openDays;
  final double averageRating;
  final int totalReviews;
  final int totalViews;
  final bool isFeatured;
  final String status;
  final List<PlaceImage> images;
  final List<PlaceCategoryRef> categories;
  final List<PlaceTagRef> tags;

  PlaceDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.ward,
    required this.linkGoogleMap,
    required this.phone,
    required this.website,
    required this.priceMin,
    required this.priceMax,
    required this.openingTime,
    required this.closingTime,
    required this.openDays,
    required this.averageRating,
    required this.totalReviews,
    required this.totalViews,
    required this.isFeatured,
    required this.status,
    required this.images,
    required this.categories,
    required this.tags,
  });

  String? get primaryImage {
    if (images.isEmpty) return null;

    final primary = images.where((i) => i.isPrimary);
    return primary.isNotEmpty ? primary.first.imgUrl : images.first.imgUrl;
  }

  factory PlaceDetail.fromJson(Map<String, dynamic> json) => PlaceDetail(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    address: json['address'] as String,
    ward: json['ward'] as String,
    linkGoogleMap: json['link_google_map'] as String,
    phone: json['phone'] as String?,
    website: json['website'] as String?,
    priceMin: double.tryParse(json['price_min'].toString()) ?? 0.0,
    priceMax: double.tryParse(json['price_max'].toString()) ?? 0.0,
    openingTime: json['opening_time'] as String,
    closingTime: json['closing_time'] as String,
    openDays: json['open_days'] as String,
    averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
    totalReviews: json['total_reviews'] as int,
    totalViews: json['total_views'] as int,
    isFeatured: json['is_featured'] as bool,
    status: json['status'] as String,
    images: (json['images'] as List)
        .map((e) => PlaceImage.fromJson(e as Map<String, dynamic>))
        .toList(),
    categories: (json['categories'] as List)
        .map((e) => PlaceCategoryRef.fromJson(e as Map<String, dynamic>))
        .toList(),
    tags: (json['tags'] as List)
        .map((e) => PlaceTagRef.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  PlaceSummary toSummary() => PlaceSummary(
    id: id,
    name: name,
    address: address,
    ward: ward,
    averageRating: averageRating,
    totalReviews: totalReviews,
    isFeatured: isFeatured,
    primaryImage: primaryImage,
    status: status,
    totalViews: totalViews,
    openingTime: openingTime,
    closingTime: closingTime,
  );
}
