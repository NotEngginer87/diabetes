// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/api/DatabaseServices.dart';
import 'package:diabetes/app/Utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');

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
                      StreamBuilder<DocumentSnapshot>(
                        stream: userdata.doc(useremail).snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            String? statusDSMQ = data['statusDSMQ'];

                            if (statusDSMQ == null) {
                              return const Text(
                                'Isi Data Status DSMQ Pertamamu !!!',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.left,
                              );
                            } else {
                              return const Text(
                                'Sudah 2 bulan tidak mengisi DSMQ, ayo isi status DSMQ mu !',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.left,
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: userdata.doc(useremail).snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;

                                int dsmqcek = data['DSMQcek'];

                                return ElevatedButton(
                                  style: untukKonsultasiButtonBlueDiabeto,
                                  child: const Text('Jawab Survey DSMQ'),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Kuesioner(dsmqcek);
                                    }));
                                    DatabaseServices.updatekuesioner(
                                        useremail!, dsmqcek);
                                    DatabaseServices.updatejmlorangkuesioner(
                                        useremail);
                                    DatabaseServices.updatewaktukuesioner(
                                        useremail,
                                        dsmqcek,
                                        DateTime.now().day,
                                        DateTime.now().month,
                                        DateTime.now().year);
                                    DatabaseServices.uploadfaktorresikosetfalse(
                                        useremail);
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
