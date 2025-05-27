// To parse this JSON data, do
//
//     final reviewsModel = reviewsModelFromJson(jsonString);

import 'dart:convert';

ReviewsModel reviewsModelFromJson(String str) => ReviewsModel.fromJson(json.decode(str));

String reviewsModelToJson(ReviewsModel data) => json.encode(data.toJson());

class ReviewsModel {
  List<Datum>? data;
  Pagination? pagination;

  ReviewsModel({
    this.data,
    this.pagination,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  dynamic id;
  dynamic listing;
  dynamic parent;
  dynamic author;
  String? authorName;
  String? authorEmail;
  String? authorUrl;
  String? authorIp;
  String? authorUserAgent;
  DateTime? date;
  DateTime? dateGmt;
  dynamic rating;
  String? title;
  Content? content;
  String? status;
  Map<String, String>? authorAvatarUrls;

  Datum({
    this.id,
    this.listing,
    this.parent,
    this.author,
    this.authorName,
    this.authorEmail,
    this.authorUrl,
    this.authorIp,
    this.authorUserAgent,
    this.date,
    this.dateGmt,
    this.rating,
    this.title,
    this.content,
    this.status,
    this.authorAvatarUrls,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    listing: json["listing"],
    parent: json["parent"],
    author: json["author"],
    authorName: json["author_name"],
    authorEmail: json["author_email"],
    authorUrl: json["author_url"],
    authorIp: json["author_ip"],
    authorUserAgent: json["author_user_agent"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    dateGmt: json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
    rating: json["rating"],
    title: json["title"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    status: json["status"],
    authorAvatarUrls: Map.from(json["author_avatar_urls"]!).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "listing": listing,
    "parent": parent,
    "author": author,
    "author_name": authorName,
    "author_email": authorEmail,
    "author_url": authorUrl,
    "author_ip": authorIp,
    "author_user_agent": authorUserAgent,
    "date": date?.toIso8601String(),
    "date_gmt": dateGmt?.toIso8601String(),
    "rating": rating,
    "title": title,
    "content": content?.toJson(),
    "status": status,
    "author_avatar_urls": Map.from(authorAvatarUrls!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Content {
  String? rendered;
  String? raw;

  Content({
    this.rendered,
    this.raw,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"],
    raw: json["raw"],
  );

  Map<String, dynamic> toJson() => {
    "rendered": rendered,
    "raw": raw,
  };
}

class Pagination {
  dynamic total;
  dynamic perPage;
  dynamic currentPage;
  dynamic totalPages;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "current_page": currentPage,
    "total_pages": totalPages,
  };
}
