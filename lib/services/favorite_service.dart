import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class FavoriteService with ChangeNotifier {
  static const String _favoritesKey = 'favorites';

  List<Post> _favoritePosts = [];

  FavoriteService() {
    _loadInitialFavorites();
  }

  List<Post> get favoritePosts => _favoritePosts;

  Future<void> _loadInitialFavorites() async {
    final favoritePosts = await getFavoritePosts();
    _favoritePosts = favoritePosts;
    notifyListeners();
    print('Initial favorites loaded: ${favoritePosts.length} items');
  }

  Future<List<Post>> getFavoritePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritePostsString = prefs.getString(_favoritesKey);
    if (favoritePostsString == null) {
      return [];
    }
    final List<dynamic> favoritePostsJson = jsonDecode(favoritePostsString);
    return favoritePostsJson.map((json) => Post.fromJson(json)).toList();
  }

  Future<void> addFavoritePost(Post post) async {
    final prefs = await SharedPreferences.getInstance();
    _favoritePosts.add(post);
    final favoritePostsString = jsonEncode(_favoritePosts);
    await prefs.setString(_favoritesKey, favoritePostsString);
    notifyListeners(); 
    print('Added favorite: ${post.title}');
  }

  Future<void> removeFavoritePost(Post post) async {
    final prefs = await SharedPreferences.getInstance();
    _favoritePosts.removeWhere((favoritePost) => favoritePost.id == post.id);
    final favoritePostsString = jsonEncode(_favoritePosts);
    await prefs.setString(_favoritesKey, favoritePostsString);
    notifyListeners(); 
    print('Removed favorite: ${post.title}');
  }

  Future<bool> isFavorite(Post post) async {
    return _favoritePosts.any((favoritePost) => favoritePost.id == post.id);
  }
}
