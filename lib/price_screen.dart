import 'package:bitcoin_ticker/CryptoCurrency.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/exchange_rate_card.dart';
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
  bool isLoading = true;

  String btcPrice;
  String ethPrice;
  String solPrice;

  @override
  void initState() {
    getExchangeRate();
    super.initState();
  }

  void getExchangeRate() async {
    var cryptoPrices = await CryptoCurrency().getCryptoPrice(selectedCurrency);
    String btcRate = cryptoPrices.elementAt(0);
    String ethRate = cryptoPrices.elementAt(1);
    String solRate = cryptoPrices.elementAt(2);
    setState(() {
      btcPrice = btcRate.isNotEmpty ? btcRate : 'Error';
      ethPrice = ethRate.isNotEmpty ? ethRate : 'Error';
      solPrice = solRate.isNotEmpty ? solRate : 'Error';
      isLoading = false;
    });
  }

  CupertinoPicker getiOSPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList.elementAt(selectedIndex);
        setState(() {
          isLoading = true;
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
      onChanged: (selectedIndex) {
        selectedCurrency = currenciesList.elementAt(selectedIndex);
        setState(() {
          isLoading = true;
          getExchangeRate();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExchangeRateCard(cryptoList.elementAt(0), btcPrice,
                  selectedCurrency, isLoading),
              ExchangeRateCard(cryptoList.elementAt(1), ethPrice,
                  selectedCurrency, isLoading),
              ExchangeRateCard(cryptoList.elementAt(2), solPrice,
                  selectedCurrency, isLoading),
            ],
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
