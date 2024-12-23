import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_simulator/Manager/simple_event_manager.dart';
import 'package:life_simulator/ads/ConsentManager.dart';
import 'package:life_simulator/model/event.dart';
import 'package:life_simulator/widget/status_header.dart';

class GameScreen extends StatefulWidget {
  InterstitialAd? _interstitialAd;
  final _consentManager = ConsentManager();
  var _isMobileAdsInitializeCalled = false;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  GameScreen(this.eventManager, {super.key});

  SimpleEventManager eventManager;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Event> evList = [];

  @override
  void initState()  {
    super.initState();
   // evList.add(widget.eventManager.getNextEvent());
    widget._consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint(
            "${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      // Kick off the first play of the "game".

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });
    evList.add(widget.eventManager.getNextEvent());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Life Simulator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StatusHeader(widget.eventManager.status),
          Container(
            color: Colors.amber,
            height: 300,
            width: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              reverse: true,
              child: Column(
                children: [
                  for (var ev in evList)
                    ListTile(
                      leading: Text(
                        '${ev.age}岁',
                        style: TextStyle(fontSize: 16),
                      ),
                      title: Text(ev.text, style: TextStyle(fontSize: 16)),
                      subtitle: Text(ev.dsc),
                      titleAlignment: ListTileTitleAlignment.top,
                    )
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var op in evList[evList.length - 1].option)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      final ev = evList[evList.length - 1];
                      ev.dsc = op.onChoose(widget.eventManager);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(ev.dsc)));
                      evList.add(widget.eventManager.getNextEvent());
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.purpleAccent.withAlpha(100)),
                    child: Text(
                      op.optionNm,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      floatingActionButton: evList[evList.length - 1].option.isEmpty
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    widget._interstitialAd!.show();
                    widget.eventManager = SimpleEventManager();
                    evList.clear();
                    evList.add(widget.eventManager.getNextEvent());
                    _loadAd();
                  });
                },
                child: Icon(Icons.replay),
              ),
              if (!widget.eventManager.endIdc)
                FloatingActionButton(
                  onPressed: () {
                    if (widget.eventManager.endIdc) {
                      return;
                    }
                    setState(() {
                      evList.add(widget.eventManager.getNextEvent());
                    });
                  },
                  child: Icon(Icons.navigate_next),
                ),
            ])
          : null,
    );
  }

  @override
  void dispose() {
    widget._interstitialAd?.dispose();
    super.dispose();
  }

  //-------------------------------------Ads--------------------------------------

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    var _isMobileAdsInitializeCalled=widget._isMobileAdsInitializeCalled;
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await widget._consentManager.canRequestAds()) {
      widget._isMobileAdsInitializeCalled = true;

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();

      // Load an ad.
      _loadAd();
    }
  }

  /// Loads an interstitial ad.
  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await widget._consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    InterstitialAd.load(
        adUnitId: widget.adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            widget._interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }


}
