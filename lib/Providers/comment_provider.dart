import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> _comments = [];
  bool isDataFetched = false;

  List<CommentModel> get comments => _comments;

  Future<void> fetchComments(BuildContext context) async {
    if (!isDataFetched) {
      try {
        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          _comments = jsonResponse
              .map((comment) => CommentModel.fromJson(comment))
              .toList();
          isDataFetched = true;
          notifyListeners();
        } else {
          isDataFetched = true;
          notifyListeners();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Failed to fetch data'),
                content: Text('${response.statusCode.toString()}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        isDataFetched = true;
        notifyListeners();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Failed to fetch data'),
              content: Text('${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('Error: $e');
      }
    }
  }
}
