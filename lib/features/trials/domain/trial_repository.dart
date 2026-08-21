import 'trial.dart';

abstract class TrialRepository {
  Future<List<Trial>> getAll();

  Future<Trial?> getById(String id);

  Future<void> save(Trial trial);

  Future<void> deleteById(String id);
}
