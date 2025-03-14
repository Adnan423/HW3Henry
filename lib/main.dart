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

  List<CardModel> get cards => _cards;

  void _initializeGame() {
    List<String> cardValues = ['🍎', '🍌', '🍇', '🍉', '🍒', '🥑', '🥕', '🍍'];
    List<String> shuffledValues = [...cardValues, ...cardValues];
    shuffledValues.shuffle(Random());

    _cards = List.generate(16, (index) => CardModel(id: index, value: shuffledValues[index ~/ 2]));
    notifyListeners();
  }

  void flipCard(CardModel card) {
    if (card.isMatched || card.isFaceUp || _secondSelected != null) return;

    card.isFaceUp = true;

    if (_firstSelected == null) {
      _firstSelected = card;
    } else {
      _secondSelected = card;
      _checkMatch();
    }

    notifyListeners();
  }

  void _checkMatch() {
    if (_firstSelected!.value == _secondSelected!.value) {
      _firstSelected!.isMatched = true;
      _secondSelected!.isMatched = true;
    } else {
      Timer(Duration(seconds: 1), () {
        _firstSelected!.isFaceUp = false;
        _secondSelected!.isFaceUp = false;
        notifyListeners();
      });
    }
    _firstSelected = null;
    _secondSelected = null;
  }

  bool get isGameWon => _cards.every((card) => card.isMatched);
}

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Matching Game')),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          if (game.isGameWon) {
            return Center(child: Text('You won! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
          }
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: game.cards.length,
            itemBuilder: (context, index) {
              return CardWidget(card: game.cards[index]);
            },
          );
        },
      ),
    );
  }
}