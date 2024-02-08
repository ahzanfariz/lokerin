import 'package:flutter/material.dart';
import 'package:sqflite_crud_flutter/employee.dart';
import 'package:sqflite_crud_flutter/model.dart';
import 'package:sqflite_crud_flutter/my_database.dart';
import 'package:sqflite_crud_flutter/service.dart';
import 'package:sqflite_crud_flutter/show_qr_transfer.dart';

import 'home.dart';

class EditEmployee extends StatefulWidget {
  const EditEmployee({super.key, required this.employee});
  final LokerData employee;

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  //
  bool isFemale = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final LokerService lokerService =
      LokerService(baseUrl: 'http://192.168.197.46/uas_pm');
  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //
    idController.text = widget.employee.venue;
    nameController.text = widget.employee.name;
    designationController.text = widget.employee.category;
    isFemale = widget.employee.description == "Cash" ? false : true;
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
                  // Emp Id
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
                  // Emp Name
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
                  // Emp Designation
                  TextFormField(
                    controller: designationController,
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
                              fontWeight: isFemale
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: isFemale ? Colors.grey : Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.handshake,
                            color: isFemale ? Colors.grey : Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Switch(
                          value: isFemale,
                          onChanged: (newValue) {
                            //
                            setState(() {
                              isFemale = newValue;
                            });
                            //
                          }),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Text(
                            'Transfer',
                            style: TextStyle(
                              fontWeight: isFemale
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isFemale ? Colors.pink : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.credit_card_outlined,
                            color: isFemale ? Colors.pink : Colors.grey,
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
      idEvent: 0,
      name: nameController.text,
      category: designationController.text,
      dateTime: "",
      description: isFemale ? "Transfer" : "Cash",
      price: isFemale ? 0 : widget.employee.price,
      venue: idController.text,
    );

    lokerService.updateLoker(widget.employee.idEvent, lokerData).then((_) {
      if (isFemale) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowQRtransfer(lokerData),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
                'Loker ${lokerData.name} #${lokerData.venue} berhasil diperbarui.')));
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
