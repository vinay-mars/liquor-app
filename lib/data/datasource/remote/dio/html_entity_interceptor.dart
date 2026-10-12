import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;

/// WooCommerce returns product, category and order line-item names HTML-encoded
/// (e.g. "High &amp; Dry"). Decode every `name` field once here so screens can
/// display them as-is.
class HtmlEntityInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    response.data = _decodeNames(response.data);
    handler.next(response);
  }

  static dynamic _decodeNames(dynamic value) {
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        value[i] = _decodeNames(value[i]);
      }
    } else if (value is Map) {
      for (final key in value.keys.toList()) {
        final field = value[key];
        if (key == 'name' && field is String && field.contains('&')) {
          value[key] = html_parser.parseFragment(field).text ?? field;
        } else if (field is Map || field is List) {
          value[key] = _decodeNames(field);
        }
      }
    }
    return value;
  }
}
