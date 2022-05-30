
// ignore_for_file: non_constant_identifier_names

import 'package:diabetes/api/DatabaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../api/ColorsApi.dart';
import 'anamnesis.dart';






class AnamnesisCard extends StatefulWidget {
  const AnamnesisCard({Key? key}) : super(key: key);

  @override
  State<AnamnesisCard> createState() => _AnamnesisCardState();
}

class _AnamnesisCardState extends State<AnamnesisCard> {
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
                        'Isi Data Diabetes Pertamamu !!!',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            style: Buttonstyle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Anamnesis()));

                              DatabaseServices.uploadfaktorresikosetfalse(useremail!);
                            },
                            child: const Text('Jawab Survey')),
                      )
                    ],
                  ),
                ))));
  }
}