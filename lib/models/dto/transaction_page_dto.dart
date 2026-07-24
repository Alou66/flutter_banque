import '../transaction_page.dart';
import 'transaction_dto.dart';

/// Représentation JSON d'une [TransactionPage], au format d'une réponse
/// paginée REST classique.
class TransactionPageDto {
  const TransactionPageDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  final List<TransactionDto> items;
  final int page;
  final int pageSize;
  final int totalCount;

  factory TransactionPageDto.fromJson(Map<String, dynamic> json) =>
      TransactionPageDto(
        items: (json['items'] as List)
            .map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        page: json['page'] as int,
        pageSize: json['pageSize'] as int,
        totalCount: json['totalCount'] as int,
      );

  factory TransactionPageDto.fromDomain(TransactionPage page) =>
      TransactionPageDto(
        items: page.items.map(TransactionDto.fromDomain).toList(),
        page: page.page,
        pageSize: page.pageSize,
        totalCount: page.totalCount,
      );

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'page': page,
        'pageSize': pageSize,
        'totalCount': totalCount,
      };

  TransactionPage toDomain() => TransactionPage(
        items: items.map((e) => e.toDomain()).toList(),
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
}
