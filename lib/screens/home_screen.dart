import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/todo_list_provider.dart';
import 'login_screen.dart';

final TextEditingController todo = TextEditingController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebase = FirebaseAuth.instance;
    final providerTodo = Provider.of<TodoProvider>(context);

    return StreamBuilder<User?>(
      stream: context.watch<AuthProvider>().stream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).signOut();
                  },
                  icon: const Icon(Icons.logout))
            ],
            title: const Text("Todo List"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: TextFormField(
                    //     decoration: InputDecoration(
                    //         disabledBorder: OutlineInputBorder(
                    //           borderSide: const BorderSide(
                    //             color: Colors.grey,
                    //           ),
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderSide: const BorderSide(
                    //             color: Colors.blueAccent,
                    //           ),
                    //           borderRadius: BorderRadius.circular(10.0),
                    //         ),
                    //         // focusedBorder: OutlineInputBorder(
                    //         //   borderSide: const BorderSide(
                    //         //     color: Colors.red,
                    //         //   ),
                    //         //   borderRadius: BorderRadius.circular(10.0),
                    //         // ),
                    //         // // contentPadding: const EdgeInsets.symmetric(
                    //         //     horizontal: 20, vertical: 10),
                    //         suffixIcon: IconButton(
                    //           icon: const Icon(
                    //             Icons.check,
                    //           ),
                    //           splashRadius: 20,
                    //           color: Colors.red,
                    //           onPressed: () {
                    //           //  providerTodo.addTask(todo.text);
                    //             todo.clear();
                    //           },
                    //         ),
                    //         label: const Text('Enter Task')),
                    //     controller: todo,
                    //     keyboardType: TextInputType.multiline,
                    //   ),
                    // ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("${firebase.currentUser!.email}")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(
                            strokeWidth: 2,
                          );
                        } else {
                          return ListView(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: snapshot.data!.docs.map((documets) {
                              return Consumer<TodoProvider>(
                                builder: (context, value, child) {
                                  return Card(
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            // An action can be bigger than the others.
                                            flex: 1,
                                            onPressed: (context) =>
                                                value.showEditDialog(
                                                    documets.id,
                                                    documets["TaskName"],
                                                    documets["Description"],

                                                    context),
                                            backgroundColor: Color(0xFF7BC043),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit',
                                          ),
                                          SlidableAction(
                                            onPressed: (context) => {
                                              value.showDeleteDialog(
                                                documets.id,
                                                context,
                                              )
                                            },
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        // leading: Container(
                                        //   width: 5,
                                        //   color: Colors.green,
                                        // ),
                                        // trailing: IconButton(
                                        //   onPressed: () =>
                                        //       value.showDeleteDialog(
                                        //     documets.id,
                                        //     context,
                                        //   ),
                                        //   icon: const Icon(
                                        //     Icons.delete_sweep_outlined,
                                        //     color: Colors.red,
                                        //   ),
                                        // ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // Text(
                                            //   documets["TaskName"],
                                            //   style:
                                            //       const TextStyle(fontSize: 15),
                                            // ),
                                            ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -4),
                                              leading: const Icon(
                                                Icons.task,
                                                size: 20,
                                              ),
                                              title: Transform.translate(
                                                offset: const Offset(-25, 0),
                                                child: Text(
                                                  documets["TaskName"],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),

                                            // Text(
                                            //   documets["Description"],
                                            //   style:
                                            //       const TextStyle(fontSize: 15),
                                            // ),
                                            ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -4),
                                              leading: const Icon(
                                                Icons.description_outlined,
                                                size: 20,
                                              ),
                                              title: Transform.translate(
                                                offset: const Offset(-25, 0),
                                                child: Text(
                                                  documets["Description"],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),

                                            ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -4),
                                              leading: const Icon(
                                                Icons.date_range,
                                                size: 20,
                                              ),
                                              title: Transform.translate(
                                                offset: const Offset(-25, 0),
                                                child: Text(
                                                  documets["Date"],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
            onPressed: () => providerTodo.showAddDialog(context),
          ),
        );
      },
    );
  }
}
