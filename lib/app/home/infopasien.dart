// ignore_for_file: camel_case_types, prefer_const_constructors, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/ColorsApi.dart';
import '../lihatprofil.dart';

class infopasien extends StatefulWidget {
  const infopasien({Key? key}) : super(key: key);

  @override
  _infopasienState createState() => _infopasienState();
}

class _infopasienState extends State<infopasien> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final emaila = user!.email;

    return Container(
      decoration: BoxDecoration(
        color: IsiQueColors.isiqueblue.shade400,
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: StreamBuilder<DocumentSnapshot>(
        stream: userdata.doc(emaila.toString()).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            String nama = data['nama'];
            String? imageUrl = data['imageurl'];
            String statusDiabetes = data['statusDiabetes'];
            String statusDSMQ = data['statusDSMQ'];

            return Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Status Diabetes :  ',
                              style: GoogleFonts.pathwayGothicOne(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Text(
                              statusDiabetes,
                              style: GoogleFonts.pathwayGothicOne(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                  color: (statusDiabetes == 'normal')
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              'Status DSMQ : ',
                              style: GoogleFonts.pathwayGothicOne(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            Text(
                              statusDSMQ,
                              style: GoogleFonts.pathwayGothicOne(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20,
                                  color: (statusDSMQ == 'Baik')
                                      ? Colors.green.shade600
                                      : (statusDSMQ == 'Sedang')
                                          ? Colors.yellow
                                          : (statusDSMQ == 'Buruk')
                                              ? Colors.red
                                              : Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
