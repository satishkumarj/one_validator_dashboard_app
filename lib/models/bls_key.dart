class BlsKey {
  BlsKey({
    this.blsPublicKey,
    this.groupPercent,
    this.effectiveStake,
    this.earningAccount,
    this.overallPercent,
    this.shardId,
    this.earnedReward,
  });
  final String blsPublicKey;
  final String groupPercent;
  final String effectiveStake;
  final String earningAccount;
  final String overallPercent;
  final int shardId;
  final double earnedReward;
}
