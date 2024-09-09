import '../../models/task.model.dart';
import '../../services/home/tasks.service.dart';
import '../base_controller.dart';

class HomeController extends BaseController {
  static HomeController? _instance;

  HomeController._(this._tasksService) {
    loadUserTasks();
  }

  factory HomeController(TasksService tasksService) {
    _instance ??= HomeController._(tasksService);
    return _instance!;
  }

  final TasksService _tasksService;

  /// Current Date state
  late DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  Future<void> updateSelectedDate(DateTime newSelectedDate) async {
    if (newSelectedDate == _selectedDate) return;

    _selectedDate = newSelectedDate;

    notifyListeners();
  }

  /// Tasks state
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task taskToAdd) async {
    toggleLoading();

    final task = await _tasksService.addTask(taskToAdd);
    _tasks.add(task);

    notifyListeners();
    toggleLoading();
  }

  void removeTask(Task taskToRemove) async {
    toggleLoading();

    final task = await _tasksService.removeTask(taskToRemove);
    _tasks.remove(task);

    notifyListeners();
    toggleLoading();
  }

  void editTask(Task editedTask) async {
    toggleLoading();

    await _tasksService.editTask(editedTask);

    final currentTaskPosition = _tasks.indexWhere((t) => t.id == editedTask.id);
    _tasks[currentTaskPosition] = editedTask;

    notifyListeners();
    toggleLoading();
  }

  void loadUserTasks() async {
    toggleLoading();

    final userTasks = await _tasksService.loadTasks(selectedDate);
    _tasks.addAll(userTasks.tasks);

    notifyListeners();
    toggleLoading();
  }
}
