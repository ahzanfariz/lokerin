import 'package:flutter/material.dart';

import './home.dart';
import './model.dart';
import './style.dart';

class ShowQRtransfer extends StatefulWidget {
  LokerData lokerData;
  ShowQRtransfer(this.lokerData);
  //
  @override
  State<ShowQRtransfer> createState() => _ShowQRtransferState();
}

class _ShowQRtransferState extends State<ShowQRtransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Transform.scale(
            scale: 1.2,
            child: FloatingActionButton.extended(
                backgroundColor: StyleApp.primary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.greenAccent,
                      content: Text(
                        'Silakan lakukan konfirmasi Sewa Loker ${widget.lokerData.nama} #${widget.lokerData.idLoker}.',
                        style: TextStyle(color: Colors.black),
                      )));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false);
                },
                label: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Text(
                    "Selesai",
                    style: TextStyle(
                        // color: ConstColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ))),
        appBar: AppBar(
          // backgroundColor: Colors.indigo,
          centerTitle: true,
          title: const Text(
            'Pembayaran Biaya Loker',
            style: TextStyle(
                fontSize: 17, color: Colors.white, letterSpacing: 0.53),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text(
                    'Silakan lakukan konfirmasi Sewa Loker ${widget.lokerData.nama} #${widget.lokerData.idLoker}.',
                    style: TextStyle(color: Colors.black),
                  )));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [],
        ),
        body: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Text(
                    'Silakan lakukan konfirmasi Sewa Loker ${widget.lokerData.nama} #${widget.lokerData.idLoker}.',
                    style: TextStyle(color: Colors.black),
                  )));
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
              return false;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Lakukan scan QRIS dibawah ini",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/qr.jpg',
                    fit: BoxFit.contain,
                  )
                ],
              ),
            )));
  }
}
