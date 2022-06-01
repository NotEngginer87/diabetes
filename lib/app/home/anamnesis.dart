// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_types_as_parameter_names, deprecated_member_use, unnecessary_null_comparison, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:diabetes/api/DatabaseServices.dart';
import 'package:diabetes/app/HalamanRumah/HalamanRumah.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart';

import '../../api/ColorsApi.dart';

class Anamnesis extends StatefulWidget {
  const Anamnesis({Key? key}) : super(key: key);

  @override
  State<Anamnesis> createState() => _AnamnesisState();
}

class _AnamnesisState extends State<Anamnesis> {
  int currentstep = 0;

  TextEditingController nama = TextEditingController();
  TextEditingController noHP = TextEditingController();
  TextEditingController umurcontrol = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController agama = TextEditingController();
  TextEditingController pekerjaan = TextEditingController();
  TextEditingController beratbadan = TextEditingController();
  TextEditingController tinggibadan = TextEditingController();
  TextEditingController keluhan = TextEditingController();
  TextEditingController jeniskelamin = TextEditingController();

  late bool switchcekglukosa = false;
  late bool switchtinggibadan = false;
  late bool switchberatbadan = false;

  late bool switchkeluhan = false;
  late bool switchfoto = false;
  late bool consent = false;

  String? tanggal, bulan, tahun;
  String? gender;

  String? genderr;

  int? umur;
  int? tanggalawal = 0, bulanawal = 0, tahunawal = 0;

  String? _valuecekglukosa = 'pilih';

  bool isLastStep3 = false;

  late int tanggalcek, bulancek, tahuncek;

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              'upload : $percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return const SizedBox(
              width: 0,
              height: 0,
            );
          }
        },
      );

  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference faktorresiko =
        firestore.collection('faktorresikodiabetes');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user!.email;

    List<Step> getSteps() => [
          Step(
              state: currentstep > 0 ? StepState.complete : StepState.indexed,
              isActive: currentstep >= 0,
              title: const Text('Informasi Tubuh'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Berat Badan : ',
                    textAlign: TextAlign.left,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      suffixText: 'kentang',
                    ),
                    controller: beratbadan,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        switchberatbadan = true;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Tinggi Badan : ',
                    textAlign: TextAlign.left,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      suffixText: 'cm',
                    ),
                    controller: tinggibadan,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        switchtinggibadan = true;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Pernah cek glukosa ? : ',
                    textAlign: TextAlign.left,
                  ),
                  DropdownButton(
                      value: _valuecekglukosa,
                      elevation: 10,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: 'pilih',
                          child: Text("Pilih"),
                        ),
                        DropdownMenuItem(
                          value: 'Belum',
                          child: Text("Belum"),
                        ),
                        DropdownMenuItem(
                          value: 'Sudah',
                          child: Text("Sudah"),
                        ),
                      ],
                      onChanged: (dynamic value) {
                        setState(() {
                          _valuecekglukosa = value;
                          switchcekglukosa = true;
                        });
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  (_valuecekglukosa == 'Sudah')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'kapan terakhir cek ? ',
                              textAlign: TextAlign.left,
                            ),
                            DateTimePicker(
                              type: DateTimePickerType.date,
                              dateMask: 'dd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              icon: const Icon(Icons.event),
                              dateLabelText: 'Date',
                              selectableDayPredicate: (date) {
                                // Disable weekend days to select from the calendar

                                tanggal = date.day.toString();
                                bulan = date.month.toString();
                                tahun = date.year.toString();
                                tanggalcek = date.day;
                                bulancek = date.month;
                                tahuncek = date.year;
                                return true;
                              },
                              onChanged: (val) => print(val),
                              validator: (val) {
                                print(val);

                                return null;
                              },
                              onSaved: (val) => print(val),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
              subtitle: const Text('Isilah informasi berikut dengan jujur')),
          Step(
            state: currentstep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentstep >= 1,
            title: const Text('Faktor Resiko'),
            content: Column(
              children: <Widget>[
                const Text(
                  'Faktor Resiko : ',
                  textAlign: TextAlign.left,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: faktorresiko.snapshots(),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.docs
                              .map<Widget>((e) => CheckBoxFaktorResiko(
                                    useremail!,
                                    e.data()['id'],
                                    e.data()['resiko'],
                                  ))
                              .toList());
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Center(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anamnesis'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: IsiQueColors.isiqueblue.shade400,
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: IsiQueColors.isiqueblue.shade400,
        )),
        child: Stepper(
            type: StepperType.vertical,
            currentStep: currentstep,
            steps: getSteps(),
            onStepContinue: () {
              setState(() {
                currentstep += 1;
              });
            },
            onStepTapped: (step) => setState(() {
                  currentstep = step;
                }),
            onStepCancel: currentstep == 0
                ? null
                : () {
                    setState(() {
                      currentstep -= 1;
                    });
                  },
            controlsBuilder: (context, details) {
              final isLastStep = currentstep == getSteps().length - 1;
              return Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    if (currentstep != 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('balik'),
                        ),
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    (isLastStep == true)
                        ? Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                DatabaseServices.updateanamnesis(
                                    useremail!,
                                    int.tryParse(beratbadan.text)!,
                                    int.tryParse(tinggibadan.text),
                                    tanggalcek,
                                    bulancek,
                                    tahuncek);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HalamanRumah()),
                                );
                              },
                              child: const Text('Konfirmasi'),
                            ),
                          )
                        : Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: const Text('lanjut'),
                            ),
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  uploadImage() async {
    final storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    PickedFile? image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await picker.getImage(source: ImageSource.gallery);

      var file = File(image!.path);

      final fileName = basename(file.path);
      final destination = 'userprofile/$fileName';

      if (image != null) {
        //Upload to Firebase
        var snapshot = await storage
            .ref()
            .child(destination)
            .putFile(file)
            .whenComplete(() => null);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}

class CheckBoxFaktorResiko extends StatefulWidget {
  const CheckBoxFaktorResiko(this.useremail, this.id, this.resiko, {Key? key})
      : super(key: key);
  final String useremail;
  final String id;
  final String resiko;
  @override
  State<CheckBoxFaktorResiko> createState() => _CheckBoxFaktorResikoState();
}

class _CheckBoxFaktorResikoState extends State<CheckBoxFaktorResiko> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.resiko),
        Checkbox(
          value: value,
          onChanged: (value) {
            setState(() {
              this.value = value!;
              DatabaseServices.uploadfaktorresiko(
                  widget.useremail, widget.id, value, widget.resiko);
            });
          },
        ),
      ],
    );
  }
}

int imt(int tinggi, berat) {
  return ((berat / tinggi) / tinggi);
}
