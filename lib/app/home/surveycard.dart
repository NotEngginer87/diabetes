// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../api/ColorsApi.dart';


class surveycard extends StatefulWidget {
  const surveycard(this.id, this.judul, this.deskripsisurvey, this.halaman,
      {Key? key})
      : super(key: key);

  final String id;
  final String judul;
  final String deskripsisurvey;
  final int halaman;

  @override
  State<surveycard> createState() => _surveycardState();
}

class _surveycardState extends State<surveycard> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference listsurvey = firestore.collection('ListSurvey');

    final ButtonStyle Buttonstyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: IsiQueColors.isiqueblue.shade400,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.w900),
      minimumSize: const Size(96, 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
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
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.judul,
                          style: const TextStyle(fontSize: 18,color: Colors.white),
                          textAlign: TextAlign.left,

                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: listsurvey.doc(widget.id).snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              int setthn, setbln, settgl, setjam, setmnt;
                              setthn = data['setthn'];
                              setbln = data['setbln'];
                              settgl = data['settgl'];
                              setjam = data['setjam'];
                              setmnt = data['setmnt'];
                              int nowthn, nowbln, nowtgl, nowjam, nowmnt;
                              nowthn = DateTime.now().year;
                              nowbln = DateTime.now().month;
                              nowtgl = DateTime.now().day;
                              nowjam = DateTime.now().hour;
                              nowmnt = DateTime.now().minute;

                              num countdate = getdate(
                                setthn,
                                setbln,
                                settgl,
                                nowthn,
                                nowbln,
                                nowtgl,
                              );

                              int counthour = setjam - nowjam;
                              int countminute = setmnt - nowmnt;

                              return Row(
                                children: [
                                  Text('Berakhir dalam $countdate hari ',style: const TextStyle(color: Colors.white),),
                                  Text('$counthour jam ',style: const TextStyle(color: Colors.white),),
                                  Text('$countminute menit ',style: const TextStyle(color: Colors.white),),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: Buttonstyle,

                              onPressed: () {}, child: const Text('Jawab Survey')),
                        )
                      ],
                    ),
                  )))),
    );
  }
}

int countleapyear(int y, m) {
  int years = y;
  if (m <= 2) years--;
  return (years / 4 - years / 100 + years / 400).floor();
}

num getdate(int y1, m1, d1, y2, m2, d2) {
  List<int> monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  num n1, n2;

  n1 = (365 * y1) + d1;
  for (int i = 1; i < m1 - 1; i++) {
    n1 += monthdays[i];
  }
  n1 += countleapyear(y1, m1);

  n2 = y2 * 365 + d2;
  for (int i = 1; i < m2 - 1; i++) {
    n2 += monthdays[i];
  }
  n2 += countleapyear(y2, m2);

  return (n1 - n2);
}