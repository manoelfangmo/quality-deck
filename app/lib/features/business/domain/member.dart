import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/user_role.dart';
import 'package:app/core/utils/json_converters.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
abstract class Member with _$Member {
  const factory Member({
    required String id,
    required String fullName,
    required String email,
    required UserRole role,
    @UtcToLocalConverter() required DateTime joinedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
