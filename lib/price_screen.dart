import 'dart:convert';
import 'dart:io';
import 'package:bitcoin_ticker/config.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String,String> exchangeRate = {};
  bool isWaiting = false;
  CoinData coinData = CoinData();

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems
          .add(DropdownMenuItem(child: Text(currency), value: currency));
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOsPicker() {
    List<Text> currencyWidgets = [];
    for (String currency in currenciesList) {
      currencyWidgets.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: currencyWidgets,
      onSelectedItemChanged: (int value) async {
        setState(() {
          selectedCurrency = currenciesList[value];
          getData();
        });
      },
    );
  }



  Column getCurrencyData() {
    List<Widget> items = [];
    for (String crypto in cryptoList) {
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $crypto = ${isWaiting?'⏳':exchangeRate[crypto]} $selectedCurrency',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
      ;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items);
  }

  void getData() async{
    isWaiting = true;
    var rate = await coinData.getData(selectedCurrency);
    setState(() {
      exchangeRate = rate;
    });
    isWaiting = false;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        getCurrencyData(),
        Container(
          height: 150.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 30.0),
          color: Colors.lightBlue,
          child: Platform.isIOS ? iOsPicker() : androidDropdown(),
        ),
        ],
      ),
    );
  }
}
