import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextflow_covid_today/covid_today_result.dart';
import 'package:nextflow_covid_today/stat_box.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nextflow COVID-19 Today',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Nextflow COVID-19 Today'),
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
  @override
  void initState() {
    super.initState();
    print('init state');
    getData();
  }

  Future<CovidTodayResult> getData() async {
    print('get data');
    var response = await http.get(Uri.parse(
        "https://covid19.th-stat.com/json/covid19v2/getTodayCases.json"));
    var result = covidTodayResultFromJson(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print('Build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<CovidTodayResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            CovidTodayResult result = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  StatBox(
                    title: 'สะสม',
                    total: result.confirmed,
                    backgroundColor: Colors.purple,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: 'หายแย้ว',
                    total: result.recovered,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: 'อยู่โรงพยาบาล',
                    total: result.hospitalized,
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StatBox(
                    title: 'กลับบ้านเก่า',
                    total: result.deaths,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }
}
