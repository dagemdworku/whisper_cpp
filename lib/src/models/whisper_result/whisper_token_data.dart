import 'package:whisper_cpp/whisper_cpp.dart';

class WhisperTokenData {
  final int id;
  final int tid;
  final double p;
  final double plog;
  final double pt;
  final double ptsum;
  final int t0;
  final int t1;
  final double vlen;

  WhisperTokenData({
    required this.id,
    required this.tid,
    required this.p,
    required this.plog,
    required this.pt,
    required this.ptsum,
    required this.t0,
    required this.t1,
    required this.vlen,
  });

  factory WhisperTokenData.fromJson(Map<Object?, Object?>? data) {
    Map<String, dynamic> json = Map<String, dynamic>.from(data as Map);

    return WhisperTokenData(
      id: IntHandler.parse(json['id']),
      tid: IntHandler.parse(json['tid']),
      p: DoubleHandler.parse(json['p']),
      plog: DoubleHandler.parse(json['plog']),
      pt: DoubleHandler.parse(json['pt']),
      ptsum: DoubleHandler.parse(json['ptsum']),
      t0: IntHandler.parse(json['t0']),
      t1: IntHandler.parse(json['t1']),
      vlen: DoubleHandler.parse(json['vlen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tid': tid,
      'p': p,
      'plog': plog,
      'pt': pt,
      'ptsum': ptsum,
      't0': t0,
      't1': t1,
      'vlen': vlen,
    };
  }
}
