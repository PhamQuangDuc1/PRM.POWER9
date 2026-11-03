import '../models/activity.dart';
import '../models/completion.dart';

abstract interface class CompletionService {
  Stream<List<Completion>> watchDay(String uid, String dateKey);
  Future<void> record({
    required String uid,
    required Activity activity,
    required String dateKey,
    required CompletionSource source,
    int? durationSeconds,
  });
  Future<void> delete(String uid, String id);
}
