import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/todo_list_provider.dart';

class EditTodo extends StatefulWidget {
  var task, taskdesc, date, type, place, id, status;

  EditTodo(
      {this.type,
      this.taskdesc,
      this.task,
      this.place,
      this.date,
      this.id,
      this.status,
      Key? key})
      : super(key: key);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final taskName_controller = TextEditingController();
  final taskDescription_controller = TextEditingController();
  final place_controller = TextEditingController();
  var dateTime = '';
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String selectedValue = 'Choose Category';

  @override
  void initState() {
    taskName_controller.text = widget.task;
    taskDescription_controller.text = widget.taskdesc;
    place_controller.text = widget.place;
    selectedValue = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    final providerTodo = Provider.of<TodoProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xff46539E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff46539E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Edit Todo'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.display_settings_sharp),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child:
                  // CircleAvatar(
                  //   radius: 40,
                  //   backgroundColor: Colors.grey,
                  //   foregroundColor: Colors.white,
                  //
                  //   child: icons(selectedValue),
                  // ),
                  Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: const BoxDecoration(
                        color: Colors.grey, // border color
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                          radius: 30,
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          child: icons(selectedValue))),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                DropdownButton(
                  hint: Text(
                    selectedValue,
                    style: TextStyle(
                        color: selectedValue == 'Choose Category'
                            ? Colors.grey
                            : Colors.white,
                        fontSize: 15),
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  // style:  const TextStyle(color: Colors.white),

                  //   value: selectedValue.toString(),
                  iconEnabledColor: Colors.grey,
                  items: ['Choose Category', 'Business', 'Shopping', 'Reminder']
                      .map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        selectedValue = val!;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: taskName_controller,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    hintText: "Enter Task",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: taskDescription_controller,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    hintText: "Enter Task Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: place_controller,
                  textInputAction: TextInputAction.go,
                  decoration: const InputDecoration(
                    hintText: "Enter Place",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                DateTimeField(
                    resetIcon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                    format: format,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          //<-- SEE HERE
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        label: Text(
                          'Pick Date and Time',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        )),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
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
                    }),
                const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  height: 50,
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    providerTodo.updateTask(
                        widget.id,
                        taskName_controller.text,
                        taskDescription_controller.text,
                        dateTime,
                        selectedValue,
                        place_controller.text,
                        widget.status);
                    // taskName.clear();
                    // taskDescription.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'EDIT YOUR THINGS',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget icons(selectedValue) {
    switch (selectedValue) {
      case "Business":
        return Icon(Icons.add_business,
            color: widget.status == 'COMPLETED' ? Colors.green : Colors.red);
      case "Shopping":
        return Icon(Icons.shopping_bag_outlined,
            color: widget.status == 'COMPLETED' ? Colors.green : Colors.red);
      case "Reminder":
        return Icon(Icons.lock_clock,
            color: widget.status == 'COMPLETED' ? Colors.green : Colors.red);
      default:
        return Icon(Icons.add,
            color: widget.status == 'COMPLETED' ? Colors.green : Colors.red);
    }
  }
}
