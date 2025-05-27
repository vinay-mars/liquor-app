import 'dart:convert';

AllStoreModel allStoreModelFromJson(String str) => AllStoreModel.fromJson(json.decode(str));

String allStoreModelToJson(AllStoreModel data) => json.encode(data.toJson());

class AllStoreModel {
  List<Datum>? data;
  Pagination? pagination;

  AllStoreModel({
    this.data,
    this.pagination,
  });

  factory AllStoreModel.fromJson(Map<String, dynamic> json) => AllStoreModel(
    data: (json["data"] as List<dynamic>?)
        ?.map((x) => Datum.fromJson(x))
        .toList(),
    pagination: json["pagination"] != null
        ? Pagination.fromJson(json["pagination"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "data": data != null
        ? List<dynamic>.from(data!.map((x) => x.toJson()))
        : null,
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  dynamic id;
  dynamic title;
  dynamic logo;
  dynamic listingsCount;

  Datum({
    this.id,
    this.title,
    this.logo,
    this.listingsCount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    logo: json["logo"],
    listingsCount: json["listings_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "logo": logo,
    "listings_count": listingsCount,
  };
}

class Pagination {
  dynamic total;
  dynamic count;
  dynamic perPage;
  dynamic currentPage;
  dynamic totalPages;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    count: json["count"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "count": count,
    "per_page": perPage,
    "current_page": currentPage,
    "total_pages": totalPages,
  };
}
