import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/api/DatabaseServices.dart';
import 'package:diabetes/app/Utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/ColorsApi.dart';
import 'kuesioner.dart';

class DSMQCard extends StatefulWidget {
  const DSMQCard({Key? key}) : super(key: key);

  @override
  State<DSMQCard> createState() => _DSMQCardState();
}

class _DSMQCardState extends State<DSMQCard> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user?.email;

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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference kuesioner = firestore.collection('kuesioner');
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Isi Data Status DSMQ Pertamamu !!!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: kuesioner.doc('kuesionerEUCS').snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;

                                int orangke = data['orang'];

                                return ElevatedButton(
                                  style: untukKonsultasiButton,
                                  child: const Text('Jawab Survey DSMQ'),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Kuesioner(orangke);
                                    }));
                                    DatabaseServices.updatekuesioner(orangke);
                                    DatabaseServices.updatejmlorangkuesioner();
                                    DatabaseServices.updatewaktukuesioner(
                                        orangke,
                                        DateTime.now().day,
                                        DateTime.now().month,
                                        DateTime.now().year);
                                    DatabaseServices.uploadfaktorresikosetfalse(
                                        useremail!);
                                  },
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ))));
  }
}

class SurveyDSMQ extends StatefulWidget {
  const SurveyDSMQ({Key? key}) : super(key: key);

  @override
  State<SurveyDSMQ> createState() => _SurveyDSMQState();
}

class _SurveyDSMQState extends State<SurveyDSMQ> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final emaila = user!.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DIABETO'),
        centerTitle: true,
        titleTextStyle: GoogleFonts.pathwayGothicOne(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
        backgroundColor: IsiQueColors.isiqueblue.shade400,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Container(),
      ),
    );
  }
}
