import 'package:validator/models/undelegation.dart';

class Delegation {
  Delegation({
    this.delegateAddress,
    this.validatorAddress,
    this.amount,
    this.reward,
    this.unDelegations,
  });
  final String delegateAddress;
  final String validatorAddress;
  final double amount;
  final double reward;
  final List<UnDelegation> unDelegations;
}
