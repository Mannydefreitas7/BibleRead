import 'package:BibleRead/classes/service/ReadingProgressData.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMarkChip extends StatelessWidget {
  BookMarkChip();

  @override
  Widget build(BuildContext context) {
    ReadingProgressData readingProgressData = Provider.of<ReadingProgressData>(context);
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
                        GestureDetector(
                            onTap: () => readingProgressData.removeBookMark(),
                            child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 15,
                            child: Icon(Icons.clear,
                            size: 18,
                            color: Colors.white)
                          ),
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
