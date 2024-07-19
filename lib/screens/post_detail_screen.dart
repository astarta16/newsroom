import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../services/favorite_service.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final isFavorite = await Provider.of<FavoriteService>(context, listen: false).isFavorite(widget.post);
    setState(() {
      _isFavorite = isFavorite;
      _isLoading = false;
      print('Post is favorite: $_isFavorite');
    });
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });
    if (_isFavorite) {
      await Provider.of<FavoriteService>(context, listen: false).removeFavoritePost(widget.post);
    } else {
      await Provider.of<FavoriteService>(context, listen: false).addFavoritePost(widget.post);
    }
    setState(() {
      _isFavorite = !_isFavorite;
      _isLoading = false;
      print('Toggled favorite: $_isFavorite');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: _toggleFavorite,
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.post.body),
      ),
    );
  }
}

