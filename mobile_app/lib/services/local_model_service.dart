import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class LocalModelService {

  Map vocabulary = {};
  List weights = [];
  double bias = 0;

  Future loadModel(String path) async {

    String data = await rootBundle.loadString(path);

    var jsonData = jsonDecode(data);

    vocabulary = jsonData["vocabulary"];
    weights = List<double>.from(jsonData["weights"]);
    bias = jsonData["bias"];
  }

  double predict(String text) {

    double score = bias;

    vocabulary.forEach((token, index) {

      if (text.contains(token)) {

        score += weights[index];

      }

    });

    double probability = 1 / (1 + exp(-score));

    return probability;
  }
}