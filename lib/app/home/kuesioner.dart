// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';

import '../../api/DatabaseServices.dart';
import '../HalamanRumah/HalamanRumah.dart';
import '../Utils/style.dart';

class DataResponden extends StatefulWidget {
  const DataResponden({Key? key}) : super(key: key);

  @override
  _DataRespondenState createState() => _DataRespondenState();
}

class _DataRespondenState extends State<DataResponden> {
  TextEditingController nama = TextEditingController();
  TextEditingController noHP = TextEditingController();
  TextEditingController umurcontrol = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController agama = TextEditingController();
  TextEditingController pekerjaan = TextEditingController();
  TextEditingController suku = TextEditingController();
  TextEditingController keluhan = TextEditingController();
  TextEditingController jeniskelamin = TextEditingController();

  late bool switchnama = false;
  late bool switchgender = false;
  late bool switchumur = false;
  late bool switchnotelepon = false;
  late bool switchalamat = false;
  late bool switchnikah = false;
  late bool switchagama = false;
  late bool switchpekerjaan = false;
  late bool switchsuku = false;
  late bool switchkeluhan = false;
  late bool switchfoto = false;
  late bool consent = false;

  String? genderr;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference kuesioner = firestore.collection('kuesioner');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuesioner'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade900,
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Colors.teal.shade900)),
        child: Container(
            color: Colors.grey.shade50,
            child: Container(
                color: Colors.teal.shade900,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(24),
                      children: [
                        const Text(
                          'nama : ',
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: nama,
                          onChanged: (value) {
                            setState(() {
                              switchnama = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'Jenis Kelamin : ',
                          textAlign: TextAlign.left,
                        ),
                        GenderPickerWithImage(
                          showOtherGender: false,
                          verticalAlignedText: true,
                          equallyAligned: true,

                          selectedGenderTextStyle: const TextStyle(
                              color: Color(0xFF8b32a8),
                              fontWeight: FontWeight.bold),
                          unSelectedGenderTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          selectedGender: (genderr == 'Laki-Laki')
                              ? Gender.Male
                              : (genderr == 'Perempuan')
                                  ? Gender.Female
                                  : null,
                          onChanged: (Gender) async {
                            switchgender = true;

                            if (Gender?.index == 0) {
                              genderr = 'Laki-Laki';
                            } else {
                              genderr = 'Perempuan';
                            }
                            print(Gender?.index);
                          },
                          animationDuration: const Duration(milliseconds: 300),
                          isCircular: true,
                          maleText: 'Laki-Laki',
                          femaleText: 'Perempuan',
                          // default : true,
                          opacityOfGradient: 0.4,
                          padding: const EdgeInsets.all(3),
                          size: 120, //default : 40
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'Umur : ',
                          textAlign: TextAlign.left,
                        ),
                        TextFormField(
                          controller: umurcontrol,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              switchumur = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('Alamat'),
                        TextFormField(
                          controller: alamat,
                          keyboardType: TextInputType.streetAddress,
                          onChanged: (value) {
                            setState(() {
                              switchalamat = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('Keluhan'),
                        TextFormField(
                          controller: keluhan,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              switchkeluhan = true;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        (switchnama == true)
                            ? (switchumur = true)
                                ? (switchgender == true)
                                    ? (switchalamat == true)
                                        ? (switchkeluhan == true)
                                            ? StreamBuilder<DocumentSnapshot>(
                                                stream: kuesioner
                                                    .doc('kuesionerEUCS')
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    Map<String, dynamic> data =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>;

                                                    int orangke = data['orang'];

                                                    return ElevatedButton(
                                                      style:
                                                          untukKonsultasiButton,
                                                      child:
                                                          const Text('Lanjut'),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                          return Kuesioner(
                                                              orangke);
                                                        }));
                                                        DatabaseServices
                                                            .updatekuesioner(
                                                          orangke,
                                                        );
                                                        DatabaseServices
                                                            .updatejmlorangkuesioner();
                                                      },
                                                    );
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              )
                                            : Container()
                                        : Container()
                                    : Container()
                                : Container()
                            : Container()
                      ],
                    )))),
      ),
    );
  }
}

class Kuesioner extends StatefulWidget {
  const Kuesioner(this.orangke, {Key? key}) : super(key: key);
  final int orangke;
  @override
  _KuesionerState createState() => _KuesionerState();
}

class _KuesionerState extends State<Kuesioner> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference kuesioner = firestore.collection('kuesioner');
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Konsultasi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal.shade900,
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: Colors.teal.shade900)),
        child: Container(
            color: Colors.grey.shade50,
            child: Container(
                color: Colors.teal.shade900,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                    ),
                    child: ListView(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: kuesioner
                              .doc('kuesionerEUCS')
                              .collection('isikuesioner')
                              .snapshots(),
                          builder: (_, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                  children: snapshot.data.docs
                                      .map<Widget>((e) => QuestionCard(
                                            widget.orangke,
                                            e.data()['id'],
                                            e.data()['pertanyaan'],
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
                        const SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: kuesioner
                              .doc('kuesionerEUCS')
                              .collection('orang')
                              .doc((widget.orangke - 1).toString())
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              int skor = data['skor'];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                ),
                                child: ElevatedButton(
                                  style: untukKonsultasiButton,
                                  child: const Text('submit'),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return const HalamanRumah();
                                    }));
                                    if (skor <= 16) {
                                      DatabaseServices.updatestatusDSMQ(
                                          useremail!, 'Buruk');
                                    } else if ((skor > 16) && (skor < 32)) {
                                      DatabaseServices.updatestatusDSMQ(
                                          useremail!, 'Sedang');
                                    } else if (skor >= 32) {
                                      DatabaseServices.updatestatusDSMQ(
                                          useremail!, 'Baik');
                                    }
                                  },
                                ),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                      ],
                    )))),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  const QuestionCard(this.orangke, this.idpertanyaan, this.pertanyaan,
      {Key? key})
      : super(key: key);

  final int orangke;

  final String idpertanyaan;
  final String pertanyaan;

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int id = 0;
  bool kirim = true;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: Colors.teal.shade900)),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.pertanyaan,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Tidak Pernah',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Selalu',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Radio(
                            activeColor: Colors.teal.shade900,
                            value: 0,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                DatabaseServices.updateminskorkuesioner(
                                    widget.orangke, id);
                                id = 0;

                                DatabaseServices.updateskorkuesioner(
                                    widget.orangke, id);
                              });
                            },
                          ),
                          const Text('0'),
                        ],
                      ),
                      Column(
                        children: [
                          Radio(
                            activeColor: Colors.teal.shade900,
                            value: 1,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                DatabaseServices.updateminskorkuesioner(
                                    widget.orangke, id);
                                id = 1;

                                DatabaseServices.updateskorkuesioner(
                                    widget.orangke, id);
                              });
                            },
                          ),
                          const Text('1'),
                        ],
                      ),
                      Column(
                        children: [
                          Radio(
                            activeColor: Colors.teal.shade900,
                            value: 2,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                DatabaseServices.updateminskorkuesioner(
                                    widget.orangke, id);
                                id = 2;

                                DatabaseServices.updateskorkuesioner(
                                    widget.orangke, id);
                              });
                            },
                          ),
                          const Text('2'),
                        ],
                      ),
                      Column(
                        children: [
                          Radio(
                            activeColor: Colors.teal.shade900,
                            value: 3,
                            groupValue: id,
                            onChanged: (val) {
                              setState(() {
                                DatabaseServices.updateminskorkuesioner(
                                    widget.orangke, id);
                                id = 3;
                                DatabaseServices.updateskorkuesioner(
                                    widget.orangke, id);
                              });
                            },
                          ),
                          const Text('3'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
