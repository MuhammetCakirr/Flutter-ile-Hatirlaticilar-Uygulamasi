

// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:reminderapp/controllers/task_controller.dart';
import 'package:reminderapp/models/gorev.dart';
import 'package:reminderapp/ui/theme.dart';
import 'package:reminderapp/ui/widgets/button.dart';
import 'package:reminderapp/ui/widgets/input_field.dart';
import 'package:intl/date_symbol_data_local.dart';


class YeniGorevEkle extends StatefulWidget {
  const YeniGorevEkle({super.key});

  @override
  State<YeniGorevEkle> createState() => _YeniGorevEkleState();
}

class _YeniGorevEkleState extends State<YeniGorevEkle> {
  final TaskController _taskController=Get.put(TaskController());
  final TextEditingController _titlecontroller=TextEditingController();
  final TextEditingController _notecontroller=TextEditingController();
  DateTime _selectedDate=DateTime.now();
  String _endTime="9:30 PM";
  String _startTime=DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedremind=5;
  List<int> remindList=[5,10,15,20,25,30];
  String _selectedrepeat="Tekrarlama";
  List<String> repeatList=["Tekrarlama","Her Gün","Haftada 1 kez", "Ayda 1 Kez"];
  int _selectedcolor=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        // ignore: prefer_const_constructors
        child: SingleChildScrollView(
          // ignore: prefer_const_constructors
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "Görev Ekle",
                style: HeadingStyle,
              
              ),
              
               MyInputField(hint: " Başlığı girin", title: "Başlık",controller: _titlecontroller,),
                MyInputField(hint: " Görevi girin", title: "Görev", controller: _notecontroller,),
                MyInputField(hint: DateFormat.yMd('tr').format(_selectedDate), title: "Tarih",
                widget: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed:(){
                    _takvimiGoster();
                  } ,
                   color: Colors.grey,),
                
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Başlangıç Saati",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: ()
                          {
                            _saatiGoster(isStartTime: true);
                          },
                          icon: Icon(Icons.access_alarm,color: Colors.grey),
                        ),
                      )
                      
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                      child: MyInputField(
                        title: "Bitiş Saati",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: ()
                          {
                            _saatiGoster(isStartTime: false);
                          },
                          icon: Icon(Icons.access_alarm,color: Colors.grey),
                        ),
                      )
                      
                      ),
                  ],
                ),
                MyInputField(hint: "$_selectedremind dakika aralıkla", title: "Hatırlatma",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(height: 0,),
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                            child: Text(value.toString()),
                    );
                  }
                ).toList(), 
                
                onChanged: (String? value) { 
                  setState(() {
                    _selectedremind=int.parse(value!);
                  });
                 },
                )
                
                ),
                 MyInputField(hint: "$_selectedrepeat", title: "Tekrar",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(height: 0,),
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                            child: Text(value,style: TextStyle(color: Colors.grey),),
                    );
                  }
                ).toList(), 
                
                onChanged: (String? value) { 
                  setState(() {
                    _selectedrepeat=value!;
                  });
                 },
                )
                
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _renkSecimKismi(),
                    MyButton(label: "Hatırlatıcıyı Oluştur", onTap: ()=> _validateDate())

                  ],
                )

            ],
          )
          ),
      ),

    );
  }

  _validateDate(){
    if(_titlecontroller.text.isNotEmpty&&_notecontroller.text.isNotEmpty){
      _addTasktoDb();
      Get.back();
    }
    else if(_titlecontroller.text.isEmpty||_notecontroller.text.isEmpty){
      Get.snackbar(
        "Zorunlu Alan", 
        "Lütfen Doldurunuz",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromARGB(255, 102, 96, 208),
        icon: Icon(Icons.warning_amber_rounded),
        colorText: Colors.white
        );
    }
  }

  _addTasktoDb() async {
    Task task=Task(
      note: _notecontroller.text,
      title: _titlecontroller.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedremind,
      repeat: _selectedrepeat,
      color: _selectedcolor,
      isCompleted: 0);

   int value=await _taskController.addTask(task: task
    );
    
    print("my renk is  "+task.color.toString()); 
  }
  _renkSecimKismi(){
    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Renk",
                        style: titleStyle,
                        ),
                        SizedBox(height: 8.0,),
                        Wrap(
                          children: List<Widget>.generate(
                            3,
                            (int index) {
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _selectedcolor=index;
                                  });
                                  
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right:8.0),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: index==0?primaryclr:index==1?Colors.pink:Colors.yellow,
                                    child: _selectedcolor==index?Icon(Icons.done
                                    ,color: Colors.white,
                                    size: 16,
                                    ):Container(),
                                  ),
                                ),
                              );
                            })
                          
                          )
                           
                          
                        
                      ],
                    );
  }
  _saatiGoster({required bool isStartTime}) async{
    var _pickedTime=await _showtimepicker();
    String _formattedTime=  _pickedTime.format(context);
    if(_pickedTime==null){
      print("Time Seçilmedi");
    }else if(isStartTime==true){
      setState(() {
        _startTime=_formattedTime;
      });
      
    }else if(isStartTime==false){
      setState(() {
        _endTime=_formattedTime;
      });
      
    }
  }
  _showtimepicker(){
    return showTimePicker(initialEntryMode: TimePickerEntryMode.input,context: context, 
    initialTime: TimeOfDay(
      hour: int.parse(_startTime.split(":")[0]),
       minute: int.parse(_startTime.split(":")[1].split(" ")[0])
       ));
  }

  _takvimiGoster() async {
    DateTime? _pickerDate= await showDatePicker(
      context: context,
     initialDate: DateTime.now(),
      firstDate: DateTime(2016),
       lastDate: DateTime(2123));

       if(_pickerDate!=null)
       {
        setState(() {
          _selectedDate=_pickerDate;
        });
        
       }
       else{

       }
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
        size: 20,
        color: Get.isDarkMode?Colors.white:Colors.black,
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

