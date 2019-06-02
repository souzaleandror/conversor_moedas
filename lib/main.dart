import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
//import 'package:async/async.dart';
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=633f4e40";

void main() async {
//  http.Response response = await http.get(request);

//  print(response.body);
//  print(json.decode(response.body));
//  print(json.decode(response.body)["results"]);
//  print(json.decode(response.body)["results"]["currincies"]);
//  print(json.decode(response.body)["results"]["currincies"]["USD"]);
//  print(json.decode(response.body)["results"]["currincies"]["USD"]["name"]);
//  print(json.decode(response.body)["results"]["currincies"]["USD"]["buy"]);
//
//  print(await getData());

  runApp(MaterialApp(home: Home(),
  theme: ThemeData(
    hintColor: Colors.amber,
    primaryColor: Colors.white
  ),));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar;
  double euro;

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }
  void _realChanged(String text) {
    print(text);
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    print(text);
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = ((dollar * this.dollar) / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    print(text);
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = ((euro * this.euro) / dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ), // AppBar
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando dados...",
                      style: TextStyle(
                          color: Colors.amber, fontSize: 25.0), // TextStyle
                      textAlign: TextAlign.center,
                    ), // Text
                  ); // Center
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Erro ao Carregar Dados",
                        style: TextStyle(
                            color: Colors.amber, fontSize: 25.0), // TextStyle
                        textAlign: TextAlign.center,
                      ), // Text
                    ); // Center
                  } else {
                    dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                          Divider(),
                          buildTextField("Reais", "R\$", realController, _realChanged),
                          Divider(),
                          buildTextField("Dollar", "US\$", dollarController, _dollarChanged),
                          Divider(),
                          buildTextField("Euro", "€", euroController, _euroChanged),
                        ],
                      )
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ), // InputDecoration
    style: TextStyle(
      color: Colors.amber,
    ), // TextStyle
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
