import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/list_view_item.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/bls_key.dart';
import 'package:validator/models/delegation.dart';
import 'package:validator/models/lifetime.dart';
import 'package:validator/models/metrics.dart';
import 'package:validator/models/validator.dart';
import 'package:validator/models/validator_list_model.dart';
import 'package:validator/screens/delegators_list_screen.dart';
import 'package:validator/screens/totalstake_piechart_screen.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';
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
  bool noDataReturned = false;
  String errorMessage = 'No Validator details found!';
  int favCount = 0;
  List<String> favAddsKeys = new List<String>();
  Map<String, String> favAdds = new Map<String, String>();
  bool isFavorite;

  Future<void> getValidatorDetails() async {
    print('Data loading started');
    NetworkHelper networkHelper = NetworkHelper();
    var blockData = await networkHelper.getData(kApiMethodGetValidatorInformation, record.address);
    if (blockData != null) {
      if (blockData["error"] != null) {
        noDataReturnedHandler('');
      } else {
        String validatorAddress = blockData['result']['validator']['address'];
        // Fees
        double rate = double.parse(blockData['result']['validator']['rate']) * 100.0;
        double maxRate = double.parse(blockData['result']['validator']['max-rate']) * 100.0;
        double maxChangeRate = double.parse(blockData['result']['validator']['max-change-rate']) * 100.0;

        // Performance
        double lifeRewards = blockData['result']['lifetime']['reward-accumulated'] / Global.numberToDivide;
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
          if (shards.length > 0) {
            String strShards = '';
            int shard0Count = '0'.allMatches(shards).length;
            int shard1Count = '1'.allMatches(shards).length;
            int shard2Count = '2'.allMatches(shards).length;
            int shard3Count = '3'.allMatches(shards).length;
            if (shard0Count > 0) {
              strShards = strShards + 'Shard 0 : $shard0Count\n';
            }
            if (shard1Count > 0) {
              strShards = strShards + 'Shard 1 : $shard1Count\n';
            }
            if (shard2Count > 0) {
              strShards = strShards + 'Shard 2 : $shard2Count\n';
            }
            if (shard3Count > 0) {
              strShards = strShards + 'Shard 3 : $shard3Count\n';
            }
            shards = strShards;
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
            double amount = del['amount'] / Global.numberToDivide;
            double reward = del['reward'] / Global.numberToDivide;
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
          noDataReturned = false;
          record.name = blockData['result']['validator']['name'];
          validator = Validator(
            blsPublicKeys: blockData['result']['validator']['bls-public-keys'],
            lastEpochInCommittee: blockData['result']['validator']['last-epoch-in-committee'],
            minSelfDelegation: blockData['result']['validator']['min-self-delegation'],
            maxTotalDelegation: blockData['result']['validator']['max-total-delegation'] / Global.numberToDivide,
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
            totalDelegation: blockData['result']['total-delegation'] / Global.numberToDivide,
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
    } else {
      noDataReturnedHandler('');
    }
    setState(() {
      dataLoading = false;
      print('Data loading finished');
    });
    //print(blockData);
  }

  void noDataReturnedHandler(String error) {
    setState(() {
      record.name = 'Validator Details';
      noDataReturned = true;
      if (error != '') {
        errorMessage = error;
      }
      validator = Validator(
        blsPublicKeys: [],
        lastEpochInCommittee: 0,
        minSelfDelegation: 0,
        maxTotalDelegation: 0,
        rate: '',
        maxRate: '',
        maxChangeRate: '',
        updateHeight: 0,
        name: '',
        identity: '',
        website: '',
        securityContact: '',
        details: '',
        creationHeight: 0,
        address: '',
        totalDelegation: 0,
        currentlyInCommittee: false,
        eposStatus: '',
        eposWinningStake: 0.0,
        bootedStatus: '',
        lifeTimeDetails: LifeTimeDetails(upTimePercentage: 0.0, rewardAccumulated: 0.0, blocksToSign: 0, blocksSigned: 0, apr: 0.0),
        metrics: Metrics(
          shards: '',
          blsKeys: [],
        ),
        delegations: [],
        selfStake: 0.0,
        delegatedStake: 0.0,
      );
    });
  }

  void addToFavoriteValidators(String favAddress, String validatorName) {
    Global.setUserPreferences(favAddress, validatorName);
    setState(() {
      if (favAdds[favAddress] == null) {
        favAdds[favAddress] = validatorName;
        favAddsKeys.add(favAddress);
        favCount = favAddsKeys.length;
      }
    });
    Global.setUserFavList(Global.favoriteValListKey, favAddsKeys);
  }

  void removeFromFavoriteValidator() {
    int index = -1;
    for (int i = 0; i < favAddsKeys.length; i++) {
      String add = favAddsKeys[i];
      if (add == record.address) {
        index = i;
        break;
      }
    }
    if (index >= 0) {
      favAddsKeys.removeAt(index);
      Global.setUserFavList(Global.favoriteValListKey, favAddsKeys);
    }
  }

  void getFavAddressList() async {
    favAddsKeys = await Global.getUserFavList(Global.favoriteValListKey);
    Map<String, String> favAddKeysAndNames = new Map<String, String>();
    for (int i = 0; i < favAddsKeys.length; i++) {
      String add = favAddsKeys[i];
      if (add == record.address) {
        isFavorite = true;
      }
      favAddKeysAndNames[add] = await Global.getUserPreferences(add);
    }
    setState(() {
      favAdds = favAddKeysAndNames;
      favCount = favAddsKeys.length;
    });
  }

  @override
  void initState() {
    super.initState();
    record = widget.model;
    dataLoading = true;
    noDataReturned = true;
    isFavorite = false;
    getValidatorDetails();
    getFavAddressList();
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(record.name),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: isFavorite
                ? Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.red,
                  )
                : Icon(
                    FontAwesomeIcons.heart,
                  ),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  isFavorite = false;
                  removeFromFavoriteValidator();
                } else {
                  isFavorite = true;
                  addToFavoriteValidators(record.address, record.name);
                }
              });
            },
          ),
        ],
      ),
      body: dataLoading
          ? SpinKitDoubleBounce(
              color: Colors.grey,
              size: 50.0,
            )
          : noDataReturned
              ? Container(
                  padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
                  child: Center(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kHmyTitleTextColor,
                      ),
                    ),
                  ),
                )
              : Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getValidatorDetails();
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(5),
                      children: <Widget>[
                        Text(
                          'Profile',
                          style: GoogleFonts.nunito(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        ReusableCard(
                          cardChild: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListViewItem(
                                title: 'Name',
                                text: validator == null ? '' : validator.name,
                                height: 80.0,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Total Staked',
                                text: validator == null ? '0' : '${kUSNumberFormat.format(validator.totalDelegation)}',
                                moreDetails: true,
                                openMoreDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TotalStakeScreen(
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
                                title: 'Delegated',
                                text: validator == null ? '0' : '${kUSNumberFormat.format(validator.delegatedStake)}',
                                moreDetails: true,
                                openMoreDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DelegatorDetailsScreen(
                                        model: validator,
                                        refreshData: getValidatorDetails,
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
                                text: validator == null ? '0' : '${kUSNumberFormat.format(validator.selfStake)}',
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Max Delegation',
                                text: validator.maxTotalDelegation == null ? '0' : '${kUSNumberFormat.format(validator.maxTotalDelegation)}',
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
                          colour: kHmyMainColor.withAlpha(20),
                        ),
                        Text(
                          'Performance',
                          style: GoogleFonts.nunito(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
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
                                text: validator.blsPublicKeys == null ? '0' : '${validator.blsPublicKeys.length}',
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Elected Slots',
                                text: validator.metrics.blsKeys == null ? '0' : '${validator.metrics.blsKeys.length}',
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Expected Return',
                                text: validator.lifeTimeDetails.apr == null
                                    ? ''
                                    : '${kUSPercentageNumberFormat.format(validator.lifeTimeDetails.apr)} %',
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Elected Shards',
                                text: validator.metrics.shards == null ? '-' : validator.metrics.shards,
                                height: 90.0,
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
                          colour: kHmyMainColor.withAlpha(20),
                        ),
                        Text(
                          'General Info',
                          style: GoogleFonts.nunito(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        ReusableCard(
                          cardChild: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ListViewItem(
                                title: 'Description',
                                text: validator.details == null ? '' : validator.details,
                                height: 140.0,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Website',
                                selectable: true,
                                text: validator.website == null ? '' : validator.website,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListViewItem(
                                title: 'Validator Address',
                                text: validator.address == null ? '' : validator.address,
                                selectable: true,
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
                          colour: kHmyMainColor.withAlpha(20),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
