import 'package:json_annotation/json_annotation.dart';

part 'title_query_request.g.dart';

@JsonSerializable(createFactory: false)
class QueryRequest {
  final int radius;
  final int limit;
  final bool? dedupe;
  final String geometry;
  @JsonKey(name: 'access_token')
  final String accessToken;

  QueryRequest({
    this.radius = 1000,
    this.limit = 50,
    this.dedupe,
    this.geometry = 'point',
    this.accessToken =
        'pk.eyJ1Ijoia2FuZ2YxIiwiYSI6ImNtOGk2NTAydDA4Nncya211dTN3bjl3czgifQ.gEtB60ZQIvUnkCa7-N3JHg',
  });

  Map<String, dynamic> toJson() => _$QueryRequestToJson(this);
}
