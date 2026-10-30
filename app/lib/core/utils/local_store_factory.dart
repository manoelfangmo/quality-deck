import 'package:app/core/utils/local_store.dart';
import 'package:app/core/utils/local_store_stub.dart'
    if (dart.library.js_interop) 'package:app/core/utils/local_store_web.dart';

LocalStore createLocalStore() => createPlatformLocalStore();
