part of 'bookmark_cubit.dart';

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final BookmarkModel? bookmark;

  BookmarkLoaded(this.bookmark);
}
