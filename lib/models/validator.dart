import 'package:validator/models/delegation.dart';
import 'package:validator/models/lifetime.dart';
import 'package:validator/models/metrics.dart';

class Validator {
  Validator({
    this.blsPublicKeys,
    this.delegations,
    this.lastEpochInCommittee,
    this.address,
    this.name,
    this.bootedStatus,
    this.creationHeight,
    this.lifeTimeDetails,
    this.currentlyInCommittee,
    this.details,
    this.eposStatus,
    this.eposWinningStake,
    this.identity,
    this.maxChangeRate,
    this.maxRate,
    this.maxTotalDelegation,
    this.metrics,
    this.minSelfDelegation,
    this.rate,
    this.securityContact,
    this.totalDelegation,
    this.updateHeight,
    this.website,
    this.selfStake,
    this.delegatedStake,
  });
  final List<dynamic> blsPublicKeys;
  final List<Delegation> delegations;
  final int lastEpochInCommittee;
  final double minSelfDelegation;
  final double maxTotalDelegation;
  final String rate;
  final String maxRate;
  final String maxChangeRate;
  final int updateHeight;
  final String name;
  final String identity;
  final String website;
  final String securityContact;
  final String details;
  final int creationHeight;
  final String address;
  final LifeTimeDetails lifeTimeDetails;
  final Metrics metrics;
  final double totalDelegation;
  final bool currentlyInCommittee;
  final String eposStatus;
  final double eposWinningStake;
  final String bootedStatus;
  final double selfStake;
  final double delegatedStake;
}
