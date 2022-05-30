// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class puskesmas extends StatefulWidget {
  const puskesmas({Key? key}) : super(key: key);

  @override
  State<puskesmas> createState() => _puskesmasState();
}

class _puskesmasState extends State<puskesmas> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');
    CollectionReference puskesmas = firestore.collection('listpuskemas');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final emaila = user!.email;

    return StreamBuilder<DocumentSnapshot>(
      stream: userdata.doc(emaila.toString()).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String alamat = data['alamat'];

          return SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            width:  MediaQuery.of(context).size.width,
            child: ListView(

              children: [StreamBuilder<DocumentSnapshot>(
                stream: puskesmas.doc(alamat.toString()).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                    String id = data['id'];
                    String cp = data['cp'];
                    String image = data['image'];
                    String lokasi = data['lokasi'];
                    String nama = data['nama'];
                    String prolanis = data['prolanis'];

                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Image(
                              image: NetworkImage(image),
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama,
                                      style: GoogleFonts.pathwayGothicOne(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24,
                                        color: Colors.teal.shade900,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(LineIcons.mapMarker),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          lokasi,
                                          style: GoogleFonts.pathwayGothicOne(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.teal.shade900),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {

                                      launchWhatsApp(cp,
                                          'Halo Admin $nama saya ingin menanyakan sesuatu');
                                    },
                                    icon: Icon(
                                      LineIcons.whatSApp,
                                      size: 48,
                                      color: Colors.green.shade800,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 12,),
                          const Divider(),

                          Text(
                            'prolanis',
                            style: GoogleFonts.pathwayGothicOne(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.teal.shade900),
                          ),
                          Text(
                            prolanis,
                            style: GoogleFonts.pathwayGothicOne(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.teal.shade900),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }


  launchWhatsApp(String telepon, String text) async {
    final link = WhatsAppUnilink(
      phoneNumber: telepon,
      text: text,
    );
    await launch('$link');
  }
}
