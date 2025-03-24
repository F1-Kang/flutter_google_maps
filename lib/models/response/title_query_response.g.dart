// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_query_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryResponse _$QueryResponseFromJson(Map<String, dynamic> json) =>
    QueryResponse(
      json['type'] as String?,
      (json['features'] as List<dynamic>)
          .map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      json['type'] as String?,
      (json['id'] as num?)?.toInt(),
      json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      json['properties'] == null
          ? null
          : Properties.fromJson(json['properties'] as Map<String, dynamic>),
    );

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      json['type'] as String?,
      (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
      json['maki'] as String?,
      json['sizerank'] as num?,
      json['filterrank'] as num?,
      json['type'] as String?,
      json['name_script'] as String?,
      json['iso_3166_1'] as String?,
      json['name_vi'] as String?,
      json['iso_3166_2'] as String?,
      json['class'] as String?,
      json['name'] as String?,
      json['tilequery'] == null
          ? null
          : TitleQuery.fromJson(json['tilequery'] as Map<String, dynamic>),
    );

TitleQuery _$TitleQueryFromJson(Map<String, dynamic> json) => TitleQuery(
      (json['distance'] as num?)?.toDouble(),
      json['geometry'] as String?,
      json['layer'] as String?,
    );
