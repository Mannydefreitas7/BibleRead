

import 'dart:io';

import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_share_file/flutter_share_file.dart';

class CompletedCard extends StatelessWidget {
  CompletedCard({Key key}) : super(key: key); 

  //Create an instance of ScreenshotController
  final ScreenshotController screenshotController = ScreenshotController(); 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ReadingPlans>(
      stream: DatabaseHelper().queryCurrentPlan().asStream(),
      builder: (context, snapshot) {
        int selectedPlan = snapshot.hasData ? snapshot.data.index : 0;
        String planName = snapshot.hasData ? snapshot.data.name : 'Loading...';


        return Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Screenshot(
                  controller: screenshotController,
                  child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
                  child: 
                  Container(
                    color: Theme.of(context).cardColor,
                  //  height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                          overflow: Overflow.visible,
                        children: [
                          ClipPath(
                            child: Image.asset('assets/images/plan_${selectedPlan}_pnr.jpg', 
                            fit: BoxFit.cover,
                            height: 250,
                            ),
                            clipper: WaveClipper(),
                          ),
                          Positioned(
                              bottom: -30,
                              child: Image.asset('assets/images/medal.png', 
                              height: 120,)
                            ),
                        ]),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).translate('congratulations'),
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).textTheme.headline6.color,
                                fontWeight: FontWeight.bold
                              ),
                      ),
                      SizedBox(height: 10),
                          Text(AppLocalizations.of(context).translate('completed_reading_plan_text'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.caption.color,
                            fontWeight: FontWeight.normal
                          ),
                      ),
                      SizedBox(height: 10),
                          Text(planName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            
                            color: Theme.of(context).textTheme.headline6.color,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic
                          ),
                      ),
                      SizedBox(height: 20),
                      FlatButton(
                        onPressed: () async {
                          await screenshotController.capture()
                        .then((image) async {
                           Directory dir = await getApplicationDocumentsDirectory();
                            String newPath = '${dir.path}/plan.png';
                            image.rename(newPath).then((value) => {
                                FlutterShareFile.shareImage(
                                  dir.path, 
                                  'plan.png',
                              )
                            });
                        });
                        },
                        child: Text(AppLocalizations.of(context).translate('share'),
                          style: TextStyle(fontSize: 22, color: Theme.of(context).accentColor),
                        )
                        )
                            ],
                          ),
                        ),
                        ]),
                  )
                    ),
          ),
        );
      }
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, 
  size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
