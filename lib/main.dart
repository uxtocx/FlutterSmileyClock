import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _hourController;
  AnimationController _minuteController;
  AnimationController _secondsController;
  Animation<double> _hourAnimation;
  Animation<double> _minuteAnimation;
  Animation<double> _secondsAnimation;
  DateTime _dateTime = DateTime.now();
  Timer _hourTimer;
  Timer _minuteTimer;
  Timer _secondsTimer;
  double _hour;
  double clockHour;
  double _minute;
  double clockMinute;
  double _seconds;
  double clockSeconds;
  Tween<double> _hourTween;
  Tween<double> _minuteTween;
  Tween<double> _secondsTween;

  double getHourRadian() {
    return _hour * 0.524;
  }

  double getMinuteRadian() {
    return _minute * 0.104;
  }

  double getSecondsRadian() {
    return _seconds * 0.104;
  }

//  void _incrementCounter() {
//    _hourTween.begin = _hourTween.end;
//    _hourController.reset();
//    _hour = _hour + 1;
//    _hourTween.end = getHourRadian();
//    _hourController.value = 0;
//    _hourController.forward();
//  }

  @override
  void initState() {
    super.initState();
    _seconds = 0;
    _secondsController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _secondsTween = Tween(begin: 2.5, end: 3.75);
    _secondsAnimation = _secondsTween.animate(_secondsController);
    _secondsController.repeat(reverse: true);

    _hourController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    clockHour = double.parse(DateFormat('HH').format(_dateTime));
    _hour = clockHour;
    print('currenHour = $_hour');
    _hourTween = Tween(begin: 0.524 * _hour, end: getHourRadian());
    _hourAnimation = _hourTween.animate(_hourController);
    _updateHour();

    _minuteController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    clockMinute = double.parse(DateFormat('mm').format(_dateTime));
    _minute = clockMinute;
    print('curren minute = $_minute');
    _minuteTween = Tween(begin: 0.104 * _minute, end: getMinuteRadian());
    _minuteAnimation = _minuteTween.animate(_minuteController);
    _updateMinute();
  }

  void _updateHourModel() {
    _hourTween.begin = _hourTween.end;
    _hourController.reset();
    _hour = _hour + 1;
    _hourTween.end = getHourRadian();
    _hourController.value = 0;
    _hourController.forward();
    clockHour = double.parse(DateFormat('HH').format(_dateTime));
    _updateHour();
  }

  void _updateMinuteModel() {
    _minuteTween.begin = _minuteTween.end;
    _minuteController.reset();
    _minute = _minute + 1;
    _minuteTween.end = getMinuteRadian();
    //print(getMinuteRadian());
    _minuteController.value = 0;
    _minuteController.forward();
    _updateMinute();
    clockMinute = double.parse(DateFormat('mm').format(_dateTime));
  }

  void _updateHour() {
    _dateTime = DateTime.now();
    _hourTimer = Timer(
      Duration(hours: 1) -
          Duration(minutes: _dateTime.minute) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateHourModel,
    );
  }

  void _updateMinute() {
    _dateTime = DateTime.now();
    _minuteTimer = Timer(
      Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateMinuteModel,
    );
    print('minute =$_minute');
  }

  void _updateSecondsModel() {
    _secondsController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hourTimer?.cancel();
    _hourController.dispose();
    _minuteController.dispose();
    _secondsController.dispose();
    _secondsAnimation.isDismissed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hourToDisplay =
        (clockHour > 12 ? clockHour - 12 : clockHour).floor().toString();
    var minuteToDisplay =
        (clockMinute > 59 ? clockMinute - 60 : clockMinute).floor().toString();
    //print('hour:$_hour');
    //print(_minuteTween.begin);
    // print(_minuteTween.end);
    print(_secondsTween.begin);
    print(_secondsTween.end);
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    var width = screenWidth / 2.25;
    return Scaffold(
      body: Stack(
        children: <Widget>[
//background
          Container(color: Colors.blueGrey[900]),
//          Container(
//            decoration: BoxDecoration(
//              gradient: RadialGradient(
//                  colors: [Color(0xFFFDF36A), Color(0xFFFFC300)]),
//              shape: BoxShape.circle,
//            ),
//          ),
//Face
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset('assets/SmileyFace.png'),
          ),
//Eyes
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, width * 60 / 100),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ClockEye(
                    controller: _hourController,
                    animation: _hourAnimation,
                    eyeBallSize: width,
                    pupilSize: width * 60 / 100,
                    pupilGlossSize: width * 20 / 100,
                    //time: hourToDisplay,
                    time: '',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ClockEye(
                    controller: _minuteController,
                    animation: _minuteAnimation,
                    eyeBallSize: width,
                    pupilSize: width * 60 / 100,
                    pupilGlossSize: width * 20 / 100,
                    //time: minuteToDisplay,
                    time: '',
                  ),
                ),
              ],
            ),
          ),
//Mouth Seconds
          Positioned(
            left: screenWidth / 2 - (width * 95 / 100) / 2,
            top: screenHeight * 70 / 100,
            child: SmileSeconds(
              secondsController: _secondsController,
              secondsAnimation: _secondsAnimation,
              secondsSize: screenWidth * 20 / 100,
              mouthHeight: screenHeight * 15 / 100,
              mouthWidth: screenWidth * 15 / 100,
            ),
          ),
//          Positioned(
//            left: screenWidth / 2 - (width * 40 / 100) / 2,
//            top: screenHeight * 70 / 100,
//            child: Seconds(
//                controller: _secondsController,
//                animation: _secondsAnimation,
//                noseSize: width * 40 / 100,
//                secondsSize: width * 10 / 100,
//                timeMins: minuteToDisplay,
//                timeHour: hourToDisplay),
//          ),
        ],
      ),
//          Positioned(
//            left: screenWidth / 2 - (width * 10 / 100) / 2,
//            top: screenHeight * 68 / 100,
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.black,
//                shape: BoxShape.circle,
//              ),
//              width: width * 10 / 100,
//              height: width * 10 / 100,
//            ),
//          )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ClockEye extends StatelessWidget {
  ClockEye({
    Key key,
    @required AnimationController controller,
    @required this.animation,
    @required this.eyeBallSize,
    @required this.pupilSize,
    @required this.pupilGlossSize,
    this.time,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Animation<double> animation;
  final double eyeBallSize;
  final double pupilSize;
  final double pupilGlossSize;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.blue,
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.white,
            Colors.blue[300],
          ]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(0.0, 0.0),
              spreadRadius: 12.0,
            )
          ],
        ),
        width: eyeBallSize,
        height: eyeBallSize,
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: animation.value,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        height: pupilSize,
                        width: pupilSize,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  shape: BoxShape.circle,
                                ),
                                width: pupilGlossSize,
                                height: pupilGlossSize,
//                                child: Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    Text(
//                                      time,
//                                      style: TextStyle(
//                                          color: Colors.black26,
//                                          fontSize: 50,
//                                          fontWeight: FontWeight.bold),
//                                    ),
//                                  ],
//                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class Seconds extends StatelessWidget {
  Seconds({
    Key key,
    @required AnimationController controller,
    @required this.animation,
    @required this.noseSize,
    @required this.secondsSize,
    this.timeHour,
    this.timeMins,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Animation<double> animation;
  final double noseSize;
  final double secondsSize;
  final String timeHour;
  final String timeMins;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 20,
          top: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
            width: noseSize,
            height: noseSize,
            child: Align(
              child: Text(
                '$timeHour:$timeMins',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0x00222222),
            shape: BoxShape.circle,
          ),
          width: noseSize + 40,
          height: noseSize + 40,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: animation.value + pi / 2,
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      width: secondsSize,
                      height: secondsSize,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SmileSeconds extends StatelessWidget {
  const SmileSeconds({
    Key key,
    @required AnimationController secondsController,
    @required Animation<double> secondsAnimation,
    @required this.mouthHeight,
    @required this.mouthWidth,
    @required this.secondsSize,
  })  : _secondsController = secondsController,
        _secondsAnimation = secondsAnimation,
        super(key: key);

  final AnimationController _secondsController;
  final Animation<double> _secondsAnimation;
  final double mouthHeight;
  final double secondsSize;
  final double mouthWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0x00FFFFFF),
            shape: BoxShape.circle,
          ),
          width: secondsSize,
          height: secondsSize,
          child: AnimatedBuilder(
            animation: _secondsController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _secondsAnimation.value,
                child: Column(
                  children: <Widget>[
                    Container(
//                      decoration: BoxDecoration(
//                        color: Colors.amber,
//                        shape: BoxShape.circle,
//                      ),
                      width: mouthWidth,
                      height: mouthHeight,
                      child: Transform.rotate(
                        angle: pi,
                        child: Rive(
                          filename: 'assets/SmileyMouth.flr',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
//        Positioned(
//          left: 180,
//          top: 100,
//          child: Container(
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color: Colors.brown,
//            ),
//            width: 60,
//            height: 60,
//          ),
//        ),
      ],
    );
  }
}
