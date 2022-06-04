// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/api/AuthServices.dart';
import 'package:diabetes/app/puskesmas.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../../Algorithm/countdate.dart';
import '../blog/BlogDepan.dart';
import '../home/Edukasi DSMQ.dart';
import '../home/dsmqcard.dart';
import '../home/infopasien.dart';
import '../home/statusdiabetescard.dart';
import '../lihatprofil.dart';
import '../tab3/FAQ.dart';
import '../tab3/kontak.dart';
import '../tab3/tab3.dart';
import '../../api/ColorsApi.dart';

class HalamanRumah extends StatefulWidget {
  const HalamanRumah({Key? key}) : super(key: key);

  @override
  State<HalamanRumah> createState() => _HalamanRumahState();
}

class _HalamanRumahState extends State<HalamanRumah> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userdata = firestore.collection('user');
    CollectionReference eddsmq = firestore.collection('EdukasiDSMQ');

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final useremail = user!.email;
    final ButtonStyle Buttonstyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black,
      primary: Colors.white,
      minimumSize: Size(MediaQuery.of(context).size.width, 48),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        title: const Text('DIA.BETO'),
        centerTitle: true,
        titleTextStyle: GoogleFonts.pathwayGothicOne(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
        backgroundColor: IsiQueColors.isiqueblue.shade400,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StreamBuilder<DocumentSnapshot>(
              stream: userdata.doc(useremail.toString()).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  String? imageUrl = data['imageurl'];

                  return Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Card(
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            child: (imageUrl == null)
                                ? const Image(
                                    image: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/teledentistry-70122.appspot.com/o/foto_blog%2Fkosong.png?alt=media&token=652482ea-7fa4-451f-913a-912c83d3ebd1'),
                                    height: 36,
                                    width: 36,
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: NetworkImage(imageUrl),
                                    height: 36,
                                    width: 36,
                                    fit: BoxFit.cover,
                                  ),
                          )),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LihatProfil();
                        }));
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
          color: Colors.grey.shade50,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: (_selectedIndex == 0)
                  ? Container(
                      color: IsiQueColors.isiqueblue.shade400,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                            children: [
                              const infopasien(),
                              const SDCard(),
                              StreamBuilder<DocumentSnapshot>(
                                stream: userdata.doc(useremail).snapshots(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;

                                    int? DSMQtanggal = data['DSMQtanggal'];
                                    int? DSMQbulan = data['DSMQbulan'];
                                    int? DSMQtahun = data['DSMQtahun'];
                                    num hitung2bulan = getdate(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        DSMQtahun,
                                        DSMQbulan,
                                        DSMQtanggal);

                                    if (hitung2bulan > 60) {
                                      return const DSMQCard();
                                    } else {
                                      return Container();
                                    }
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: userdata.doc(useremail).snapshots(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;

                                    String statusDSMQ = data['statusDSMQ'];

                                    return (statusDSMQ != '') ? Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: IsiQueColors.isiqueblue.shade400,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12, top: 12),
                                                child: Text(
                                                  'Edukasi DSMQ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              StreamBuilder<DocumentSnapshot>(
                                                stream: userdata
                                                    .doc(useremail.toString())
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    Map<String, dynamic> data =
                                                    snapshot.data!.data()
                                                    as Map<String, dynamic>;

                                                    String statusDSMQ =
                                                    data['statusDSMQ'];

                                                    return Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 2,
                                                          left: 12,
                                                          right: 20,
                                                          bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Status DSMQ : ',
                                                            style: GoogleFonts
                                                                .pathwayGothicOne(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w200,
                                                                fontSize: 20,
                                                                color:
                                                                Colors.white),
                                                          ),
                                                          Text(
                                                            statusDSMQ,
                                                            style: GoogleFonts
                                                                .pathwayGothicOne(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w200,
                                                                fontSize: 20,
                                                                color: (statusDSMQ ==
                                                                    'Baik')
                                                                    ? Colors.green
                                                                    .shade600
                                                                    : (statusDSMQ ==
                                                                    'Sedang')
                                                                    ? Colors
                                                                    .yellow
                                                                    : (statusDSMQ ==
                                                                    'Buruk')
                                                                    ? Colors
                                                                    .red
                                                                    : Colors
                                                                    .red),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  return const Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: eddsmq.snapshots(),
                                                builder: (_, AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Column(
                                                        children: snapshot.data.docs
                                                            .map<Widget>((e) =>
                                                            EdukasiDSMQcard(
                                                              e.data()['id'],
                                                              e.data()['jd'],
                                                              e.data()['ed'],
                                                            ))
                                                            .toList());
                                                  } else {
                                                    return Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: const [
                                                        Center(
                                                          child: Center(
                                                            child:
                                                            CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        )) : Container();
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),

                            ],
                          ),
                        ),
                      ))
                  : (_selectedIndex == 1)
                      ? ListView(
                          children: [
                            Container(
                                color: IsiQueColors.isiqueblue.shade400,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                  ),
                                  child: const puskesmas(),
                                ))
                          ],
                        )
                      : (_selectedIndex == 2)
                          ? ListView(
                              children: [
                                Container(
                                    color: IsiQueColors.isiqueblue.shade400,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                      ),
                                      child: const SelectBlog2(),
                                    ))
                              ],
                            )
                          : ListView(
                              children: [
                                Container(
                                    color: IsiQueColors.isiqueblue.shade400,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                      ),
                                      child: Column(
                                        children: [
                                          const Tab3(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: ElevatedButton(
                                                style: Buttonstyle,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const FAQ()));
                                                },
                                                child: const Text('FAQ')),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: ElevatedButton(
                                                style: Buttonstyle,
                                                onPressed: () {
                                                  AuthServices
                                                      .signInWithGoogle();
                                                },
                                                child: const Text('login')),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            child: ElevatedButton(
                                                style: Buttonstyle,
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return const kontak();
                                                      });
                                                },
                                                child: const Text(
                                                    'kontak DIA.BETO')),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ))),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.white,
              hoverColor: Colors.white,
              activeColor: IsiQueColors.isiqueblue.shade500,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: Colors.white,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                ),
                GButton(
                  icon: LineIcons.hospital,
                ),
                GButton(
                  icon: LineIcons.book,
                ),
                GButton(
                  icon: LineIcons.user,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
