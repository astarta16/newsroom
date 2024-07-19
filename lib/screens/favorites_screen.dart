import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<FavoriteService>(
        builder: (context, favoriteService, child) {
          if (favoriteService.favoritePosts.isEmpty) {
            return const Center(child: Text('No favorite posts'));
          } else {
            return ListView.builder(
              itemCount: favoriteService.favoritePosts.length,
              itemBuilder: (context, index) {
                final post = favoriteService.favoritePosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(post.title),
                    onTap: () {
                      GoRouter.of(context).push('/post_detail', extra: post);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
