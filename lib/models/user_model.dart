import 'package:flutter/foundation.dart';

/// Global user state used for simple demo purposes.
final ValueNotifier<String> currentUserName = ValueNotifier<String>('Alex');
final ValueNotifier<bool> isUserRegistered = ValueNotifier<bool>(false);
