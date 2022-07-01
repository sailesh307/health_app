import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

class CardModel {
  String doctor;
  int cardBackground;
  var cardIcon;

  CardModel(this.doctor, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [
  CardModel("Cardiologist", 0xFFec407a, Icons.heart_broken),
  CardModel("Dentist", 0xFF5c6bc0, const IconData(0x1F9B7)),
  CardModel("Eye Special", 0xFFfbc02d, TablerIcons.eye),
  CardModel("Orthopaedic", 0xFF1565C0, Icons.wheelchair_pickup_sharp),
  CardModel("Paediatrician", 0xFF2E7D32, const IconData(0x1f476)),
];
