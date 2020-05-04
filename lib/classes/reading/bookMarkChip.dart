import 'package:BibleRead/classes/service/SharedPrefs.dart';
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
                  return Row(
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(width: 5),
                      Text(
                          SharedPrefs().parseBookMarkedVerse(bookmark.data),
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                         SizedBox(width: 5),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 15,
                          child: Icon(Icons.clear,
                          size: 18,
                          color: Colors.white)
                        )
                    ]
                  );
                } else {
                  return Container(height: 0);
                }
              });
        });
  }
}
