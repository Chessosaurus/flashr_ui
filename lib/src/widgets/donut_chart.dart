import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final double voteAverage;

  DonutChart({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    double roundedVoteAverage = double.parse(voteAverage.toStringAsFixed(1));
    double progressValue = roundedVoteAverage / 10.0;

    Color donutColor = Colors.red;
    if (roundedVoteAverage >= 8.5) {
      donutColor = Colors.green[900]!;
    } else if (roundedVoteAverage >= 7) {
      donutColor = Colors.green;
    } else if (roundedVoteAverage >= 5) {
      donutColor = Colors.yellow;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 10,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              donutColor,
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
