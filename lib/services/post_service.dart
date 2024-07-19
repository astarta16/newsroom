import 'package:dio/dio.dart';
import '../models/post.dart';

class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final Dio _dio = Dio();

  Future<List<Post>> fetchPosts(int start, int limit) async {
    try {
      final response = await _dio.get('$_baseUrl/posts', queryParameters: {
        '_start': start,
        '_limit': limit,
      });

      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }
}
