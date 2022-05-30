// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference userdata = firestore.collection('user');
  static CollectionReference blog = firestore.collection('blog');
  static CollectionReference video = firestore.collection('videopembelajaran');
  static CollectionReference kuesioner = firestore.collection('kuesioner');

  static Future<void> updateakun(
      String? email,
      String nama,
      String username,
      String gender,
      String? tanggal,
      String? bulan,
      String? tahun,
      String alamat,
      String noHP,
      String? imageUrl) async {
    await userdata.doc(email).set(
      {
        'email': email,
        'nama': nama,
        'username': username,
        'gender': gender,
        'tanggal': tanggal,
        'bulan': bulan,
        'tahun': tahun,
        'alamat': alamat,
        'noHP': noHP,
        'imageurl': imageUrl,
      },
    );
  }

  static Future<void> setFAQ(String email, int n) async {
    await userdata
        .doc(email.toString())
        .collection('FAQ')
        .doc(n.toString())
        .set(
      {
        'expand': false,
        'id': n,
      },
    );
  }

  static Future<void> expandFAQ(
    int id,
    bool expand,
    String email,
  ) async {
    await userdata
        .doc(email.toString())
        .collection('FAQ')
        .doc(id.toString())
        .update(
      {
        'expand': !expand,
      },
    );
  }

  static Future<void> videoditonton(String? id) async {
    await video.doc(id).update(
      {
        'ditonton': FieldValue.increment(1),
      },
    );
  }

  static Future<void> postingkomentarvideoditonton(
      String? idvideo, email, String? idkomentar, String? komentar) async {
    await video
        .doc(idvideo)
        .collection('komentar')
        .doc(idkomentar.toString())
        .set(
      {
        'id': idkomentar,
        'email': email,
        'komentar': komentar,
      },
    );
  }

  static Future<void> likesvideoup(String? id) async {
    await video.doc(id).update(
      {
        'like': FieldValue.increment(1),
      },
    );
  }

  static Future<void> likesvideodown(String? id) async {
    await video.doc(id).update(
      {
        'like': FieldValue.increment(-1),
      },
    );
  }

  static Future<void> listuserlikevideo(
      String? idvideo, email, String? idlikes, bool setlike) async {
    await video.doc(idvideo).collection('likes').doc(idlikes.toString()).set(
      {
        'id': idlikes,
        'email': email,
        'likes': setlike,
      },
    );
  }

  static Future<void> naikkanbanyakkomentarvideoditonton(
    String? idvideo,
  ) async {
    await video.doc(idvideo).update(
      {
        'banyakkomentar': FieldValue.increment(1),
      },
    );
  }

  static Future<void> terbacaBlog(String? id) async {
    await blog.doc(id).update(
      {
        'terbaca': FieldValue.increment(1),
      },
    );
  }

  static Future<void> kritikdansaran(String keluhan) async {
    await userdata.doc().set(
      {
        'keluhan': keluhan,
      },
    );
  }

  static Future<void> uploadfaktorresiko(
      String email, id, bool value, String resiko) async {
    await userdata.doc(email).collection('faktorresiko').doc(id).set(
      {
        'id': id,
        'value': value,
      },
    );
  }

  static Future<void> uploadfaktorresikosetfalse(String email) async {
    for (int id = 1; id <= 9; id++) {
      await userdata.doc(email).collection('faktorresiko').doc('0$id').set(
        {
          'id': id,
          'value': false,
        },
      );
    }
  }

  static Future<void> updatejmlorangkuesioner() async {
    await kuesioner.doc('kuesionerEUCS').update(
      {
        'orang': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatekuesioner(
    int orangke,
  ) async {
    await kuesioner
        .doc('kuesionerEUCS')
        .collection('orang')
        .doc(orangke.toString())
        .set(
      {
        'id': orangke.toString(),
      },
    );
  }

  static Future<void> updateskorkuesioner(
    int orangke,
    int tambahskor,
  ) async {
    await kuesioner
        .doc('kuesionerEUCS')
        .collection('orang')
        .doc(orangke.toString())
        .update(
      {
        'skor': FieldValue.increment(tambahskor),
      },
    );
  }

  static Future<void> updatewaktukuesioner(
      int orangke,tanggal,bulan,tahun
      ) async {
    await kuesioner
        .doc('kuesionerEUCS')
        .collection('orang')
        .doc(orangke.toString())
        .update(
      {
        'tanggal': tanggal,
        'bulan': bulan,
        'tahun': tahun,
      },
    );
  }

  static Future<void> updateminskorkuesioner(
      int orangke,
      int minskor,
      ) async {
    await kuesioner
        .doc('kuesionerEUCS')
        .collection('orang')
        .doc(orangke.toString())
        .update(
      {
        'skor': FieldValue.increment(-minskor),
      },
    );
  }

  static Future<void> updatejawabankuesioner(
    int orangke,
    String idpertanyaan,
    int nilai,
  ) async {
    await kuesioner
        .doc('kuesionerEUCS')
        .collection('orang')
        .doc(orangke.toString())
        .collection('jawabannomor')
        .doc(idpertanyaan.toString())
        .set(
      {
        'nilai': nilai,
      },
    );
  }


  static Future<void> updatestatusDSMQ(
      String email,
      String value,
      ) async {
    await userdata
        .doc(email)
        .update(
      {
        'statusDSMQ': value,
      },
    );
  }


}
