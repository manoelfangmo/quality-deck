import 'package:app/core/database/rpc.dart';

class CreateBusinessCommand {
  const CreateBusinessCommand({required this.name});

  final String name;

  Map<String, dynamic> toJson() => {Rpc.pName: name};
}

class RedeemInviteCommand {
  const RedeemInviteCommand({required this.code});

  final String code;

  Map<String, dynamic> toJson() => {Rpc.pCode: code};
}
