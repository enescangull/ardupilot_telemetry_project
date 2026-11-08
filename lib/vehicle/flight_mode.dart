String flightModeName(int mode) {
  switch (mode) {
    case 0:
      return "STABILIZE";
    case 2:
      return "ALT_HOLD";
    case 3:
      return "AUTO";
    case 4:
      return "GUIDED";
    case 5:
      return "LOITER";
    case 6:
      return "RTL";
    case 9:
      return "LAND";
    default:
      return "MOD $mode";
  }
}
// ADIM 1: String döndüren, int alan, flightModeName adında bir fonksiyon yaz.

// ADIM 2: İçinde switch kullan. ArduCopter numaraları:
//   0 = STABILIZE, 2 = ALT_HOLD, 3 = AUTO, 4 = GUIDED,
//   5 = LOITER, 6 = RTL, 9 = LAND
//   Listede olmayan bir numara gelirse "MOD <numara>" döndür (örn. "MOD 17").
//   İpucu: Dart'ta switch ifadesi değer döndürebilir: return switch (x) { 0 => '...', _ => '...' };
//          "_" = diğer bütün durumlar.

// TEST: main() içinde print(flightModeName(4)); -> GUIDED yazmalı.
//       print(flightModeName(99)); -> MOD 99 yazmalı.
