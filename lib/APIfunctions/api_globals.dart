import 'dart:io';
import 'dart:typed_data';

const String API_PREFIX = 'johncagetribute.org';
final baseHeader = {HttpHeaders.contentTypeHeader: 'application/json'};

//Headers for Sockets - TESTING
Uint8List start = Uint8List.fromList([115,116,97,114,116,0]);

final Uint8List silence = Uint8List(5000);

Uint8List musicHeader(Uint8List music) {
  var b = BytesBuilder();
  b.add(Uint8List(1));
  b.add(music);
  music = b.toBytes();
  return music;
}

String splitHeader(Uint8List data) {
  String header = '';
  int index = 0;
  while (index < data.length && data[index] != 0) {
    index++;
  }
  if (index == data.length) {
    return String.fromCharCodes(data);
  }
  header = String.fromCharCodes(data.sublist(0,index + 1));
  return header;
}
