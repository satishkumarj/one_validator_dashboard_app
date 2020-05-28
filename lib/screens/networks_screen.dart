import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator/components/resuable_card.dart';
import 'package:validator/models/networks.dart';
import 'package:validator/utilities/constants.dart';
import 'package:validator/utilities/globals.dart';

class NetworksScreen extends StatefulWidget {
  @override
  _NetworksScreenState createState() => _NetworksScreenState();
}

class _NetworksScreenState extends State<NetworksScreen> {
  int _networksCount = 0;
  List<Networks> activeNetworks = new List<Networks>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < Global.networks.keys.toList().length; i++) {
      Networks net = Global.networks[Global.networks.keys.toList()[i]];
      if (net.active) {
        activeNetworks.add(net);
      }
    }
    _networksCount = activeNetworks.length;
  }

  @override
  Widget build(BuildContext context) {
    Global.checkIfDarkModeEnabled(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Networks'),
      ),
      body: _networksCount == 0
          ? Container(
              padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
              child: Center(
                child: Text(
                  'No networks',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: kHmyTitleTextColor,
                  ),
                ),
              ),
            )
          : Container(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _networksCount,
                    itemBuilder: (BuildContext context, int index) {
                      Networks network = activeNetworks[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                        child: ReusableCard(
                          cardChild: ListTile(
                            trailing: network.url == Global.selectedNetworkUrl
                                ? Icon(
                                    FontAwesomeIcons.check,
                                    color: kHmyMainColor,
                                    size: 20.0,
                                  )
                                : null,
                            leading: Icon(
                              FontAwesomeIcons.networkWired,
                              color: kHmyMainColor,
                              size: 20.0,
                            ),
                            title: Text(
                              network.name,
                              style: GoogleFonts.nunito(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              setState(() {});
                            },
                          ),
                          colour: Global.isDarkModeEnabled ? Colors.black : Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
