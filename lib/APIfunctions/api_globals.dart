import 'dart:io';
import 'dart:typed_data';

const String API_PREFIX = 'johncagetribute.org';
final baseHeader = {HttpHeaders.contentTypeHeader: 'application/json'};

//Headers for Sockets - TESTING
Uint8List start = Uint8List.fromList([115,116,97,114,116,0]);

Uint8List musicHeader(Uint8List music) {
  var b = BytesBuilder();
  b.add(Uint8List(1));
  b.add(music);
  music = b.toBytes();
  return music;
}
