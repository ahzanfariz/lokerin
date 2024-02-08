import 'package:flutter/material.dart';
import 'package:sqflite_crud_flutter/model.dart';
import 'package:sqflite_crud_flutter/my_database.dart';
import 'package:sqflite_crud_flutter/add_employee.dart';
import 'package:sqflite_crud_flutter/edit_employee.dart';
import 'package:sqflite_crud_flutter/employee.dart';
import 'package:sqflite_crud_flutter/service.dart';
import 'package:sqflite_crud_flutter/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  // bool isLoading = false;
  // List<Employee> employees = List.empty(growable: true);
  // final MyDatabase _myDatabase = MyDatabase();
  // int count = 0;
  //
  late Future<List<LokerData>> lokerListener;
  final LokerService lokerService =
      LokerService(baseUrl: 'http://192.168.197.46/uas_pm');
  final TextEditingController _cariController = TextEditingController();

  var _isSearch = false;
  // List<dynamic> galleryEvents = [
  //   {
  //     'name': "Konser Dewa 19",
  //     "photo":
  //         'https://ecs7.tokopedia.net/blog-tokopedia-com/uploads/2017/12/Blog_Acara-Konser-Musik-Tahunan-di-Indonesia-buat-Pecinta-Musik.jpg'
  //   },
  //   {
  //     'name': "Coldplay",
  //     "photo":
  //         'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/01/2023/11/07/Untitled-design-2023-11-07T132711552-661464454.png'
  //   }
  // ];

  @override
  void initState() {
    super.initState();

    lokerListener = lokerService.fetchLoker();
  }

  // getData from firebase
  // getDataFromDb() async {
  //   //
  //   await _myDatabase.initializeDatabase();
  //   List<Map<String, Object?>> map = await _myDatabase.getEmpList();
  //   for (int i = 0; i < map.length; i++) {
  //     //
  //     employees.add(Employee.toEmp(map[i]));
  //     //
  //   }
  //   count = await _myDatabase.countEmp();
  //   setState(() {
  //     isLoading = false;
  //   });
  //   //
  // }

  // @override
  // void initState() {
  //   // employees.add(Employee(
  //   //     empId: 11, empName: 'abc', empDesignation: 'xyz', isMale: true));
  //   // employees.add(Employee(
  //   //     empId: 11, empName: 'xyas', empDesignation: 'ere', isMale: false));
  //   getDataFromDb();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Image.asset('assets/LokerIn.png', height: 30),
        //  const Text(
        //   'LokerIn',
        //   style:
        //       TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.subject,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            // onTap: () {},
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body:
          // isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : employees.isEmpty
          //         ? const Center(
          //             child: Text('No Employee yet'),
          //           )
          //         :
          FutureBuilder<List<LokerData>>(
              future: lokerListener,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<LokerData> lokerList = snapshot.data!;
                  return lokerList.isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 100,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Text("Loker tidak ditemukan.")
                          ],
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          itemCount: lokerList.length,
                          itemBuilder: (context, index) {
                            lokerList
                                .sort((a, b) => b.idEvent.compareTo(a.idEvent));
                            LokerData loker = lokerList[index];
                            return Dismissible(
                                // Specify the direction to swipe and delete
                                direction: DismissDirection.endToStart,
                                key: Key(loker.venue),
                                onDismissed: (direction) {
                                  lokerService
                                      .deleteLoker(loker.idEvent)
                                      .then((_) {
                                    // setState(() {
                                    //   eventListener = eventService.fetchEvents();
                                    // });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Loker ${loker.name} #${loker.venue} dihapus.')));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                        (route) => false);
                                  });
                                },
                                background: Container(color: Colors.red),
                                child: Card(
                                  child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEmployee(
                                                employee: loker,
                                              ),
                                            ));
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            loker.description == "Transfer"
                                                ? Colors.pink
                                                : Colors.blue,
                                        child: Icon(
                                          loker.description == "Transfer"
                                              ? Icons.credit_card
                                              : Icons.handshake,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        '${loker.name} #${loker.venue}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle:
                                          Text("No. Loker: ${loker.category}"),
                                      trailing:
                                          // lokerService
                                          //     .deleteLoker(loker.idEvent)
                                          //     .then((_) {
                                          //   // setState(() {
                                          //   //   eventListener = eventService.fetchEvents();
                                          //   // });
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(SnackBar(
                                          //           backgroundColor: Colors.red,
                                          //           content: Text(
                                          //               '${loker.name} deleted.')));
                                          //   Navigator.pushAndRemoveUntil(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const HomePage(),
                                          //       ),
                                          //       (route) => false);
                                          // });
                                          //
                                          // String empName = employees[index].empName;
                                          // await _myDatabase
                                          //     .deleteEmp(employees[index]);
                                          // if (mounted) {
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(SnackBar(
                                          //           backgroundColor: Colors.red,
                                          //           content:
                                          //               Text('$empName deleted.')));
                                          //   Navigator.pushAndRemoveUntil(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const HomePage(),
                                          //       ),
                                          //       (route) => false);
                                          // }
                                          //
                                          GestureDetector(
                                              onTap: () {
                                                print("tapped..");
                                                _showPicker(context, loker);
                                              },
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                        child: Icon(
                                                      loker.price == 0
                                                          ? Icons.pending
                                                          : loker.price == 1
                                                              ? Icons.check
                                                              : Icons.close,
                                                      color: loker.price == 0
                                                          ? Colors.orange
                                                          : loker.price == 1
                                                              ? Colors
                                                                  .greenAccent
                                                              : Colors.red,
                                                      size: 27,
                                                    )),
                                                    TextSpan(
                                                        text: loker.price == 0
                                                            ? 'PENDING'
                                                            : loker.price == 1
                                                                ? 'SUCCESS'
                                                                : 'CANCEL',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: loker.price ==
                                                                    0
                                                                ? Colors.orange
                                                                : loker.price ==
                                                                        1
                                                                    ? Colors
                                                                        .greenAccent
                                                                    : Colors
                                                                        .red)),
                                                  ],
                                                ),
                                              ))),
                                ));
                          });
                }
              }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: StyleApp.primary,
          onPressed: () {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEmployee(),
                ));
            //
          }),
    );
  }

  void _showPicker(context, LokerData loker) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Text(
                                  'Ganti status Sewa Loker ${loker.name} #${loker.venue}',
                                  style: TextStyle(
                                      // color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                        ]),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        //
                        LokerData lokerData = LokerData(
                          idEvent: 0,
                          name: loker.name,
                          category: loker.category,
                          dateTime: "",
                          description: loker.description,
                          price: 2,
                          venue: loker.venue,
                        );

                        lokerService
                            .updateLoker(loker.idEvent, lokerData)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Status Sewa Loker ${lokerData.name} #${loker.venue} dibatalkan.')));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dibatalkan",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              Icon(Icons.close, color: Colors.white)
                            ],
                          ))),
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        //
                        LokerData lokerData = LokerData(
                          idEvent: 0,
                          name: loker.name,
                          category: loker.category,
                          dateTime: "",
                          description: loker.description,
                          price: 1,
                          venue: loker.venue,
                        );

                        lokerService
                            .updateLoker(loker.idEvent, lokerData)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent,
                              content: Text(
                                'Status Sewa Loker ${lokerData.name} #${loker.venue} berhasil.',
                                style: TextStyle(color: Colors.black),
                              )));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false);
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Berhasil",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Icon(Icons.check)
                            ],
                          ))),
                ],
              ),
            ),
          );
        });
  }
}
