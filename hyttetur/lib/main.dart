import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BeerTrackerApp());
}

class BeerTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Beer Tracker'),
        ),
        body: BeerListScreen(),
      ),
    );
  }
}

class BeerListScreen extends StatefulWidget {
  @override
  _BeerListScreenState createState() => _BeerListScreenState();
}

class _BeerListScreenState extends State<BeerListScreen> {
  List<Student> students = [];
  final String beerCountKey = 'beer_count_key';

  @override
  void initState() {
    super.initState();
    _loadBeerCounts();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(students[index].name),
          subtitle: Text('Beers taken: ${students[index].beersTaken}'),
          onTap: () {
            _showRecordBeerDialog(students[index]);
          },
        );
      },
    );
  }

  Future<void> _loadBeerCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      students = [
        Student(name: 'Søren', beersTaken: prefs.getInt('Søren') ?? 0),
        Student(name: 'Gustav', beersTaken: prefs.getInt('Gustav') ?? 0),
        // Add more students here
      ];
    });
  }

  Future<void> _saveBeerCounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (final student in students) {
      prefs.setInt(student.name, student.beersTaken);
    }
  }

  Future<void> _showRecordBeerDialog(Student student) async {
    int beersTaken = student.beersTaken;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Record Beers for ${student.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Current Beers Taken: $beersTaken'),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Number of Beers'),
                onChanged: (value) {
                  setState(() {
                    beersTaken = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  student.beersTaken += beersTaken; // Append the value
                });
                _saveBeerCounts(); // Save the updated counts
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class Student {
  final String name;
  int beersTaken;

  Student({required this.name, required this.beersTaken});
}