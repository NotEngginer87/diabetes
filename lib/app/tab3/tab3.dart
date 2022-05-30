// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../IsiDataAkun/isidata.dart';

class Tab3 extends StatefulWidget {
  const Tab3({Key? key}) : super(key: key);

  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final emaila = user!.email;

    return Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Akun',
                          style: GoogleFonts.pathwayGothicOne(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ],
                    ),

                    // ignore: deprecated_member_use
                    FlatButton(
                        textColor: Color(0xFF9A9483),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IsiData()),
                          );
                        },
                        child: Text('Edit')),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'email: ',
                        style: GoogleFonts.pathwayGothicOne(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      Text(
                        emaila.toString(),
                        style: GoogleFonts.pathwayGothicOne(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: userdata.doc(emaila.toString()).snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                      String username;
                      username = data['username'];
                      String noHP;
                      noHP = data['noHP'];

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 4, right: 4),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'username :  ',
                                  style: GoogleFonts.pathwayGothicOne(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                Text(
                                  username,
                                  style: GoogleFonts.pathwayGothicOne(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4, right: 4),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'nomor HP: ',
                                  style: GoogleFonts.pathwayGothicOne(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                Text(
                                  noHP,
                                  style: GoogleFonts.pathwayGothicOne(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          )
        ));
  }
}
