import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/screens/add_todo.dart';
import 'package:todolist/screens/edit_todo.dart';

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

    final format = DateFormat("yyyy-MM-dd HH:mm");
    return StreamBuilder<User?>(
      stream: context.watch<AuthProvider>().stream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            right: 0,
                            top: 0,
                            child: Image.network(
                              'https://th.bing.com/th/id/R.c91a63af297014f621f585a86a6a3379?rik=TDqrepuma7DJ3w&riu=http%3a%2f%2fwallpapercave.com%2fwp%2f3qiJ1RH.jpg&ehk=Zptwb%2bSAoN7ON2rIDGNHSmbUnSb1NahvOeBJYitLCzA%3d&risl=&pid=ImgRaw&r=0',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.menu,
                                            color: Colors.white,
                                          ),
                                          const Text(
                                            'Your\nThings',
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            DateTime.now()
                                                .toString()
                                                .substring(0, 10),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                    height: 400,
                                    color: Colors.black.withOpacity(0.3),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        //shrinkWrap: true,

                                        children: [
                                          const SizedBox(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(children: [
                                                const Text(
                                                  '24',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                                Text('Personal',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.5))),
                                              ]),
                                              Column(children: [
                                                const Text(
                                                  '15',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                                Text('Business',
                                                    style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.5))),
                                              ]),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                      value: 0.6,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.grey))),
                                              //Icon(Icons.incomplete_circle,color: Colors.white.withOpacity(0.5),),
                                              Text('65 % Done',
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      fontSize: 15))
                                            ],
                                          )
                                          // ListTile(
                                          //   title: Transform.translate(offset:Offset(-15,0),child: Text('65 % Done',
                                          //       style: TextStyle(color: Colors.white.withOpacity(0.5)))) ,
                                          //     leading: Icon(Icons.done_all_outlined),
                                          //    ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 7,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
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
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Text(
                                          'INBOX',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        children:
                                            snapshot.data!.docs.map((documets) {
                                          return Consumer<TodoProvider>(
                                            builder: (context, value, child) {
                                              return Card(
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        // An action can be bigger than the others.
                                                        flex: 1,
                                                        onPressed: (context) =>
                                                            {
                                                          // value.updateTask(
                                                          //     documets.id,
                                                          //     documets[
                                                          //         "TaskName"],
                                                          //     documets[
                                                          //         "Description"],documets[
                                                          //         "Date"],documets["Type"],documets["Place"],'COMPLETED')

                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditTodo(
                                                                            id: documets.id,
                                                                            type:
                                                                                documets["Type"],
                                                                            place:
                                                                                documets["Place"],
                                                                            taskdesc:
                                                                                documets["Description"],
                                                                            task:
                                                                                documets["TaskName"],
                                                                            status:
                                                                                documets['Status'],
                                                                          )))
                                                        },

                                                        backgroundColor:
                                                            const Color(
                                                                0xFF7BC043),
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.edit,
                                                        label: 'Edit',
                                                      ),
                                                      SlidableAction(
                                                        onPressed: (context) =>
                                                            {
                                                          value
                                                              .showDeleteDialog(
                                                            documets.id,
                                                            context,
                                                          )
                                                        },
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.delete,
                                                        label: 'Delete',
                                                      ),
                                                    ],
                                                  ),
                                                  startActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        // An action can be bigger than the others.
                                                        flex: 1,
                                                        onPressed: (context) =>
                                                            {
                                                          value.updateTask(
                                                              documets.id,
                                                              documets[
                                                                  "TaskName"],
                                                              documets[
                                                                  "Description"],
                                                              documets["Date"],
                                                              documets['Type'],
                                                              documets['Place'],
                                                              'COMPLETED')
                                                        },
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF7BC043),
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.done,
                                                        label: 'Completed',
                                                      ),
                                                      SlidableAction(
                                                        // An action can be bigger than the others.
                                                        flex: 1,
                                                        onPressed: (context) =>
                                                            {
                                                          value.updateTask(
                                                              documets.id,
                                                              documets[
                                                                  "TaskName"],
                                                              documets[
                                                                  "Description"],
                                                              documets["Date"],
                                                              documets['Type'],
                                                              documets['Place'],
                                                              'FAILED')
                                                        },
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.close,
                                                        label: 'Failed',
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
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: documets[
                                                                              'Status'] ==
                                                                          'COMPLETED'
                                                                      ? Colors
                                                                          .green
                                                                      : documets['Status'] ==
                                                                              'FAILED'
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .grey,
                                                                  // border color
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: CircleAvatar(
                                                                    radius: 30,
                                                                    // foregroundColor: Colors.white,
                                                                    backgroundColor: Colors.white,
                                                                    child: icons(documets['Type'])))),
                                                        Expanded(
                                                          flex: 8,
                                                          child: ListTile(
                                                            // visualDensity:
                                                            //     const VisualDensity(
                                                            //         horizontal: 0,
                                                            //         vertical: -4),
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  documets[
                                                                      "TaskName"],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                const Text(
                                                                  '5 Pm',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Text(
                                                              documets["Date"]
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        // Column(
                                                        //   crossAxisAlignment:
                                                        //       CrossAxisAlignment.start,
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceAround,
                                                        //   children: [
                                                        //     // Text(
                                                        //     //   documets["TaskName"],
                                                        //     //   style:
                                                        //     //       const TextStyle(fontSize: 15),
                                                        //     // ),
                                                        //     ListTile(
                                                        //       visualDensity:
                                                        //           const VisualDensity(
                                                        //               horizontal: 0,
                                                        //               vertical: -4),
                                                        //       leading: const Icon(
                                                        //         Icons.task,
                                                        //         size: 20,
                                                        //       ),
                                                        //       title: Transform.translate(
                                                        //         offset:
                                                        //             const Offset(-25, 0),
                                                        //         child: Text(
                                                        //           documets["TaskName"],
                                                        //           style: const TextStyle(
                                                        //               fontSize: 15),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //     // const SizedBox(
                                                        //     //   height: 10,
                                                        //     // ),
                                                        //
                                                        //     // Text(
                                                        //     //   documets["Description"],
                                                        //     //   style:
                                                        //     //       const TextStyle(fontSize: 15),
                                                        //     // ),
                                                        //     ListTile(
                                                        //       visualDensity:
                                                        //           const VisualDensity(
                                                        //               horizontal: 0,
                                                        //               vertical: -4),
                                                        //       leading: const Icon(
                                                        //         Icons
                                                        //             .description_outlined,
                                                        //         size: 20,
                                                        //       ),
                                                        //       title: Transform.translate(
                                                        //         offset:
                                                        //             const Offset(-25, 0),
                                                        //         child: Text(
                                                        //           documets["Description"],
                                                        //           style: const TextStyle(
                                                        //               fontSize: 15),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //
                                                        //     ListTile(
                                                        //       visualDensity:
                                                        //           const VisualDensity(
                                                        //               horizontal: 0,
                                                        //               vertical: -4),
                                                        //       leading: const Icon(
                                                        //         Icons.date_range,
                                                        //         size: 20,
                                                        //       ),
                                                        //       title: Transform.translate(
                                                        //         offset:
                                                        //             const Offset(-25, 0),
                                                        //         child: Text(
                                                        //           documets["Date"],
                                                        //           style: const TextStyle(
                                                        //               fontSize: 15),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: ListTile(
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: const [
                    Text(
                      'COMPLETED',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 15,
                      child: Text('0'),
                    ),
                  ],
                ),
              ),
              trailing: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddTodo(),
                )),
                child: Transform.translate(
                  offset: const Offset(25, 0),
                  child: Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue, // border color
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                          radius: 30,
                          // foregroundColor: Colors.white,
                          //   backgroundColor: const Color(0xff46539E),
                          child: Icon(Icons.add))),
                ),
              ),
            ));
      },
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
