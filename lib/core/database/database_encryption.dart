import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

import '../security/secure_store.dart';

/// Builds and stores the SQLite encryption key in the system Keychain.
abstract final class DatabaseEncryption {
  static const plaintextName = 'billkiller';
  static const encryptedName = 'kichta';

  static Future<String> ensureKey(SecureStore store) async {
    final existing = await store.read(SecureStorePolicy.databaseKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final bytes = List<int>.generate(
      32,
      (_) => Random.secure().nextInt(256),
    );
    final created = base64UrlEncode(bytes);
    await store.write(key: SecureStorePolicy.databaseKey, value: created);
    return created;
  }

  static String escapeSqlString(String value) {
    return value.replaceAll("'", "''");
  }

  static void assertCipher(CommonDatabase db) {
    if (db.select('PRAGMA cipher').isEmpty) {
      throw StateError('Encrypted SQLite is not available.');
    }
  }

  static void applyKey(CommonDatabase db, String key) {
    assertCipher(db);
    db.execute("PRAGMA key = '${escapeSqlString(key)}'");
  }

  static void rekey(CommonDatabase db, String key) {
    assertCipher(db);
    db.execute("PRAGMA rekey = '${escapeSqlString(key)}'");
  }

  static QueryExecutor open(String key) {
    return driftDatabase(
      name: encryptedName,
      native: DriftNativeOptions(setup: (db) => applyKey(db, key)),
    );
  }

  /// Copies a leftover plaintext `billkiller.sqlite` into the encrypted file.
  static Future<void> migratePlaintextIfNeeded(String key) async {
    final directory = await getApplicationDocumentsDirectory();
    final plaintext = File(p.join(directory.path, '$plaintextName.sqlite'));
    final encrypted = File(p.join(directory.path, '$encryptedName.sqlite'));
    if (!await plaintext.exists() || await encrypted.exists()) {
      return;
    }

    final tmp = File('${encrypted.path}.tmp');
    if (await tmp.exists()) {
      await tmp.delete();
    }

    final source = sqlite3.open(plaintext.path);
    source.execute("VACUUM INTO '${escapeSqlString(tmp.path)}'");
    source.close();

    final target = sqlite3.open(tmp.path);
    rekey(target, key);
    target.close();

    await tmp.rename(encrypted.path);
    await plaintext.delete();
    for (final suffix in ['-wal', '-shm']) {
      final leftover = File('${plaintext.path}$suffix');
      if (await leftover.exists()) {
        await leftover.delete();
      }
    }
  }
}
