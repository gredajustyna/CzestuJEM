abstract class UserDataEvent{
  final Map<String, dynamic>? data;
  const UserDataEvent({this.data});
}

class UpdateUserData extends UserDataEvent{
  const UpdateUserData(Map<String, dynamic> data) :super(data: data);
}