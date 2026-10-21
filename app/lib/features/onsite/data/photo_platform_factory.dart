import 'package:app/features/onsite/data/photo_platform.dart';
import 'package:app/features/onsite/data/photo_platform_stub.dart'
    if (dart.library.js_interop) 'package:app/features/onsite/data/photo_platform_web.dart'
    if (dart.library.io) 'package:app/features/onsite/data/photo_platform_io.dart';

PhotoPlatform createPhotoPlatform() => createPlatformPhotoAdapters();
