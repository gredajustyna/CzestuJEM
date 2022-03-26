import 'package:czestujem/data/repositories/app_repository_impl.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';
import 'package:czestujem/domain/usecases/add_food_usecase.dart';
import 'package:czestujem/domain/usecases/add_to_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/check_if_favourite_usecase.dart';
import 'package:czestujem/domain/usecases/get_all_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/get_my_food_usecase.dart';
import 'package:czestujem/domain/usecases/get_rating_usecase.dart';
import 'package:czestujem/domain/usecases/get_username_from_uid_usecase.dart';
import 'package:czestujem/domain/usecases/login_usecase.dart';
import 'package:czestujem/domain/usecases/register_usecase.dart';
import 'package:czestujem/domain/usecases/remove_from_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/reset_password_usecase.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_bloc.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_bloc.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_bloc.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_bloc.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_bloc.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  await _initializeFirebase();

  injector.registerSingleton<AppRepository>(AppRepositoryImpl());

  //usecases
  injector.registerSingleton<LoginUseCase>(LoginUseCase(injector()));
  injector.registerSingleton<RegisterUseCase>(RegisterUseCase(injector()));
  injector.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase(injector()));
  injector.registerSingleton<GetUsernameFromUidUseCase>(GetUsernameFromUidUseCase(injector()));
  injector.registerSingleton<CheckIfFavouriteUseCase>(CheckIfFavouriteUseCase(injector()));
  injector.registerSingleton<AddToFavouritesUseCase>(AddToFavouritesUseCase(injector()));
  injector.registerSingleton<RemoveFromFavouritesUseCase>(RemoveFromFavouritesUseCase(injector()));
  injector.registerSingleton<GetAllFavouritesUseCase>(GetAllFavouritesUseCase(injector()));
  injector.registerSingleton<GetMyFoodUseCase>(GetMyFoodUseCase(injector()));
  injector.registerSingleton<GetRatingUseCase>(GetRatingUseCase(injector()));
  injector.registerSingleton<AddFoodUseCase>(AddFoodUseCase(injector()));

  //blocs
  injector.registerFactory<LoginBloc>(() => LoginBloc(injector()));
  injector.registerFactory<RegisterBloc>(() => RegisterBloc(injector()));
  injector.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc(injector()));
  injector.registerFactory<GetUsernameBloc>(() => GetUsernameBloc(injector()));
  injector.registerFactory<CheckFavouriteBloc>(() => CheckFavouriteBloc(injector()));
  injector.registerFactory<FavouriteBloc>(() => FavouriteBloc(injector(), injector()));
  injector.registerFactory<GetFavouritesBloc>(() => GetFavouritesBloc(injector()));
  injector.registerFactory<GetFridgeBloc>(() => GetFridgeBloc(injector()));
  injector.registerFactory<RatingBloc>(() => RatingBloc(injector()));
  injector.registerFactory<FoodBloc>(() => FoodBloc(injector()));
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}