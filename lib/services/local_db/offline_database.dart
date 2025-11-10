import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../modules/attendance/models/attendance_models.dart';


class _StubDb extends GeneratedDatabase {
  _StubDb(super.e);
  @override
  int get schemaVersion => 1;
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables => const <TableInfo<Table, dynamic>>[];
}

/// Drift आधारित लोकल डेटाबेस जो ऑफ़लाइन पेंडिंग इवेंट्स को स्टोर करता है।
/// Public API SAME hai (methods/namings unchanged).
class OfflineDatabase {
  OfflineDatabase._(this._executor) : _db = _StubDb(_executor);

  final QueryExecutor _executor;
  final _StubDb _db; // ensureOpen ke liye internal stub DB

  /// डिफ़ॉल्ट फ़ाइल आधारित डेटाबेस खोलना।
  static Future<OfflineDatabase> open() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'attendance_offline.sqlite'));

    final QueryExecutor executor = NativeDatabase(file, logStatements: false);
    final OfflineDatabase database = OfflineDatabase._(executor);

    // IMPORTANT: Drift executor ko ek baar properly open karo
    await database._executor.ensureOpen(database._db);

    // Schema ensure karo
    await database._createSchema();
    return database;
  }

  /// इन-मेमोरी डेटाबेस (tests ke liye).
  static Future<OfflineDatabase> openInMemory() async {
    final QueryExecutor executor = NativeDatabase.memory(logStatements: false);
    final OfflineDatabase database = OfflineDatabase._(executor);

    await database._executor.ensureOpen(database._db);
    await database._createSchema();
    return database;
  }

  /// Schema create/ensure (RAW SQL same rakha gaya hai)
  Future<void> _createSchema() async {
    // Prefer stub DB ki customStatement — executor open guaranteed.
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS pending_events (
        id TEXT PRIMARY KEY,
        employee_id TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at INTEGER NOT NULL
      );
    ''');
  }

  /// सभी पेंडिंग इवेंट्स को लोड करें।
  Future<List<PendingAttendanceEvent>> loadPendingEvents() async {
    // Executor ab open hai, runSelect safe hai.
    final List<Map<String, Object?>> rows = await _executor.runSelect(
      'SELECT id, employee_id, payload, created_at FROM pending_events ORDER BY created_at ASC',
      const <Object?>[],
    );

    return rows
        .map((row) => PendingAttendanceEvent(
      id: row['id']! as String,
      employeeId: row['employee_id']! as String,
      day: AttendanceDay.fromJson(
        jsonDecode(row['payload']! as String) as Map<String, dynamic>,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at']! as int,
      ),
    ))
        .toList();
  }

  /// किसी इवेंट को सुरक्षित करें।
  Future<void> insertEvent(PendingAttendanceEvent event) async {
    await _executor.runInsert(
      'INSERT OR REPLACE INTO pending_events (id, employee_id, payload, created_at) VALUES (?, ?, ?, ?)',
      <Object?>[
        event.id,
        event.employeeId,
        jsonEncode(event.day.toJson()),
        event.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  /// पूरे क्यू को साफ़ करें।
  Future<void> clearEvents() async {
    await _executor.runDelete(
      'DELETE FROM pending_events',
      const <Object?>[],
    );
  }

  Future<void> close() async {
    await _executor.close();
  }
}
