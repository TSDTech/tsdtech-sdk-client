import 'package:json_annotation/json_annotation.dart';

part 'pagination.model.g.dart';

@JsonSerializable()
class Pagination {
  final int page;
  final int pageCount;

  Pagination({
    required this.page,
    required this.pageCount,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
