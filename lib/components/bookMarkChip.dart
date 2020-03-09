import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';

class BookMarkChip extends StatelessWidget {
  final Function onChipPress;

  BookMarkChip({this.onChipPress});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: false,
        future: SharedPrefs().getHasBookMark(),
        builder: (context, hasBookmark) {
          return FutureBuilder(
              initialData: '1:3',
              future: SharedPrefs().getBookMarkData(),
              builder: (context, bookmark) {
                if (bookmark.hasData && hasBookmark.data == true) {
                  return ActionChip(
                      padding: EdgeInsets.all(10),
                      shadowColor: Colors.black.withOpacity(0.5),
                      backgroundColor: Theme.of(context).backgroundColor,
                      avatar: Icon(
                        Icons.bookmark_border,
                        color: Theme.of(context).textTheme.title.color,
                        size: 25,
                      ),
                      onPressed: onChipPress,
                      label: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          SharedPrefs().parseBookMarkedVerse(bookmark.data),
                          style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).textTheme.title.color,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.clear, color: Theme.of(context).textTheme.title.color,),
                      ]));
                } else {
                  return Container(height: 0,);
                }
              });
        });
  }
}
