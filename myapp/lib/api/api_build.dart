import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_models.dart';

class ApiBuild {
  static const String url = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception("Erro ao pegar os dAdos");
    }
  }
}
