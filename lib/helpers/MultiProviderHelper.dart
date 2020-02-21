import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultiProviderHelper {
MultiProviderHelper();

List multiprovider = <StreamProvider>[

    StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),

    StreamProvider<List<JwBibleBook>>.value(value: JwOrgApiHelper().getBibleBooks().asStream())

  ];

}
