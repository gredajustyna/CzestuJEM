abstract class SearchEvent{
  final String? name;
  const SearchEvent({this.name});
}

class SearchFood extends SearchEvent{
  const SearchFood(String name) : super(name: name);
}