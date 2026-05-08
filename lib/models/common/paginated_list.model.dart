import 'package:json_annotation/json_annotation.dart';

part 'paginated_list.model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginatedList<T> {
  final List<T> items;
  final int pageCount;

  PaginatedList({
    required this.items,
    required this.pageCount,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedListFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PaginatedListToJson(this, toJsonT);
}