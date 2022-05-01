import 'package:czestujem/data/repositories/app_repository_impl.dart';
import 'package:czestujem/domain/repositories/app_repository.dart';
import 'package:czestujem/domain/usecases/add_food_usecase.dart';
import 'package:czestujem/domain/usecases/add_to_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/check_if_favourite_usecase.dart';
import 'package:czestujem/domain/usecases/confirm_reservation_usecase.dart';
import 'package:czestujem/domain/usecases/delete_food_usecase.dart';
import 'package:czestujem/domain/usecases/delete_rate_usecase.dart';
import 'package:czestujem/domain/usecases/delete_reservation_usecase.dart';
import 'package:czestujem/domain/usecases/get_all_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/get_all_messages_usecase.dart';
import 'package:czestujem/domain/usecases/get_conversation_users_usecase.dart';
import 'package:czestujem/domain/usecases/get_food_by_radius_usecase.dart';
import 'package:czestujem/domain/usecases/get_last_message_usecase.dart';
import 'package:czestujem/domain/usecases/get_my_food_usecase.dart';
import 'package:czestujem/domain/usecases/get_rating_usecase.dart';
import 'package:czestujem/domain/usecases/get_top_users_usecase.dart';
import 'package:czestujem/domain/usecases/get_user_from_uid%20_usecase.dart';
import 'package:czestujem/domain/usecases/get_username_from_uid_usecase.dart';
import 'package:czestujem/domain/usecases/get_users_to_rate_usecase.dart';
import 'package:czestujem/domain/usecases/login_usecase.dart';
import 'package:czestujem/domain/usecases/rate_user_usecase.dart';
import 'package:czestujem/domain/usecases/read_messages_usecase.dart';
import 'package:czestujem/domain/usecases/register_usecase.dart';
import 'package:czestujem/domain/usecases/remove_from_favourites_usecase.dart';
import 'package:czestujem/domain/usecases/reserve_food_usecase.dart';
import 'package:czestujem/domain/usecases/reset_password_usecase.dart';
import 'package:czestujem/domain/usecases/search_food_usecase.dart';
import 'package:czestujem/domain/usecases/send_message_usecase.dart';
import 'package:czestujem/domain/usecases/update_user_data_usecase.dart';
import 'package:czestujem/presentation/blocs/confirm_reservstion_bloc/confirm_reservation_bloc.dart';
import 'package:czestujem/presentation/blocs/conversation_users_bloc/conversation_users_bloc.dart';
import 'package:czestujem/presentation/blocs/delete_reservation_bloc/delete_reservation_bloc.dart';
import 'package:czestujem/presentation/blocs/favourite_bloc/favourite_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/delete_food_bloc.dart';
import 'package:czestujem/presentation/blocs/food_bloc/food_bloc.dart';
import 'package:czestujem/presentation/blocs/fridge_bloc/fridge_bloc.dart';
import 'package:czestujem/presentation/blocs/get_user_bloc/get_user_bloc.dart';
import 'package:czestujem/presentation/blocs/get_username_bloc/get_username_bloc.dart';
import 'package:czestujem/presentation/blocs/get_users_to_rate_bloc/get_users_to_rate_bloc.dart';
import 'package:czestujem/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:czestujem/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:czestujem/presentation/blocs/rate_user_bloc/rate_user_bloc.dart';
import 'package:czestujem/presentation/blocs/rating_bloc/rating_bloc.dart';
import 'package:czestujem/presentation/blocs/register_bloc/register_bloc.dart';
import 'package:czestujem/presentation/blocs/reserve_food_bloc/reserve_food_bloc.dart';
import 'package:czestujem/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:czestujem/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:czestujem/presentation/blocs/top_users_bloc/top_users_bloc.dart';
import 'package:czestujem/presentation/blocs/user_data_bloc/user_data_bloc.dart';
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
  injector.registerSingleton<GetFoodByRadiusUseCase>(GetFoodByRadiusUseCase(injector()));
  injector.registerSingleton<UpdateUserDataUseCase>(UpdateUserDataUseCase(injector()));
  injector.registerSingleton<GetTopUsersUseCase>(GetTopUsersUseCase(injector()));
  injector.registerSingleton<SearchFoodUseCase>(SearchFoodUseCase(injector()));
  injector.registerSingleton<GetConversationUsersUseCase>(GetConversationUsersUseCase(injector()));
  injector.registerSingleton<GetAllMessagesUseCase>(GetAllMessagesUseCase(injector()));
  injector.registerSingleton<SendMessageUseCase>(SendMessageUseCase(injector()));
  injector.registerSingleton<GetUserFromUidUseCase>(GetUserFromUidUseCase(injector()));
  injector.registerSingleton<ReserveFoodUseCase>(ReserveFoodUseCase(injector()));
  injector.registerSingleton<GetUsersToRateUseCase>(GetUsersToRateUseCase(injector()));
  injector.registerSingleton<RateUserUseCase>(RateUserUseCase(injector()));
  injector.registerSingleton<DeleteFoodUseCase>(DeleteFoodUseCase(injector()));
  injector.registerSingleton<GetLastMessageUseCase>(GetLastMessageUseCase(injector()));
  injector.registerSingleton<DeleteRateUseCase>(DeleteRateUseCase(injector()));
  injector.registerSingleton<ReadMessagesUseCase>(ReadMessagesUseCase(injector()));
  injector.registerSingleton<DeleteReservationUseCase>(DeleteReservationUseCase(injector()));
  injector.registerSingleton<ConfirmReservationUseCase>(ConfirmReservationUseCase(injector()));

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
  injector.registerFactory<FoodByRadiusBloc>(() => FoodByRadiusBloc(injector()));
  injector.registerFactory<UserDataBloc>(() => UserDataBloc(injector()));
  injector.registerFactory<TopUsersBloc>(() => TopUsersBloc(injector()));
  injector.registerFactory<SearchBloc>(() => SearchBloc(injector()));
  injector.registerFactory<ConversationUsersBloc>(() => ConversationUsersBloc(injector()));
  injector.registerFactory<MessagesBloc>(() => MessagesBloc(injector(), injector(), injector()));
  injector.registerFactory<GetUserBloc>(() => GetUserBloc(injector()));
  injector.registerFactory<ReserveFoodBloc>(() => ReserveFoodBloc(injector()));
  injector.registerFactory<GetUsersToRateBloc>(() => GetUsersToRateBloc(injector()));
  injector.registerFactory<RateUserBloc>(() => RateUserBloc(injector(), injector()));
  injector.registerFactory<DeleteFoodBloc>(() => DeleteFoodBloc(injector()));
  injector.registerFactory<GetLastMessageBloc>(() => GetLastMessageBloc(injector()));
  injector.registerFactory<ConfirmReservationBloc>(() => ConfirmReservationBloc(injector()));
  injector.registerFactory<DeleteReservationBloc>(() => DeleteReservationBloc(injector()));
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}