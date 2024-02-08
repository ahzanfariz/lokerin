import 'package:flutter/material.dart';

import './model.dart';
import './add_loker.dart';
import './edit_loker.dart';
import './service.dart';
import './style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<LokerData>> lokerListener;
  final LokerService lokerService =
      LokerService(baseUrl: 'http://192.168.197.46/lokerin');

  @override
  void initState() {
    super.initState();

    lokerListener = lokerService.fetchLoker();
  }

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
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<LokerData>>(
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
                          Icons.subject,
                          size: 200,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Data Loker tidak ditemukan.",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: lokerList.length,
                      itemBuilder: (context, index) {
                        lokerList.sort((a, b) => b.id.compareTo(a.id));
                        LokerData loker = lokerList[index];
                        return Dismissible(
                            // Specify the direction to swipe and delete
                            direction: DismissDirection.endToStart,
                            key: Key(loker.id.toString()),
                            onDismissed: (direction) {
                              lokerService.deleteLoker(loker.id).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        'Loker ${loker.nama} #${loker.idLoker} dihapus.')));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
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
                                              EditLoker(loker: loker),
                                        ));
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        loker.metodePembayaran == "Transfer"
                                            ? Colors.pink
                                            : Colors.blue,
                                    child: Icon(
                                      loker.metodePembayaran == "Transfer"
                                          ? Icons.credit_card
                                          : Icons.handshake,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    '${loker.nama} #${loker.idLoker}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("No. Loker: ${loker.noLoker}"),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        print("tapped..");
                                        _showPicker(context, loker);
                                      },
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            WidgetSpan(
                                                child: Icon(
                                              loker.status == 0
                                                  ? Icons.pending
                                                  : loker.status == 1
                                                      ? Icons.check
                                                      : Icons.close,
                                              color: loker.status == 0
                                                  ? Colors.orange
                                                  : loker.status == 1
                                                      ? Colors.greenAccent
                                                      : Colors.red,
                                              size: 27,
                                            )),
                                            TextSpan(
                                                text: loker.status == 0
                                                    ? 'PENDING'
                                                    : loker.status == 1
                                                        ? 'SUCCESS'
                                                        : 'CANCEL',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: loker.status == 0
                                                        ? Colors.orange
                                                        : loker.status == 1
                                                            ? Colors.greenAccent
                                                            : Colors.red)),
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
                  builder: (context) => AddLoker(),
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
                                  'Ganti status Sewa Loker ${loker.nama} #${loker.idLoker}',
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
                          id: 0,
                          nama: loker.nama,
                          noLoker: loker.noLoker,
                          tanggal: "",
                          metodePembayaran: loker.metodePembayaran,
                          status: 2,
                          idLoker: loker.idLoker,
                        );

                        lokerService.updateLoker(loker.id, lokerData).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Status Sewa Loker ${lokerData.nama} #${loker.idLoker} dibatalkan.')));
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
                          id: 0,
                          nama: loker.nama,
                          noLoker: loker.noLoker,
                          tanggal: "",
                          metodePembayaran: loker.metodePembayaran,
                          status: 1,
                          idLoker: loker.idLoker,
                        );

                        lokerService.updateLoker(loker.id, lokerData).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent,
                              content: Text(
                                'Status Sewa Loker ${lokerData.nama} #${loker.idLoker} berhasil.',
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
