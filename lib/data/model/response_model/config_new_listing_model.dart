// To parse this JSON data, do
//
//     final configNewListingModel = configNewListingModelFromJson(jsonString);

import 'dart:convert';

ConfigNewListingModel configNewListingModelFromJson(String str) => ConfigNewListingModel.fromJson(json.decode(str));

String configNewListingModelToJson(ConfigNewListingModel data) => json.encode(data.toJson());

class ConfigNewListingModel {
  bool? eligible;
  List<Type>? listingTypes;
  List<Type>? priceTypes;
  List<dynamic>? hiddenFields;

  ConfigNewListingModel({
    this.eligible,
    this.listingTypes,
    this.priceTypes,
    this.hiddenFields,
  });

  factory ConfigNewListingModel.fromJson(Map<String, dynamic> json) => ConfigNewListingModel(
    eligible: json["eligible"],
    listingTypes: json["listing_types"] == null ? [] : List<Type>.from(json["listing_types"]!.map((x) => Type.fromJson(x))),
    priceTypes: json["price_types"] == null ? [] : List<Type>.from(json["price_types"]!.map((x) => Type.fromJson(x))),
    hiddenFields: json["hidden_fields"] == null ? [] : List<dynamic>.from(json["hidden_fields"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "eligible": eligible,
    "listing_types": listingTypes == null ? [] : List<dynamic>.from(listingTypes!.map((x) => x.toJson())),
    "price_types": priceTypes == null ? [] : List<dynamic>.from(priceTypes!.map((x) => x.toJson())),
    "hidden_fields": hiddenFields == null ? [] : List<dynamic>.from(hiddenFields!.map((x) => x)),
  };
}

class Type {
  String? id;
  String? name;

  Type({
    this.id,
    this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
