import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Card Matching Game',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: CardMatchingGame(),
      ),
    );
  }
}

class CardModel {
  final int id;
  final String value;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.id,
    required this.value,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class GameProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  CardModel? _firstSelected;
  CardModel? _secondSelected;

  GameProvider() {
    _initializeGame();
  }
