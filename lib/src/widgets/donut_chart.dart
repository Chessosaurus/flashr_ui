import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final double voteAverage;

  DonutChart({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    double roundedVoteAverage = double.parse(voteAverage.toStringAsFixed(1));
    double progressValue = roundedVoteAverage / 10.0;

    // Bestimme die Farbe basierend auf dem gerundeten Wert
    Color donutColor = Colors.red; // Standardfarbe
    if (roundedVoteAverage >= 8.5) {
      donutColor = Colors.green[900]!; // Dunkelgrün
    } else if (roundedVoteAverage >= 7) {
      donutColor = Colors.green; // Hellgrün
    } else if (roundedVoteAverage >= 5) {
      donutColor = Colors.yellow; // Gelb
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 10, // Breite des Donuts
            backgroundColor: Colors.transparent, // Hintergrundfarbe
            valueColor: AlwaysStoppedAnimation<Color>(
              donutColor, // Dynamische Farbe basierend auf gerundetem Wert
            ),
          ),
        ),
        Text(
          roundedVoteAverage.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
