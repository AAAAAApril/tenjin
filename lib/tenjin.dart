import 'dart:async';

import 'package:flutter/services.dart';

///必须要调用了 [optIn]/[optOut]/[optInParams]/[optOutParams] 之后才调用 [connect]
///当然，不调用前面那几个应该也可以
///
/// 文档：https://docs.tenjin.com/cn/send-events/android.html
///
class Tenjin {
  Tenjin._();

  static const MethodChannel _channel = MethodChannel('april_tenjin');

  ///初始化
  static Future<bool> init(String apiKey) {
    return _channel
        .invokeMethod<bool>('init', <String, dynamic>{
          'apiKey': apiKey,
        })
        .then<bool>((value) => value ?? false)
        .catchError((_) => false);
  }

  static Future<void> connect() {
    return _channel
        .invokeMethod<bool>('connect')
        .then<void>((value) {})
        .catchError((_) {});
  }

  static Future<void> optInParams({
    // 这里需要的参数要看文档
    List<String> params = const <String>[],
  }) {
    return _channel
        .invokeMethod<bool>('optInParams', <String, dynamic>{
          'params': params,
        })
        .then<void>((value) {})
        .catchError((_) {});
  }

  static Future<void> optOutParams({
    // 这里需要的参数要看文档
    List<String> params = const <String>[],
  }) {
    return _channel
        .invokeMethod<bool>('optOutParams', <String, dynamic>{
          'params': params,
        })
        .then<void>((value) {})
        .catchError((_) {});
  }

  ///事件
  static Future<void> event(String eventName, {String? params}) {
    return _channel
        .invokeMethod<bool>('event', <String, dynamic>{
          'name': eventName,
          'value': params,
        })
        .then<void>((value) {})
        .catchError((_) {});
  }

  ///内购事件
  static Future<void> purchase({
    required String productId,
    required String currencyCode,
    required int quantity,
    required double unitPrice,
    required String purchaseData,
    required String dataSignature,
  }) {
    return _channel
        .invokeMethod<bool>('transaction', <String, dynamic>{
          'productId': productId,
          'currencyCode': currencyCode,
          'quantity': quantity,
          'unitPrice': unitPrice,
          'purchaseData': purchaseData,
          'dataSignature': dataSignature,
        })
        .then<void>((value) {})
        .catchError((_) {});
  }

  ///用于做 A/B 测试时的版本值
  static Future<void> appendAppSubversion(int version) {
    return _channel
        .invokeMethod<bool>('appendAppSubversion', <String, dynamic>{
          'value': version,
        })
        .then<void>((value) {})
        .catchError((_) {});
  }
}
