import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/todo_list_provider.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final taskName_controller = TextEditingController();
  final taskDescription_controller = TextEditingController();
  final place_controller = TextEditingController();
  var dateTime = '';
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String selectedValue = 'Choose Category';

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
        title: const Text('Add new things'),
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
                        color: Color(0xFFFFFFFF), // border color
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                          radius: 30,
                          // foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff46539E),
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

                    providerTodo.addTask(taskName_controller.text, taskDescription_controller.text, dateTime,selectedValue,place_controller.text,'PENDING');
                    // taskName.clear();
                    // taskDescription.clear();
                     Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ADD YOUR THINGS',
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
        return const Icon(Icons.add_business);
      case "Shopping":
        return const Icon(Icons.shopping_bag_outlined);
      case "Reminder":
        return const Icon(Icons.lock_clock);
      default:
        return const Icon(Icons.add);
    }
  }
}
