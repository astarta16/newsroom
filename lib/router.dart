import 'package:go_router/go_router.dart';
import 'screens/main_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/note_detail_screen.dart';
import 'models/post.dart';
import 'models/note.dart';
import 'screens/notes_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/posts',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/posts',
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) => const MainScreen(tabIndex: 0),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const MainScreen(tabIndex: 1),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => NotesScreen(),
    ),
    GoRoute(
      path: '/post_detail',
      builder: (context, state) {
        final post = state.extra as Post;
        return PostDetailScreen(post: post);
      },
    ),
    GoRoute(
      path: '/note_detail',
      builder: (context, state) {
        final note = state.extra as Note?;
        return NoteDetailScreen(note: note);
      },
    ),
  ],
);
