class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Pembayaran',
      image: 'Asset/Svg/Pay.svg',
      discription:
          "Sekarang bayar sampah dan PDAM dengan mudah dan ngga ribet."),
  UnbordingContent(
      title: 'Urun Rembug ',
      image: 'Asset/Svg/Discus.svg',
      discription: "Berembug dan bertukar saran dengan sesama warga"),
  UnbordingContent(
      title: 'Lapor Kades',
      image: 'Asset/Svg/Report.svg',
      discription:
          "Sekarang bisa melaporkan keluhan yang dialami ke pak kades"),
];
