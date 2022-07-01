import 'package:flutter/material.dart';

class BannerModel {
  String text;
  List<Color> cardBackground;
  String image;

  BannerModel(this.text, this.cardBackground, this.image);
}

List<BannerModel> bannerCards = [
  BannerModel(
      "Check Disease",
      [
        const Color(0xffa1d4ed),
        const Color(0xffc0eaff),
      ],
      "assets/414-bg.png"),
  BannerModel(
      "Covid-19",
      [
        const Color(0xffb6d4fa),
        const Color(0xffcfe3fc),
      ],
      "assets/covid-bg.png"),
];
