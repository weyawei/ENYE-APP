import 'package:flutter/material.dart';

class VAVPage extends StatefulWidget {
  const VAVPage({Key? key}) : super(key: key);

  @override
  _VAVPageState createState() => _VAVPageState();
}

class _VAVPageState extends State<VAVPage> {
  double d1 = 0.0;
  double d2 = 0.0;
  double t1 = 0.0;
  double t2 = 0.0;
  double vavResult = 0.0;

  void calculateVAV() {
    setState(() {
      vavResult = (d2 - d1) / (t2 - t1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VAV Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Temperature 1 (t1)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  t1 = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Temperature 2 (t2)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  t2 = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Damper Position 1 (d1)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  d1 = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Damper Position 2 (d2)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  d2 = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateVAV,
              child: Text('Calculate VAV'),
            ),
            SizedBox(height: 20),
            Text(
              'VAV Result: $vavResult',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
