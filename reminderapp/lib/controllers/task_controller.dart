import 'package:get/get.dart';
import 'package:reminderapp/db/db_helper.dart';
import 'package:reminderapp/models/gorev.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    super.onReady();
  }

 var taskList=<Task>[]. obs;
  Future<int> addTask({Task? task})async{
      return await DbHelper.insert(task);
  }

  void getTasks() async{
    List<Map<String,dynamic>> tasks =await DbHelper.query();
    taskList.assignAll(tasks.map((data)=>new Task.fromJson(data)).toList());
  }

  void delete(Task task){
    var val=DbHelper.delete(task);
    print(val);
    getTasks();

  }

  void markTaskCompleted(int id)async{
  await DbHelper.update(id);
  getTasks();
  }
}