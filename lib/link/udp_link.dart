import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class Link {
  Stream<Uint8List> get bytes;
  void send(Uint8List data);
  Future<void> open();
  void close();
}

class UDPLink extends Link {
  final int port;
  UDPLink({this.port = 14551});

  RawDatagramSocket? _socket;
  InternetAddress? _remoteAddress;
  int? _remotePort;
  final _controller = StreamController<Uint8List>.broadcast();

  @override
  Stream<Uint8List> get bytes => _controller.stream;

  @override
  Future<void> open() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket!.listen((event) {
      if (event != RawSocketEvent.read) return;

      final datagram = _socket!.receive();
      if (datagram == null) return;
      _remoteAddress = datagram.address;
      _remotePort = datagram.port;

      _controller.add(datagram.data);
    });
  }

  @override
  void send(Uint8List data) {
    if (_remoteAddress == null || _remotePort == null) return;
    _socket?.send(data, _remoteAddress!, _remotePort!);
  }

  @override
  void close() {
    _socket?.close();
    _controller.close();
  }
}
