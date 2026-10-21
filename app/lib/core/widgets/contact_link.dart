import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/core/domain/phone.dart';

class ContactLink extends StatelessWidget {
  const ContactLink.phone(this.value, {super.key}) : _kind = _ContactKind.phone;

  const ContactLink.email(this.value, {super.key}) : _kind = _ContactKind.email;

  final String value;
  final _ContactKind _kind;

  @override
  Widget build(BuildContext context) {
    final label = _kind == _ContactKind.phone ? Phone.format(value) : value;
    return InkWell(
      onTap: _open,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open() async {
    final uri = _kind == _ContactKind.phone
        ? Uri(scheme: 'tel', path: value)
        : Uri(scheme: 'mailto', path: value);
    await launchUrl(uri);
  }
}

enum _ContactKind { phone, email }
