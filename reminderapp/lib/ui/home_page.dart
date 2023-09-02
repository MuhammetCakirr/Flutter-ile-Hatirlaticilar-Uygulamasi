// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:reminderapp/controllers/task_controller.dart';
import 'package:reminderapp/models/gorev.dart';
import 'package:reminderapp/services/notification_services.dart';
import 'package:reminderapp/services/theme_service.dart';
import 'package:reminderapp/ui/theme.dart';
import 'package:reminderapp/ui/widgets/button.dart';
import 'package:reminderapp/ui/widgets/task_tile.dart';
import 'package:reminderapp/ui/yeni_gorev_ekle.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:workmanager/workmanager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final _taskController=Get.put(TaskController());
  DateTime _selecteddate=DateTime.now();
  var suankitarih;
  var notifyHelper;
  late Timer _timer;
  NotificationHelper notificationHelper=NotificationHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tzdata.initializeTimeZones();
    /*_startTimer();*/
    NotificationHelper.initialize();
    
    AwesomeNotifications().isNotificationAllowed().then((isNotificationAllowed) {
      if(!isNotificationAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } 
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body:  Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          
          _GorevEkleKismi(),
          _TarihlerKismi(),
          SizedBox(height: 10,),
          _GorevleriGoster()

        ],
      ),
    );
  }
  /*
    void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _checkTasksAndSendNotifications();
    });
    print("_startTimer çalıştı");
  }
   
  void _sendNotification(int taskId, String taskName) {
    NotificationHelper.sendNotification(taskId, taskName);
    print("_sendNotification çalıştı");
  }
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
   
  void _checkTasksAndSendNotifications() {
    print("_checkTasksAndSendNotifications çalıştı");
    final istanbul = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(istanbul);
    
  
    for (Task task in _taskController.taskList) {
    if (task.repeat != "Her Gün") {
     
      String startTimeString = task.startTime.toString(); 
    DateFormat inputFormat = DateFormat("HH:mm");
    DateTime taskTime = inputFormat.parse(startTimeString);

    
    DateTime currentTime = DateTime(now.year, now.month, now.day, taskTime.hour, taskTime.minute);

    
    if (now.isAtSameMomentAs(currentTime)) {

      Workmanager().registerOneOffTask(
        '1',
        'simpleTask',
      );
      _sendNotification(task.id!, task.title.toString());
      continue;
    }
    }
  }
}
*/


   _GorevleriGoster(){
    return Expanded(
      child: Obx(
        (){
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index){
                Task task=_taskController.taskList[index]; 
                print("TASK list: "+  _taskController.taskList.length.toString());
                  if(task.repeat=="Her Gün")
                  {
                  String startTimeString = task.startTime.toString(); // Örnek olarak "15:12" gibi bir değer varsayalım
                  DateFormat inputFormat = DateFormat("HH:mm");
                  DateTime dateTime = inputFormat.parse(startTimeString);

                  // Şu anki tarihi kullanarak sadece saat ve dakika bilgisi içeren bir tarih oluşturun
                  DateTime currentTime = DateTime.now();
                  dateTime = DateTime(currentTime.year, currentTime.month, currentTime.day, dateTime.hour, dateTime.minute);

                  DateFormat outputFormat = DateFormat("HH:mm"); // Sadece saat ve dakika formatını belirleyin
                  String formattedTime = outputFormat.format(dateTime);
                  print("saat: "+formattedTime.toString().split(":")[0].toString());
                  print("dakika: "+formattedTime.toString().split(":")[1].toString());
                  NotificationHelper.scheduleNotification(
                    int.parse(formattedTime.toString().split(":")[0]),
                    int.parse(formattedTime.toString().split(":")[1]),
                    task
                  );
                  
                  return AnimationConfiguration.staggeredList(
                  position: index, 
                  child: SlideAnimation(
                    child:FadeInAnimation(
                      child: Row(
                        children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomShee(context,task);
                              },
                              child: TaskTile(task),
                              
                            ),
                        ],
                        
                      ),
                    ) ,
                    
                    )
           
                  );
                  }
               
                if(task.date==suankitarih)
                {
                  print("GÖREV TARİHİ"+task.date.toString());
                  print("ŞUANKİ TARİH"+ suankitarih.toString());
                  return AnimationConfiguration.staggeredList(
                  position: index, 
                  child: SlideAnimation(
                    child:FadeInAnimation(
                      child: Row(
                        children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomShee(context,task);
                              },
                              child: TaskTile(task),   
                            ),
                        ],
                      ),
                    ) ,
                    
                    )
                  
                  );
                }
                else{
                  return Container();
                }
                
              
            },
          );
        }
      ),
    );
   }
   _TarihlerKismi(){
    return Container(
            margin: const EdgeInsets.only(top: 20,left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryclr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
              ),
              dayTextStyle: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
              ),
              monthTextStyle: GoogleFonts.lato(

                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
              ),
              onDateChange: (date){
                setState(() {
                  _selecteddate=date;
                  suankitarih=DateFormat.yMd().format(_selecteddate);
                  print("Tarih "  +_selecteddate.toString());
                });
                
              },
            )
          );
  }
   _GorevEkleKismi(){
    return Container(
            margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(DateFormat.yMMMMd( ).format(DateTime.now()),style: subHeadingStyle,),
                       Text("Bugün",
                       style:HeadingStyle ,
                       )
                    ]
                  ),
                ),
                MyButton(label: "+ Görev Ekle", onTap: ()async{
                 await Get.to(()=>YeniGorevEkle());
                 _taskController.getTasks();
                  }
                  ),

               ],
            ),
          );
  }
    _showBottomShee(BuildContext context,Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 5),
        height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.32,
        color: Get.isDarkMode?darkGreyClr:Colors.white,

        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300]
              ) ,
            ),
            Spacer(),
            task.isCompleted==1?Container(
              
            ):_bottomSheetButton(
              label: "Görevi Bitir", 
              onTap: (){
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              }, 
              color: primaryclr,
              context:context),
              
              _bottomSheetButton(
              label: "Görevi Sil", 
              onTap: (){
                _taskController.delete(task);
                
                Get.back();
              }, 
              color: Colors.red[300]!,
              context:context),
              SizedBox(height: 20,),
              _bottomSheetButton(
              label: "Kapat", 
              onTap: (){
                Get.back();
              }, 
              isClose: true,
              color: Colors.red[300]!,
              context:context),
              SizedBox(height: 10,)
          ],
        ),

        
      )
    );
  }
    _yaziyaz(){
     return print(_taskController.taskList[0].color.toString());
    }
    triggernoti(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10, 
        channelKey: "basic_channel",
        title: "BİLDİRİM",
        body: "BİLDİRİM BODY"
        )
      );
  }
   _bottomSheetButton({required String label,required Function()? onTap,bool isClose=false,required Color color,required BuildContext context})
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
       
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[400]!:color
           ),
           borderRadius: BorderRadius.circular(20),
            color: isClose==true?Colors.transparent:color,
        ),
        child: Center(
          child: Text(
            label, 
            style:isClose?titleStyle:titleStyle.copyWith(color: Colors.white)
            
          ),
        ),

      ),

    );
  }
   _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          triggernoti();
          //notifyHelper.displayNotification(title:"Theme Changed",body:"asdfasd");
        },
        child: Icon(Get.isDarkMode?Icons.wb_sunny_outlined: Icons.nightlight_round,size: 20,color: Get.isDarkMode?Colors.white:Colors.black,
        ),

      ),
      // ignore: prefer_const_literals_to_create_immutables
      actions: [
         CircleAvatar(
          backgroundImage: AssetImage(
            "images/profile.jpg"
          ),
         ),
        SizedBox(width: 20,),
      ],
    );
  }
}


