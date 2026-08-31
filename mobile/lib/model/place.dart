class PlaceSummary{
  final int id;
  final String name;
  final String address;
  final String ward;
  final double averageRating;
  final int totalReviews;
  final bool isFeatured;
  final String? primaryImage;
  final int totalViews;
  final String status;
  final String openingTime;
  final String closingTime;

  PlaceSummary({
    required this.id,
    required this.name,
    required this.address,
    required this.ward,
    required this.averageRating,
    required this.totalReviews,
    required this.isFeatured,
    required this.primaryImage,
    required this.status,
    required this.totalViews,
    required this.openingTime,
    required this.closingTime,

  });

  factory PlaceSummary.fromJson(Map<String, dynamic> json){
    return PlaceSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      ward: json['ward'] as String,
      averageRating: double.tryParse(json['average_rating'].toString()) ?? 0.0,
      totalReviews: json['total_reviews'] as int,
      isFeatured: json['is_featured'] as bool,
      primaryImage: json['primary_image'] as String?,
      status: json['status'] as String,
      totalViews: json['total_views'] as int,
      openingTime: json['opening_time'] as String,
      closingTime: json['closing_time'] as String,
    );
  }
}