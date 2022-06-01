// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/api/DatabaseServices.dart';
import 'package:diabetes/app/HalamanRumah/HalamanRumah.dart';
import 'package:diabetes/app/Utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../Algorithm/statusdiabetes.dart';
import '../../api/ColorsApi.dart';

class SDCard extends StatefulWidget {
  const SDCard({Key? key}) : super(key: key);

  @override
  State<SDCard> createState() => _SDCardState();
}

class _SDCardState extends State<SDCard> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user?.email;


    return Card(
        clipBehavior: Clip.antiAlias,
        color: IsiQueColors.isiqueblue.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cari tahu kamu diabetes atau engga',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'ga lama kok, paling lama cuma 5 menit',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: untukKonsultasiButtonBlueDiabeto,
                            child: const Text('ikuti survey'),
                            onPressed: () {
                              DatabaseServices
                                  .updatestatusDiabetesbanyakukurstatus(
                                      useremail!);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SurveyStatusDiabetes()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}

class SurveyStatusDiabetes extends StatefulWidget {
  const SurveyStatusDiabetes({Key? key}) : super(key: key);

  @override
  State<SurveyStatusDiabetes> createState() => _SurveyStatusDiabetesState();
}

class _SurveyStatusDiabetesState extends State<SurveyStatusDiabetes> {
  bool Poliuri = false;
  bool Polidipsi = false;
  bool Polifagi = false;
  TextEditingController GDP = TextEditingController();
  TextEditingController GDS = TextEditingController();
  TextEditingController TTGO = TextEditingController();
  late int banyakukurstatusdiabetesglobal;
  late int gejalaklasik;
  late int countgdp, countgds, countttgo;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');
    CollectionReference statusdiabetes = firestore.collection('StatusDiabetes');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user!.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek DIabetes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: IsiQueColors.isiqueblue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: userdata.doc(useremail.toString()).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  int banyakukurstatusdiabetes =
                      data['banyakukurstatusdiabetes'];

                  countgdp = data['countgdp'];
                  countgds = data['countgds'];
                  countttgo = data['countttgo'];

                  banyakukurstatusdiabetesglobal = banyakukurstatusdiabetes;

                  return StreamBuilder<DocumentSnapshot>(
                    stream: statusdiabetes.doc('statusDiabetes').snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        String textgdp = data['GDP'];
                        String textgds = data['GDS'];
                        String textttgo = data['TTGO'];
                        String textpoliuri = data['Poliuri'];
                        String textpolidipsi = data['Polidipsi'];
                        String textpolifagi = data['Polifagi'];

                        return Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(labelText: textgdp),
                              controller: GDP,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: textgds),
                              controller: GDS,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: textttgo),
                              controller: TTGO,
                              keyboardType: TextInputType.number,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(textpoliuri),
                                Checkbox(
                                  value: Poliuri,
                                  onChanged: (value) {
                                    setState(() {
                                      Poliuri = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(textpolidipsi),
                                Checkbox(
                                  value: Polidipsi,
                                  onChanged: (value) {
                                    setState(() {
                                      Polidipsi = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(textpolifagi),
                                Checkbox(
                                  value: Polifagi,
                                  onChanged: (value) {
                                    setState(() {
                                      Polifagi = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            ElevatedButton(
                style: untukKonsultasiButtonBlueDiabetoinverted,
                onPressed: () {
                  DatabaseServices.updatestatusDiabetes(
                      useremail!,
                      banyakukurstatusdiabetesglobal,
                      int.tryParse(GDP.text)!,
                      int.tryParse(GDS.text)!,
                      int.tryParse(TTGO.text)!,
                      Poliuri,
                      Polidipsi,
                      Polifagi,
                      statusDiabetes(
                          useremail,
                          Poliuri,
                          Polidipsi,
                          Polifagi,
                          int.tryParse(GDP.text)!,
                          int.tryParse(GDS.text)!,
                          int.tryParse(TTGO.text)!,
                          countgdp,
                          countgds,
                          countttgo));
                  DatabaseServices.updatestatusDiabetesname(
                      useremail,
                      statusDiabetes(
                          useremail,
                          Poliuri,
                          Polidipsi,
                          Polifagi,
                          int.tryParse(GDP.text)!,
                          int.tryParse(GDS.text)!,
                          int.tryParse(TTGO.text)!,
                          countgdp,
                          countgds,
                          countttgo));

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HalamanRumah()));
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
