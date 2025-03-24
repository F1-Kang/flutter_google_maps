import 'package:json_annotation/json_annotation.dart';

part 'title_query_response.g.dart';

@JsonSerializable(createToJson: false)
class QueryResponse {
  final String? type;
  final List<Feature> features;

  QueryResponse(this.type, this.features);

  factory QueryResponse.fromJson(Map<String, dynamic> json) =>
      _$QueryResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Feature {
  final String? type;
  final int? id;
  final Geometry? geometry;
  final Properties? properties;

  Feature(this.type, this.id, this.geometry, this.properties);

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
}

@JsonSerializable(createToJson: false)
class Geometry {
  final String? type;
  final List<double>? coordinates;

  Geometry(this.type, this.coordinates);

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}

@JsonSerializable(createToJson: false)
class Properties {
  final String? maki;
  @JsonKey(name: 'sizerank')
  final num? sizeRank;
  @JsonKey(name: 'filterrank')
  final num? filterRank;
  final String? type;
  @JsonKey(name: 'name_script')
  final String? nameScript;
  @JsonKey(name: 'iso_3166_1')
  final String? iso31661;
  @JsonKey(name: 'name_vi')
  final String? nameVi;
  @JsonKey(name: 'iso_3166_2')
  final String? iso31662;
  @JsonKey(name: 'class')
  final String? tClass;
  final String? name;
  @JsonKey(name: 'tilequery')
  final TitleQuery? titleQuery;

  Properties(
    this.maki,
    this.sizeRank,
    this.filterRank,
    this.type,
    this.nameScript,
    this.iso31661,
    this.nameVi,
    this.iso31662,
    this.tClass,
    this.name,
    this.titleQuery,
  );

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
}

@JsonSerializable(createToJson: false)
class TitleQuery {
  final double? distance;
  final String? geometry;
  final String? layer;

  TitleQuery(this.distance, this.geometry, this.layer);

  factory TitleQuery.fromJson(Map<String, dynamic> json) =>
      _$TitleQueryFromJson(json);
}
