import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';

class DetailScreen extends StatelessWidget {
  final oneCallData;

  DetailScreen({this.oneCallData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 50.0,
                  ),
                ),
              ),
              Center(
                child: CustomPaint(
                  size: Size(300.0, 300.0),
                  painter: MyPainter(
                      oneCallData['current']['dt'],
                      oneCallData['current']['sunrise'],
                      oneCallData['current']['sunset']),
                ),
              ),
              FlatButton(
                onPressed: () {
                  print('detail/data');
                  print(oneCallData);
                },
                child: Text(
                  oneCallData['current']['temp'].toString(),
                  style: kButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final int dt;
  final int sunrise;
  final int sunset;

  MyPainter(this.dt, this.sunrise, this.sunset);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 50, 300, 350);
    final startAngle = -math.pi;
    final sweepAngle = math.pi;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    var icon = Icons.wb_sunny;
    var percentage = (dt - sunrise) / (sunset - sunrise);
    if ((dt < sunrise) | (dt > sunset)) {
      percentage += 1.0;
      icon = Icons.wb_cloudy;
    }
    final sunHorizontal =
        130 + (150 * (math.sin(math.pi * (percentage + 1.5))));
    final sunVertical = 180 - (150 * (math.cos(math.pi * (percentage + 1.5))));

    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 40.0,
        fontFamily: icon.fontFamily,
        color: Colors.yellow,
      ),
    );
    textPainter.layout();
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
    textPainter.paint(canvas, Offset(sunHorizontal, sunVertical));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
