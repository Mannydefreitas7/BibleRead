
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:provider/provider.dart';

class MultiProviderHelper {
MultiProviderHelper();

List multiprovider = [

    ChangeNotifierProvider<BibleBookListData>(create: (_) => BibleBookListData())

  ];

}
