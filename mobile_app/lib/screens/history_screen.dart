import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatefulWidget {

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final db = DatabaseService();

  List logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  void loadLogs() async {

    logs = await db.getLogs();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Detection History"),
      ),

      body: ListView.builder(

        itemCount: logs.length,

        itemBuilder: (context, index) {

          return ListTile(
            title: Text(logs[index]["input"]),
            subtitle: Text(logs[index]["result"]),
          );
        },
      ),
    );
  }
}