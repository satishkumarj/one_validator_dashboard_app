import 'package:validator/models/undelegation.dart';

class Delegation {
  Delegation({
    this.delegateAddress,
    this.amount,
    this.reward,
    this.unDelegations,
  });
  final String delegateAddress;
  final double amount;
  final double reward;
  final List<UnDelegation> unDelegations;
}
