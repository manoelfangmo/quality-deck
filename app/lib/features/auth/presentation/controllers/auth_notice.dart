import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notice.g.dart';

@Riverpod(keepAlive: true)
class AuthNotice extends _$AuthNotice {
  @override
  String? build() => null;

  void show(String message) => state = message;

  void clear() => state = null;
}

abstract final class AuthMessages {
  static const noLongerHaveAccess =
      'You no longer have access to that business.';
  static const codeCopied = 'Code copied';
}
