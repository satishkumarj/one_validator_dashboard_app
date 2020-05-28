import 'package:validator/models/undelegation.dart';

class Delegation {
  Delegation({
    this.delegateAddress,
    this.validatorAddress,
    this.validatorName,
    this.amount,
    this.reward,
    this.unDelegations,
  });
  final String delegateAddress;
  final String validatorAddress;
  final String validatorName;
  final double amount;
  final double reward;
  final List<UnDelegation> unDelegations;
}
