import 'dart:io';
import 'dart:typed_data';

const String API_PREFIX = 'johncagetribute.org';
final baseHeader = {HttpHeaders.contentTypeHeader: 'application/json'};

//Headers for Sockets - TESTING
Uint8List music = Uint8List.fromList([77,85,83,73,67,0]);