
import 'package:czestujem/config/themes/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/material.dart';

class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return Column(
      children: [
        _buildWaveHeader(),
        _buildStartButton(),
        //_buildLoadingCircle()
      ],
    );
  }

  Widget _buildWaveHeader(){
    return Stack(
      children: [
        RotatedBox(
          quarterTurns:2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height:(MediaQuery.of(context).size.height)/4,
            color: Colors.transparent,
            child: WaveWidget( //user Stack() widget to overlap content and waves
              config: CustomConfig(
                colors: [
                  foodBlueGreen.withOpacity(0.3),
                  foodBlueGreen.withOpacity(0.3),
                  foodBlueGreen.withOpacity(0.3),
                  //the more colors here, the more wave will be
                ],
                durations: [4000, 5000, 7000],
                //durations of animations for each colors,
                // make numbers equal to numbers of colors
                heightPercentages: [0.01, 0.05, 0.03],
                //height percentage for each colors.
                blur: MaskFilter.blur(BlurStyle.solid, 5),
                //blur intensity for waves
              ),
              waveAmplitude: 25.00, //depth of curves
              waveFrequency: 2, //number of curves in waves
              backgroundColor: Colors.transparent, //background colors
              size: Size(
                double.infinity,
                double.infinity,
              ),
            ),
          ),
        ),
      ]
    );
  }

  Widget _buildStartButton(){
    return ElevatedButton(
      onPressed: () async{
        var firebase = await _initializeFirebase();
        if(firebase != null){
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }

      },
      child: Text(
        'Rozpocznij',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
          )
        ),
        backgroundColor: MaterialStateProperty.all(foodBlueGreen),
        elevation: MaterialStateProperty.all<double>(0),
      ),
    );
  }

  Widget _buildLoadingCircle(){
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            Navigator.pushNamed(context, '/login');
          });

          return Column(
            children: [
              Text('Login'),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: foodBlueGreen,
          ),
        );
      },
    );
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


}

