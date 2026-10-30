import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/utils/local_store.dart';
import 'package:app/core/utils/local_store_factory.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) => Supabase.instance.client;

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const Clock();

@Riverpod(keepAlive: true)
LocalSettings localSettings(Ref ref) => LocalSettings(createLocalStore());
