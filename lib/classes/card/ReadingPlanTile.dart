import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;


class ReadingPlanTile extends StatelessWidget {

  final int selectedIndex;
  final int index;
  final Function onTap;
  final String planTitle;
  
  ReadingPlanTile({
    this.onTap,
    this.index, 
    this.selectedIndex, 
    this.planTitle
    });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
          onTap: onTap,
          child: Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: BoxDecoration(
            color: selectedIndex == index ? Theme.of(context).accentColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)
          ),
          height: 100,
          child: Stack(
            children: <Widget>[
              Image(
                width: 100,
                height: 100,
              image: AssetImage('assets/images/plan_${index}_sqr.jpg')
              ),
              Positioned(
                right: intl.Bidi.isRtlLanguage() ? 80 : null,
                left: intl.Bidi.isRtlLanguage() ? null : 80,
                  child: Container(
                  //  width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Theme.of(context).accentColor : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                height: 100,
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                     padding: EdgeInsets.symmetric(horizontal: 10),
                       width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(planTitle,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.start,
                        style: TextStyle(
                      color: selectedIndex == index ? Colors.white : Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 18
                      ),
                        ),
                    ),
                  ],
                ),
                  ),
              )
            ],
          )
        ),
      ),
    );
  }
}
