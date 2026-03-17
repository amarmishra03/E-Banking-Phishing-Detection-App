import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/database_service.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final db = DatabaseService();

  int total = 0;
  int phishing = 0;
  int safe = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  void loadStats() async {

    final stats = await db.getStats();

    setState(() {
      total = stats["total"]!;
      phishing = stats["phishing"]!;
      safe = stats["safe"]!;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("Threat Dashboard")),

      body: Column(

        children: [

          SizedBox(height: 20),

          Text("Total Messages Scanned: $total"),

          Text("Phishing Detected: $phishing"),

          Text("Safe Messages: $safe"),

          SizedBox(height: 30),

          Expanded(

            child: PieChart(

              PieChartData(

                sections: [

                  PieChartSectionData(
                    value: phishing.toDouble(),
                    color: Colors.red,
                    title: "Phishing",
                  ),

                  PieChartSectionData(
                    value: safe.toDouble(),
                    color: Colors.green,
                    title: "Safe",
                  ),

                ],

              ),

            ),

          ),

        ],

      ),

    );
  }
}