import 'package:flutter/material.dart';

import './model.dart';
import './service.dart';
import './show_qr_transfer.dart';
import './home.dart';

class EditLoker extends StatefulWidget {
  final LokerData loker;
  const EditLoker({super.key, required this.loker});

  @override
  State<EditLoker> createState() => _EditLokerState();
}

class _EditLokerState extends State<EditLoker> {
  //
  bool isTransfer = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noLokerController = TextEditingController();
  final LokerService lokerService =
      LokerService(baseUrl: 'http://192.168.197.46/lokerin');
  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    idController.text = widget.loker.idLoker;
    nameController.text = widget.loker.nama;
    noLokerController.text = widget.loker.noLoker;
    isTransfer = widget.loker.metodePembayaran == "Cash" ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Edit Loker',
            style: TextStyle(
                fontSize: 17, color: Colors.white, letterSpacing: 0.53),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: InkWell(
            onTap: () {},
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: idController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Loker Id',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Loker Id tidak boleh kosong";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Nama Pemilik',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Nama Pemilik tidak boleh kosong";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: noLokerController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Nomor Loker',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Nomor Loker tidak boleh kosong";
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(width: 5),
                      Text(
                        "Pembayaran",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontWeight: isTransfer
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: isTransfer ? Colors.grey : Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.handshake,
                            color: isTransfer ? Colors.grey : Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Switch(
                          value: isTransfer,
                          onChanged: (newValue) {
                            //
                            setState(() {
                              isTransfer = newValue;
                            });
                            //
                          }),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            'Transfer',
                            style: TextStyle(
                              fontWeight: isTransfer
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isTransfer ? Colors.pink : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.credit_card_outlined,
                            color: isTransfer ? Colors.pink : Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  //
                  const SizedBox(height: 40),
                  //
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          checkForm();
                        },
                        child: const Text(
                          'PERBARUI',
                          style: TextStyle(fontSize: 16),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future checkForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();

    LokerData lokerData = LokerData(
      id: 0,
      nama: nameController.text,
      noLoker: noLokerController.text,
      tanggal: "",
      metodePembayaran: isTransfer ? "Transfer" : "Cash",
      status: isTransfer ? 0 : widget.loker.status,
      idLoker: idController.text,
    );

    lokerService.updateLoker(widget.loker.id, lokerData).then((_) {
      if (isTransfer) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowQRtransfer(lokerData),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
                'Loker ${lokerData.nama} #${lokerData.idLoker} berhasil diperbarui.')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      }
    });
  }
}
