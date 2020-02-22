import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:provider/provider.dart';

class MultiProviderHelper {
MultiProviderHelper();

List multiprovider = <StreamProvider>[

    StreamProvider<Map<dynamic, dynamic>>.value(value: JwOrgApiHelper().getBibleBooks().asStream())

    

  ];

}
