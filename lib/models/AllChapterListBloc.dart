import 'dart:async';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';

class AllChapterListBloc {
  List<Plan> bookChapters;
  final _allChaptersController = StreamController<List<Plan>>.broadcast();

  Stream<List<Plan>> get allChapters => _allChaptersController.stream;

  getAllChapters() async {
    _allChaptersController.sink.add(await DatabaseHelper().getAllChapters());
  }

  AllChapterListBloc() {
    getAllChapters();
  }

  markChapterRead(int id) {
    DatabaseHelper().markChapterRead(id);
    getAllChapters();
  }

  markChapterUnRead(int id) {
    DatabaseHelper().markChapterUnRead(id);
    getAllChapters();
  }

  dispose() {
    _allChaptersController.close();
  }
}

class UnReadChapterListBloc {
  final _unreadChaptersController = StreamController<List<Plan>>.broadcast();

  Stream<List<Plan>> get unReadChapters => _unreadChaptersController.stream;

  UnReadChapterListBloc() {
    getUnReadChapters();
  }

  markChapterRead(int id) {
    DatabaseHelper().markChapterRead(id);
    getUnReadChapters();
  }

  markChapterUnRead(int id) {
    DatabaseHelper().markChapterUnRead(id);
    getUnReadChapters();
  }

  getUnReadChapters() async {
    _unreadChaptersController.sink.add(await DatabaseHelper().unReadChapters());
  }

  dispose() {
    _unreadChaptersController.close();
  }
}

class BookChapterListBloc {
  final _bookChaptersController = StreamController<List<Plan>>.broadcast();

  Stream<List<Plan>> getbookChapters(int id) => _bookChaptersController.stream;

  BookChapterListBloc() {
    
  }

  _getBookChapters(int id) async {
    _bookChaptersController.sink
        .add(await DatabaseHelper().queryBookChapters(id));
  }

  dispose() {
    _bookChaptersController.close();
  }
}
