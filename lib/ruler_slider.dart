import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ruller_slider/my_custom_slider.dart';
import 'package:vibration/vibration.dart';

class RulerSlider extends StatefulWidget {
  final Color thumbColor;
  final Color trackColor;
  final int length;

  RulerSlider(this.thumbColor, this.trackColor, this.length);

  @override
  _RulerSliderState createState() => _RulerSliderState();
}

class _RulerSliderState extends State<RulerSlider> {
  List<Widget> ruler;
  List<Widget> numbers;

  double _sliderValue = 0.0;

  @override
  void initState() {
    ruler = rulerBuilder(widget.length);
    numbers = numbersBuilder(widget.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${_sliderValue.toInt()} miles",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              color: widget.thumbColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Container(
            height: 38,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[]..addAll(rulerBuilder(widget.length)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: SliderTheme(
                      data: SliderThemeData(
                          thumbColor: widget.thumbColor,
                          trackShape: CustomTrackShape(),
                          inactiveTrackColor: Colors.transparent,
                          activeTrackColor: Colors.transparent,
                          overlayColor: Colors.transparent,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8)),
                      child: Container(
                        height: 50,
                        child: MyCustomSlider(
                          divisions: widget.length,
                          min: 0.0,
                          max: widget.length.toDouble(),
                          onChanged: (newRating) {
                            if (Vibration.hasVibrator() != null) {
                              Vibration.vibrate(duration: 20);
                            }
                            setState(() => _sliderValue = newRating);
                          },
                          value: _sliderValue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[]..addAll(numbersBuilder(widget.length)),
          ),
        ),
      ],
    );
  }

  List<Widget> rulerBuilder(int length) {
    List<Widget> ruler = [];
    for (var i = 0; i < length + 1; i++) {
      if (i == 0 || i % 5 == 0) {
        ruler.add(
            CustomPaint(painter: LinePainter(20.0, 1.0, widget.trackColor)));
      } else {
        ruler.add(
            CustomPaint(painter: LinePainter(10.0, 1.0, widget.trackColor)));
      }
    }
    return ruler;
  }

  List<Widget> numbersBuilder(int length) {
    List<Widget> numbers = [];
    for (var i = 0; i < length + 1; i++) {
      if (i == 0 || i % 5 == 0) {
        numbers.add(Container(
          width: 16,
          child: Center(
            child: Text(
              "$i",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.trackColor,
              ),
            ),
          ),
        ));
      }
    }
    return numbers;
  }
}

class LinePainter extends CustomPainter {
  LinePainter(this.length, this.width, this.color);

  double length;
  double width;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = color
      ..strokeWidth = 2;
    Offset p1 = Offset(0, 0);
    Offset p2 = Offset(0, length);

    canvas.drawLine(p1, p2, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
