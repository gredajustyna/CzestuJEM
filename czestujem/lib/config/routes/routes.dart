import 'package:czestujem/presentation/views/login_register/login_view.dart';
import 'package:czestujem/presentation/views/login_register/register_success_view.dart';
import 'package:czestujem/presentation/views/login_register/register_view.dart';
import 'package:czestujem/presentation/views/main_view.dart';
import 'package:czestujem/presentation/views/start_view.dart';
import 'package:czestujem/presentation/views/user_cards/favourites_view.dart';
import 'package:czestujem/presentation/views/user_cards/fridge_view.dart';
import 'package:czestujem/presentation/views/user_cards/rate_users_view.dart';
import 'package:czestujem/presentation/views/user_cards/reservations_view.dart';
import 'package:czestujem/presentation/views/user_cards/settings_view.dart';
import 'package:flutter/material.dart';

class Routes{
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(StartView());
      case '/login':
        return _materialRoute(LoginView());
      case '/register':
        return _materialRoute(RegisterView());
      case '/registersuccess':
        return _materialRoute(RegisterSuccessView());
      case '/main':
        return _materialRoute(MainView());
      case '/favourites':
        return _createAnimatedRouteRight(FavouritesView());
      case '/fridge':
        return _createAnimatedRouteRight(FridgeView());
      case '/settings':
        return _createAnimatedRouteRight(SettingsView());
      case '/reservations':
        return _createAnimatedRouteRight(ReservationsView());
      case '/rateUsers':
        return _createAnimatedRouteRight(RateUsersView());
      default:
        return null;
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> _createAnimatedRouteRight(Widget view) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0);
        const end = Offset(0, 0);
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }


  static Route<dynamic> _createAnimatedRouteDown(Widget view) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset(0, 0);
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

}