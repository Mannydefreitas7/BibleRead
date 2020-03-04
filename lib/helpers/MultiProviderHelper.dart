import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:provider/provider.dart';

class MultiProviderHelper {
MultiProviderHelper();

List multiprovider = [

    ChangeNotifierProvider<BibleBookListData>(create: (_) => BibleBookListData())

  ];

}
