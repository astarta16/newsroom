import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Post> _posts = [];
  bool _isLoading = false;
  int _page = 0;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchMorePosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchMorePosts();
      }
    });
  }

  Future<void> _fetchMorePosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Post> newPosts = await PostService().fetchPosts(_page * _limit, _limit);
      setState(() {
        _page++;
        _posts.addAll(newPosts);
      });
    } catch (error) {
      debugPrint(error.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index == _posts.length) {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                Post post = _posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(post.title),
                    onTap: () {
                      GoRouter.of(context).push('/post_detail', extra: post);
                    },
                  ),
                );
              },
            ),
    );
  }
}
