import 'dart:convert';
import 'config.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getData(String currency) async {
    Map<String, String> exchangeData = Map();

    for (String crypto in cryptoList) {
      String url = 'https://rest.coinapi.io/v1/exchangerate/'
          '$crypto/$currency?apikey=${Config.COIN_API_KEY}';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        double rate = jsonDecode(response.body)['rate'];
        String rateString = rate.toStringAsFixed(2);
        exchangeData[crypto] = rateString;
      } else {
        throw 'Failed to load exchange rate';
      }
    }
    return exchangeData;
  }
}
