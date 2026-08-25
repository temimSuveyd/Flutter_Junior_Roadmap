part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class Search extends SearchEvent {
  Search(this.query);
  final String query;
}
