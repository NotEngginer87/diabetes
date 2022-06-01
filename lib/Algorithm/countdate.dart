
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