import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:validator/components/list_view_item.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/bls_key.dart';
import 'package:validator/models/delegation.dart';
import 'package:validator/models/lifetime.dart';
import 'package:validator/models/metrics.dart';
import 'package:validator/models/validator.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/delegators_list_screen.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/networking.dart';

class ValidatorDetails extends StatefulWidget {
  ValidatorDetails({@required this.model});

  final ValidatorListModel model;

  @override
  _ValidatorDetailsState createState() => _ValidatorDetailsState();
}

class _ValidatorDetailsState extends State<ValidatorDetails> {
  ValidatorListModel record;
  Validator validator;
  bool dataLoading = false;

  @override
  void initState() {
    super.initState();
    record = widget.model;
    dataLoading = true;
    getValidatorDetails();
  }

  void getValidatorDetails() async {
    print('Data loading started');
    NetworkHelper networkHelper = NetworkHelper();
    var blockData = await networkHelper.getData(kApiMethodGetValidatorInformation, record.address);
    if (blockData != null) {
      debugPrint(blockData.toString());
      String validatorAddress = blockData['result']['validator']['address'];
      // Fees
      double rate = double.parse(blockData['result']['validator']['rate']) * 100.0;
      double maxRate = double.parse(blockData['result']['validator']['max-rate']) * 100.0;
      double maxChangeRate = double.parse(blockData['result']['validator']['max-change-rate']) * 100.0;

      // Performance
      double lifeRewards = blockData['result']['lifetime']['reward-accumulated'] / kNumberToDivide;
      int blocksToSign = blockData['result']['lifetime']['blocks']['to-sign'];
      int blocksSigned = blockData['result']['lifetime']['blocks']['signed'];
      double apr = double.parse(blockData['result']['lifetime']['apr']) * 100.0;
      double upTime = 0.0;
      if (blocksToSign != null && blocksSigned != null) {
        upTime = (blocksSigned / blocksToSign) * 100.0;
      }
      LifeTimeDetails lifeTimeDetails = LifeTimeDetails(
        apr: apr,
        blocksSigned: blocksSigned,
        blocksToSign: blocksToSign,
        rewardAccumulated: lifeRewards,
        upTimePercentage: upTime,
      );

      //metrics
      Metrics metrics = Metrics();
      if (blockData['result']['metrics'] != null) {
        List<BlsKey> keys = new List<BlsKey>();
        String shards = '';
        for (int i = 0; i < (blockData['result']['metrics']['by-bls-key'].length); i++) {
          var blsKey = blockData['result']['metrics']['by-bls-key'][i];
          BlsKey bK = BlsKey(
            blsPublicKey: (blsKey['key']['bls-public-key']).toString(),
            groupPercent: (blsKey['key']['group-percent']).toString(),
            effectiveStake: (blsKey['key']['effective-stake']).toString(),
            earningAccount: (blsKey['key']['earning-account']).toString(),
            overallPercent: (blsKey['key']['overall-percent']).toString(),
            shardId: blsKey['key']['shard-id'],
          );
          shards = shards + '${blsKey['key']['shard-id']}' + ',';
          keys.add(bK);
        }
        if (shards.length > 1) {
          if (shards.substring(shards.length - 1) == ',') {
            shards = shards.substring(0, shards.length - 1);
          }
        }
        metrics = Metrics(blsKeys: keys, shards: shards);
      }

      // Delegations
      double selfStake = 0;
      double delegatedStake = 0;
      List<Delegation> delegations = new List<Delegation>();
      if (blockData['result']['validator']['delegations'] != null) {
        for (int i = 0; i < (blockData['result']['validator']['delegations'].length); i++) {
          var del = blockData['result']['validator']['delegations'][i];
          String add = (del['delegator-address']).toString();
          double amount = del['amount'] / kNumberToDivide;
          double reward = del['reward'] / kNumberToDivide;
          if (add == validatorAddress) {
            selfStake = amount;
          } else {
            delegatedStake = delegatedStake + amount;
          }
          Delegation delegation = Delegation(
            delegateAddress: add,
            reward: reward,
            amount: amount,
          );
          delegations.add(delegation);
        }
      }

      setState(() {
        validator = Validator(
          blsPublicKeys: blockData['result']['validator']['bls-public-keys'],
          lastEpochInCommittee: blockData['result']['validator']['last-epoch-in-committee'],
          minSelfDelegation: blockData['result']['validator']['min-self-delegation'],
          maxTotalDelegation: blockData['result']['validator']['max-total-delegation'] / kNumberToDivide,
          rate: kUSPercentageNumberFormat.format(rate),
          maxRate: kUSPercentageNumberFormat.format(maxRate),
          maxChangeRate: kUSPercentageNumberFormat.format(maxChangeRate),
          updateHeight: blockData['result']['validator']['update-height'],
          name: blockData['result']['validator']['name'],
          identity: blockData['result']['validator']['identity'],
          website: blockData['result']['validator']['website'],
          securityContact: blockData['result']['validator']['security-contact'],
          details: blockData['result']['validator']['details'],
          creationHeight: blockData['result']['validator']['creation-height'],
          address: validatorAddress,
          totalDelegation: blockData['result']['total-delegation'] / kNumberToDivide,
          currentlyInCommittee: blockData['result']['currently-in-committee'],
          eposStatus: blockData['result']['epos-status'],
          eposWinningStake: blockData['result']['validator']['epos-winning-stake'],
          bootedStatus: blockData['result']['validator']['booted-status'],
          lifeTimeDetails: lifeTimeDetails,
          metrics: metrics,
          delegations: delegations,
          selfStake: selfStake,
          delegatedStake: delegatedStake,
        );
      });
    }
    setState(() {
      dataLoading = false;
      print('Data loading finished');
    });
    //print(blockData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.name),
      ),
      body: dataLoading
          ? SpinKitDoubleBounce(
              color: Colors.grey,
              size: 50.0,
            )
          : Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(5),
                children: <Widget>[
                  Text(
                    'Profile',
                    style: kSectionTitleTextStyle,
                  ),
                  ReusableCard(
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListViewItem(
                          title: 'Name',
                          text: validator.name == null ? '' : validator.name,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Total Staked',
                          text: validator.totalDelegation == null ? '0' : '${kUSNumberFormat.format(validator.totalDelegation)}',
                          moreDetails: true,
                          openMoreDetails: () {},
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Delegated',
                          text: validator.delegatedStake == null ? '0' : '${kUSNumberFormat.format(validator.delegatedStake)}',
                          moreDetails: true,
                          openMoreDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DelegatorDetailsScreen(
                                  model: validator,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Self Stake',
                          text: validator.selfStake == null ? '0' : '${kUSNumberFormat.format(validator.selfStake)}',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Max Delegation',
                          text: '${kUSNumberFormat.format(validator.maxTotalDelegation)}',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Elected Status',
                          text: validator.eposStatus == null ? '' : validator.eposStatus,
                        ),
                      ],
                    ),
                    colour: kMainColor.withAlpha(20),
                  ),
                  Text(
                    'General Info',
                    style: kSectionTitleTextStyle,
                  ),
                  ReusableCard(
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListViewItem(
                          title: 'Description',
                          text: validator.details == null ? '' : validator.details,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Website',
                          text: validator.website == null ? '' : validator.website,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Validator Address',
                          text: validator.address == null ? '' : validator.address,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Validator Since',
                          text: validator.creationHeight == null ? '' : 'Block # ${validator.creationHeight}',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Fee',
                          text: validator.rate == null ? '' : '${validator.rate} %',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Max Fee Change',
                          text: validator.rate == null ? '' : '${validator.maxChangeRate} % (per day)',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                    colour: kMainColor.withAlpha(20),
                  ),
                  Text(
                    'Performance',
                    style: kSectionTitleTextStyle,
                  ),
                  ReusableCard(
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListViewItem(
                          title: 'Uptime (AVG)',
                          text: '${kUSPercentageNumberFormat.format(validator.lifeTimeDetails.upTimePercentage)} %',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Slots',
                          text: validator.metrics.blsKeys == null ? '' : '${validator.metrics.blsKeys.length}',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Elected Slots',
                          text: validator.metrics.blsKeys == null ? '' : '${validator.metrics.blsKeys.length}',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Expected Return',
                          text: validator.lifeTimeDetails.apr == null ? '' : '${kUSPercentageNumberFormat.format(validator.lifeTimeDetails.apr)} %',
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Shards',
                          text: validator.metrics.shards == null ? '' : validator.metrics.shards,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        ListViewItem(
                          title: 'Lifetime Rewards',
                          text: validator.lifeTimeDetails.rewardAccumulated == null
                              ? ''
                              : '${kUSNumberFormat.format(validator.lifeTimeDetails.rewardAccumulated)}',
                        ),
                      ],
                    ),
                    colour: kMainColor.withAlpha(20),
                  ),
                ],
              ),
            ),
    );
  }
}
