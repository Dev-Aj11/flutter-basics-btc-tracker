import 'package:bitcoin_ticker/CryptoCurrency.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.elementAt(0);
  String cryptoCurrency = 'BTC';

  double btcPrice;
  double ethPrice;
  double solPrice;

  @override
  void initState() {
    getExchangeRate();
    super.initState();
  }

  void getExchangeRate() async {
    var price =
        await CryptoCurrency().getCryptoPrice(cryptoCurrency, selectedCurrency);
    setState(() {
      btcPrice = price;
    });
  }

  CupertinoPicker getiOSPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList.elementAt(selectedIndex);
          getExchangeRate();
        });
      },
      children: currenciesList
          .map((e) => Text(e, style: TextStyle(color: Colors.white)))
          .toList(),
    );
  }

  DropdownButton getAndroidPicker() {
    return DropdownButton(
      value: selectedCurrency,
      items: currenciesList.map((currency) {
        return DropdownMenuItem<String>(
          child: Text(currency),
          value: currency,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $btcPrice $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: (Platform.isIOS) ? getiOSPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
