import 'dart:convert';

import 'package:flutter/material.dart';
import 'json_to_dart.dart';
import 'package:http/http.dart' as http;
import 'helpers.dart';
import 'syntax.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Rest Json to Dart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String textoJson = '';
  String result = '';
  String host = 'http://localhost:8886/v3/';
  String resource = '';
  String className = 'Result';
  final _resultController = TextEditingController();
  final _resourceController = TextEditingController();
  final _hostController = TextEditingController();
  final _classController = TextEditingController();
  final _textoController = TextEditingController();

  @override
  void initState() {
    _hostController.text = host;
    _classController.text = className;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  //initialValue: host,
                  controller: _hostController,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    labelText: 'host',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Falta informar: host';
                    }
                    return null;
                  },
                  onSaved: (x) {
                    host = x;
                  }),
              TextFormField(
//                  initialValue: resource,
                  controller: _resourceController,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                      //border: InputBorder.none,
                      labelText: 'resource',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          _get();
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Falta informar: resource';
                    }
                    return null;
                  },
                  onSaved: (x) {
                    resource = x;
                  }),
              TextFormField(
                  //initialValue: className,
                  controller: _classController,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    labelText: 'ClassName',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Falta informar: classeName';
                    }
                    return null;
                  },
                  onSaved: (x) {
                    className = x;
                  }),
              TextFormField(
                  maxLines: 10,
                  minLines: 3,
                  //initialValue: textoJson,
                  controller: _textoController,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    labelText: 'textJson',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Falta informar: textJson';
                    }
                    return null;
                  },
                  onSaved: (x) {
                    textoJson = x;
                  }),
              TextFormField(
                  maxLines: 20,
                  minLines: 3,
                  //initialValue: result,
                  controller: _resultController,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    //border: InputBorder.none,
                    labelText: '',
                  ),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (x) {}),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _gerar();
        },
        tooltip: 'gerar',
        child: Text('gen'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _get() {
    host = _hostController.text;
    resource = _resourceController.text;
    collectionName = resource.toLowerCase();
    _classController.text = camelCase(resource.toLowerCase() + '_' + 'Item');
    var url = Uri.encodeFull(host + resource + '?\$top=1');
    print(url);
    http.get(url, headers: {
      "Authorization":
          'Bearer eyJjb250YWlkIjoibTUiLCJ1c3VhcmlvIjoiXHUwMDA177+9XCJx3Ynvv73vv73die+/vSIsImRhdGEiOiIyMDIwLTA0LTE4VDEwOjAxOjM0LjI1OFoifQ==',
      'contaId': 'm5',
    }).then((rsp) {
      print(rsp.body);
      if (rsp.statusCode == 200) {
        var j = jsonDecode(rsp.body);
        setState(() {
          _textoController.text = jsonEncode(j['result'][0]);
        });
      }
    });
  }

  _gerar() {
    _formKey.currentState.validate();
    _formKey.currentState.save();

    var f = ModelGenerator(className);
    var code = f.generateDartClasses(textoJson);

    setState(() {
      _resultController.text = code.result;
    });
  }
}
