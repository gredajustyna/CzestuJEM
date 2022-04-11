import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_bloc.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_bloc.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_bloc.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_bloc.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_bloc.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_bloc.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'config/routes/routes.dart';
import 'config/themes/themes.dart';
import 'core/utils/constants.dart';
import 'injector.dart';
import 'package:location/location.dart';
import 'core/utils/globals.dart' as globals;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
  _locationData = await location.getLocation();
  globals.location = _locationData;

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => injector<LoginBloc>()
      ),
      BlocProvider(
          create: (_) => injector<RegisterBloc>()
      ),
      BlocProvider(
          create: (_) => injector<ResetPasswordBloc>()
      ),
      BlocProvider(
          create: (_) => injector<GetFavouritesBloc>()
      ),
      BlocProvider(
          create: (_) => injector<GetFridgeBloc>()
      ),
      BlocProvider(
          create: (_) => injector<FoodBloc>()
      ),
      BlocProvider(
          create: (_) => injector<FoodByRadiusBloc>()
      ),
      BlocProvider(
          create: (_) => injector<UserDataBloc>()
      ),
      BlocProvider(
          create: (_) => injector<TopUsersBloc>()
      ),
      BlocProvider(
          create: (_) => injector<SearchBloc>()
      ),
      BlocProvider(
          create: (_) => injector<ConversationUsersBloc>()
      ),
      BlocProvider(
          create: (_) => injector<MessagesBloc>()
      ),
    ],
    child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: kMaterialAppTitle,
          onGenerateRoute: Routes.onGenerateRoutes,
          theme: Themes.light,
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}
