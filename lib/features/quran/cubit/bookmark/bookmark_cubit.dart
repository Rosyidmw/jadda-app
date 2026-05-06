import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/bookmark_model.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitial());

  static const String _bookmarkKey = 'quran_last_read_bookmark';

  Future<void> loadBookmark() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarkJson = prefs.getString(_bookmarkKey);
      print("🔍 [Cek Memori Bookmark]: $bookmarkJson");

      if (bookmarkJson != null) {
        final bookmark = BookmarkModel.fromJson(bookmarkJson);
        emit(BookmarkLoaded(bookmark));
      } else {
        emit(BookmarkLoaded(null));
      }
    } catch (e) {
      print("❌ [Error Load Bookmark]: $e");
      emit(BookmarkLoaded(null));
    }
  }

  Future<void> saveBookmark(BookmarkModel bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bookmarkKey, bookmark.toJson());

    emit(BookmarkLoaded(bookmark));
  }

  Future<void> removeBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarkKey);

    emit(BookmarkLoaded(null));
  }
}
