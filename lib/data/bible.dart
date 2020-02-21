class Chapter {
  int bookNumber;
  String chapterNumberData;
  String chapterNumberHtml;
  String chapterRange;
  bool isRead;
}

class Book {
  String bookNumberData;
  String bookNumberHtml;
  List<Chapter> chapters;
  bool isRead;
  String shortName;
  String longName;
  int totalChapters;
}

