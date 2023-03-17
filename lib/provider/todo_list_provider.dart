import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoProvider with ChangeNotifier {
  FirebaseAuth firebase = FirebaseAuth.instance;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final taskName = TextEditingController();
  final taskDescription = TextEditingController();
  var dateTime = '';

  String ?ListLength ='';
  String? get listLength => ListLength;

  void addTask(String taskNames, taskDesc, date, type, place, status) {
    if (taskNames.isEmpty || taskDesc.isEmpty || date.isEmpty) {
      return;
    } else {
      FirebaseFirestore.instance
          .collection(
        "${firebase.currentUser!.email}",
      )
          .add({
        "TaskName": taskNames,
        "Description": taskDesc,
        "Date": date,
        "Type": type,
        "Place": place,
        "Status": status,
      });
      notifyListeners();
    }
  }

  deleteTask(String id) {
    FirebaseFirestore.instance
        .collection("${firebase.currentUser!.email}")
        .doc(id)
        .delete();
    notifyListeners();
  }

  updateTask(String id, taskName, taskDesc, date,type,place,status) {
    FirebaseFirestore.instance
        .collection("${firebase.currentUser!.email}")
        .doc(id)
        .update({"TaskName": taskName, "Description": taskDesc, "Date": date,'Place':place,'Type':type,'Status':status});
    notifyListeners();
  }

  void showDeleteDialog(String id, context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: const Text('Do you want to remove it?'),
          title: const Text('Remove?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                deleteTask(id);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Delete'),
            )
          ],
        );
      },
    );
    notifyListeners();
  }

  // void showAddDialog(context) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         content: Container(
  //           height: 300,
  //           child: Material(
  //             color: Colors.transparent,
  //             child: ListView(
  //               shrinkWrap: true,
  //               children: [
  //                 TextField(
  //                   controller: taskName,
  //                   textInputAction: TextInputAction.go,
  //                   keyboardType: const TextInputType.numberWithOptions(),
  //                   decoration: const InputDecoration(hintText: "Enter Task"),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 TextField(
  //                   controller: taskDescription,
  //                   textInputAction: TextInputAction.go,
  //                   keyboardType: const TextInputType.numberWithOptions(),
  //                   decoration: const InputDecoration(
  //                       hintText: "Enter Task Description"),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 DateTimeField(
  //                     format: format,
  //                     decoration: const InputDecoration(
  //                         label: Text('Pick Date and Time')),
  //                     onShowPicker: (context, currentValue) async {
  //                       return await showDatePicker(
  //                         context: context,
  //                         firstDate: DateTime(1900),
  //                         initialDate: currentValue ?? DateTime.now(),
  //                         lastDate: DateTime(2100),
  //                       ).then((DateTime? date) async {
  //                         if (date != null) {
  //                           final time = await showTimePicker(
  //                             context: context,
  //                             initialTime: TimeOfDay.fromDateTime(
  //                                 currentValue ?? DateTime.now()),
  //                           );
  //                           dateTime =
  //                               DateTimeField.combine(date, time).toString();
  //                           return DateTimeField.combine(date, time);
  //                         } else {
  //                           dateTime = currentValue.toString();
  //                           return currentValue;
  //                         }
  //                       });
  //                     })
  //               ],
  //             ),
  //           ),
  //         ),
  //         title: const Text('Add Todo List !'),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('Cancel')),
  //           TextButton(
  //             onPressed: () async {
  //               addTask(taskName.text, taskDescription.text, dateTime);
  //               taskName.clear();
  //               taskDescription.clear();
  //               Navigator.of(context).pop();
  //             },
  //             style: ButtonStyle(
  //               foregroundColor: MaterialStateProperty.all(Colors.red),
  //             ),
  //             child: const Text('Add'),
  //           )
  //         ],
  //       );
  //     },
  //   );
  //   notifyListeners();
  // }

  void showEditDialog(String id, TaskName, Description,Type,Place,Status, context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        taskName.text = TaskName;
        taskDescription.text = Description;

        return CupertinoAlertDialog(
          content: Container(
            height: 300,
            child: Material(
              color: Colors.transparent,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextField(
                    controller: taskName,
                    textInputAction: TextInputAction.go,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(hintText: "Enter Task"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: taskDescription,
                    textInputAction: TextInputAction.go,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                        hintText: "Enter Task Description"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimeField(
                      format: format,
                      decoration: const InputDecoration(
                          label: Text('Pick Date and Time')),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((DateTime? date) async {
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            dateTime =
                                DateTimeField.combine(date, time).toString();
                            return DateTimeField.combine(date, time);
                          } else {
                            dateTime = currentValue.toString();
                            return currentValue;
                          }
                        });
                      })
                ],
              ),
            ),
          ),
          title: const Text('Edit Todo List !'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
              //  updateTask(id, taskName.text, taskDescription.text, dateTime,);
                taskName.clear();
                taskDescription.clear();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Update'),
            )
          ],
        );
      },
    );
    notifyListeners();
  }
}
