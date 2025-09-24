import 'package:go_router/go_router.dart';
import 'package:ve_movies_app/app/presentation/views/home/home_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
