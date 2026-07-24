import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mocke le canal natif de `flutter_secure_storage` pour toute la suite :
/// aucune plateforme réelle n'est disponible sous `flutter test`, et
/// `SessionTokenController` appelle ce plugin à chaque connexion/déconnexion.
const _channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final storage = <String, String>{};

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
    final key = (call.arguments as Map?)?['key'] as String?;
    switch (call.method) {
      case 'write':
        storage[key!] = (call.arguments as Map)['value'] as String;
        return null;
      case 'read':
        return storage[key];
      case 'delete':
        storage.remove(key);
        return null;
      case 'containsKey':
        return storage.containsKey(key);
      default:
        return null;
    }
  });

  await testMain();
}
