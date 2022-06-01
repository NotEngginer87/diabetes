// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference userdata = firestore.collection('user');
  static CollectionReference blog = firestore.collection('blog');
  static CollectionReference video = firestore.collection('videopembelajaran');

  static Future<void> updateakun(
      String? email,
      String nama,
      String gender,
      String? tanggal,
      String? bulan,
      String? tahun,
      String alamat,
      String noHP,
      String? imageUrl) async {
    await userdata.doc(email).update(
      {
        'email': email,
        'nama': nama,
        'gender': gender,
        'tanggal': tanggal,
        'bulan': bulan,
        'tahun': tahun,
        'alamat': alamat,
        'noHP': noHP,
        'imageurl': imageUrl,
        'DSMQtanggal': DateTime.now().day,
        'DSMQbulan': DateTime.now().month,
        'DSMQtahun': DateTime.now().year,
        'banyakukurstatusdiabetes': 0,
        'countgdp': 0,
        'countgds': 0,
        'countttgo': 0,
        'statusDSMQ': 'belum ada',
        'statusDiabetes': 'belum ada',
        'beratbadan': 0,
        'tinggibadan': 0,
        'tanggalcekglukosa': 0,
        'bulancekglukosa': 0,
        'tahuncekglukosa': 0,
      },
    );
  }

  static Future<void> updateanamnesis(
      String email, int berat, tinggi, int tanggal, bulan, tahun) async {
    await userdata.doc(email).update(
      {
        'beratbadan': berat,
        'tinggibadan': tinggi,
        'tanggalcekglukosa': tanggal,
        'bulancekglukosa': bulan,
        'tahuncekglukosa': tahun,
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

  static Future<void> updatejmlorangkuesioner(String email) async {
    await userdata.doc(email).update(
      {
        'DSMQcek': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatekuesioner(
    String email,
    int dsmqcek,
  ) async {
    await userdata.doc(email).collection('DSMQ').doc(dsmqcek.toString()).set(
      {
        'id': dsmqcek.toString(),
      },
    );
  }

  static Future<void> updateskorkuesioner(
    String useremail,
    int orangke,
    int tambahskor,
  ) async {
    await userdata
        .doc(useremail)
        .collection('DSMQ')
        .doc(orangke.toString())
        .update(
      {
        'skor': FieldValue.increment(tambahskor),
      },
    );
  }

  static Future<void> updatewaktukuesioner(
      String useremail, int orangke, tanggal, bulan, tahun) async {
    await userdata
        .doc(useremail)
        .collection('DSMQ')
        .doc(orangke.toString())
        .update(
      {
        'tanggal': tanggal,
        'bulan': bulan,
        'tahun': tahun,
        'skor': 0,
      },
    );
  }

  static Future<void> updateminskorkuesioner(
    String useremail,
    int orangke,
    int minskor,
  ) async {
    await userdata
        .doc(useremail)
        .collection('DSMQ')
        .doc(orangke.toString())
        .update(
      {
        'skor': FieldValue.increment(-minskor),
      },
    );
  }

  static Future<void> updatestatusDSMQ(
      String email, String value, int tanggal, bulan, tahun) async {
    await userdata.doc(email).update(
      {
        'statusDSMQ': value,
        'DSMQtanggal': tanggal,
        'DSMQbulan': bulan,
        'DSMQtahun': tahun,
      },
    );
  }

  static Future<void> updatestatusDiabetes(
    String email,
    int banyakstatusdiabetes,
    int gdp,
    gds,
    ttgo,
    bool poliuri,
    polidipsi,
    polifagi,
    String statusdiabetes,
  ) async {
    await userdata
        .doc(email)
        .collection('Status')
        .doc(banyakstatusdiabetes.toString())
        .set(
      {
        'gdp': gdp,
        'gds': gds,
        'ttgo': ttgo,
        'poliuri': poliuri,
        'polidipsi': polidipsi,
        'polifagi': polifagi,
        'statusdiabetes': statusdiabetes,
      },
    );
  }

  static Future<void> updatestatusDiabetesbanyakukurstatus(
    String email,
  ) async {
    await userdata.doc(email).update(
      {
        'banyakukurstatusdiabetes': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatestatusDiabetescountgdp(
    String email,
  ) async {
    await userdata.doc(email).update(
      {
        'countgdp': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatestatusDiabetescountgds(
    String email,
  ) async {
    await userdata.doc(email).update(
      {
        'countgds': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatestatusDiabetescountttgo(
    String email,
  ) async {
    await userdata.doc(email).update(
      {
        'countttgo': FieldValue.increment(1),
      },
    );
  }

  static Future<void> updatestatusDiabetesname(
    String email,
    String value,
  ) async {
    await userdata.doc(email).update(
      {
        'statusDiabetes': value,
      },
    );
  }
}
