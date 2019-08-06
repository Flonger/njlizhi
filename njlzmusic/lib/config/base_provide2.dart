//import 'dart:async';
//
//import 'package:flutter/cupertino.dart';
//import 'package:provide/provide.dart';
//import 'package:provider/provider.dart';
//import 'package:rxdart/rxdart.dart';
//
//class BaseProvide2 with ChangeNotifier {
//  CompositeSubscription compositeSubscription = CompositeSubscription();
//  addSubscription(StreamSubscription subscription) {
//    compositeSubscription.add(subscription);
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    compositeSubscription.dispose();
//  }
//}
//
//abstract class PageProvideNode2 extends StatelessWidget {
//  BaseProvide2 mProviders = BaseProvide2();
//  Widget buildContent(BuildContext context);
//
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider<BaseProvide2>.value(
//      value: mProviders,
//      child: buildContent(context),
//    );
//  }
//}
