import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/repositories/asignaciones_repository.dart';

class AdminProvider extends ChangeNotifier {
  final AsignacionesRepository _repository = AsignacionesRepository();
  List<ActivityModel> _activities = [];
  List<ActivityModel> _selectedActivities = [];

  List<ActivityModel> get activities => _activities;
  List<ActivityModel> get selectedActivities => _selectedActivities;

  Future<void> loadActivities() async {
    _activities = await _repository.getActivities();
    notifyListeners();
  }

  Future<void> saveActivity(ActivityModel activity) async {
    await _repository.saveActivity(activity);
    await loadActivities();
  }

  void selectActivity(ActivityModel activity) {
    if (!_selectedActivities.contains(activity)) {
      _selectedActivities.add(activity);
      notifyListeners();
    }
  }

  void unselectActivity(ActivityModel activity) {
    _selectedActivities.remove(activity);
    notifyListeners();
  }

  void clearSelectedActivities() {
    _selectedActivities.clear();
    notifyListeners();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    await _repository.updateActivity(activity);
    await loadActivities();
  }

  Future<void> deleteActivity(String id) async {
    await _repository.deleteActivity(id);
    await loadActivities();
  }
}
