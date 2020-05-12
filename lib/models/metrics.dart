import 'package:validator/models/bls_key.dart';

class Metrics {
  Metrics({
    this.blsKeys,
    this.shards,
  });
  final List<BlsKey> blsKeys;
  final String shards;
}
