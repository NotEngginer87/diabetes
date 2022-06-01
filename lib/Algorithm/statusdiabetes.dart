import '../api/DatabaseServices.dart';

int countleapyear(int y, m) {
  int years = y;
  if (m <= 2) years--;
  return (years / 4 - years / 100 + years / 400).floor();
}

num getdate(int y1, m1, d1, y2, m2, d2) {
  List<int> monthdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  num n1, n2;

  n1 = (365 * y1) + d1;
  for (int i = 1; i < m1 - 1; i++) {
    n1 += monthdays[i];
  }
  n1 += countleapyear(y1, m1);

  n2 = y2 * 365 + d2;
  for (int i = 1; i < m2 - 1; i++) {
    n2 += monthdays[i];
  }
  n2 += countleapyear(y2, m2);

  return (n1 - n2);
}

String statusDiabetes(
  String email,
  bool poliuri,
  polidipsi,
  polifagi,
  int gdp,
  gds,
  ttgo,
  int countgdp,
  countgds,
  countttgo,
) {
  int gejalaklasikcount = 0;
  bool gejalaklasik = false;
  if (poliuri == true) {
    gejalaklasikcount += 1;
  }
  if (polidipsi == true) {
    gejalaklasikcount += 1;
  }

  if (ttgo == true) {
    gejalaklasikcount += 1;
  }
  if (gejalaklasikcount == 3) {
    gejalaklasik = true;
  }

  if (gdp > 126) {
    DatabaseServices.updatestatusDiabetescountgdp(email);
  }
  if (gds > 200) {
    DatabaseServices.updatestatusDiabetescountgdp(email);
  }
  if (ttgo > 200) {
    DatabaseServices.updatestatusDiabetescountgdp(email);
  }

  if (gdp >= 100) {
    return 'Diabetes';
  } else if ((gejalaklasik) && gdp >= 126) {
    return 'Diabetes';
  } else if ((gejalaklasik) && gds >= 200) {
    return 'Diabetes';
  } else if ((gejalaklasik) && ttgo >= 126) {
    return 'Diabetes';
  } else if (countgdp > 1) {
    return 'Diabetes';
  } else if (countgds > 1) {
    return 'Diabetes';
  } else if (countttgo > 1) {
    return 'Diabetes';
  } else if (ttgo >= 200) {
    return 'Diabetes';
  } else if (gds >= 200) {
    return "Diabetes";
  } else if ((gds >= 90) && (gds <= 199)) {
    return "Pre - Diabetes";
  } else if (gdp < 100) {
    if (gds < 90) {
      return 'Normal';
    } else {
      return 'Pre - Diabetes';
    }
  }
  return 'Normal';
}
