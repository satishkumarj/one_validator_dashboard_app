class EpochSigningPercent {
  EpochSigningPercent({
    this.epochSigned,
    this.epochToSign,
    this.epochSigningPercentage,
    this.numBeaconBlocksUntilNextEpoch,
  });
  final int epochSigned;
  final int epochToSign;
  final int numBeaconBlocksUntilNextEpoch;
  final double epochSigningPercentage;
}
