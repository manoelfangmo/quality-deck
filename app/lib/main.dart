import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/app.dart';
import 'package:app/core/constants/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  Environment.validate();
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: Environment.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: App()));
}
