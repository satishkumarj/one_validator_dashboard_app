class LifeTimeDetails {
  LifeTimeDetails({
    this.rewardAccumulated,
    this.blocksSigned,
    this.blocksToSign,
    this.apr,
    this.upTimePercentage,
  });
  final double rewardAccumulated;
  final int blocksToSign;
  final int blocksSigned;
  final double apr;
  final double upTimePercentage;
}
