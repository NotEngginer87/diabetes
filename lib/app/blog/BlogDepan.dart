// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, duplicate_ignore, avoid_unnecessary_containers, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/app/blog/halamanartikel.dart';
import 'package:diabetes/app/blog/halamanvideo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';


class SelectBlog2 extends StatefulWidget {
  const SelectBlog2({Key? key}) : super(key: key);

  @override
  _SelectBlog2State createState() => _SelectBlog2State();
}

class _SelectBlog2State extends State<SelectBlog2> {
  int? hitungterbaca = 0;
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Artikel',

                  ),
                  GButton(
                    icon: LineIcons.hospital,
                    text: 'Video',
                  ),
                  GButton(
                    icon: LineIcons.book,
                    text: 'Tulisan User',
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
        Center(
          child: (_selectedIndex == 0)
              ? HalamanArtikel()
              : (_selectedIndex == 1)
              ? HalamanVideo()
              : (_selectedIndex == 2)
              ? HalamanTulisanUser()
              : Container(),
        )
      ],
    );
  }
}


class HalamanTulisanUser extends StatefulWidget {
  const HalamanTulisanUser({Key? key}) : super(key: key);

  @override
  State<HalamanTulisanUser> createState() => _HalamanTulisanUserState();
}

class _HalamanTulisanUserState extends State<HalamanTulisanUser> {
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference blog = firestore.collection('blog');
    return Column(
        children: [

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Artikel terpopuler : ',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
          ),
          SizedBox(
            height: 8,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: blog
                .orderBy('terbaca', descending: true)
                .limit(5)
                .snapshots(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: snapshot.data.docs
                          .map<Widget>((e) => BlogPopulerCard(
                        e.data()['id'],
                        e.data()['urlgambar1'],
                        e.data()['bab'],
                        e.data()['posting'],
                      ))
                          .toList()),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Artikel terbaru : ',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
          ),
          StreamBuilder(
            stream: blog.snapshots(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.docs
                      .map<Widget>((e) => BlogCard(
                    e.data()['id'],
                    e.data()['bab'],
                    e.data()['judul'],
                    e.data()['penulis'],
                    e.data()['urlgambar1'],
                    e.data()['terbaca'],
                    e.data()['posting'],
                  ))
                      .toList(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
        ]
    );
  }
}



