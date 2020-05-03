import 'package:flutter/material.dart';

class BRCard extends StatelessWidget {

 final Container container;
 final BorderRadiusGeometry borderRadius;

BRCard({this.container, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius
         ),
        child: container
    );
  }
}
