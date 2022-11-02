import 'dart:async';
import 'dart:convert';
import 'package:azkar/src/core/models/category_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'event.dart';

part 'state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  List<CategoryModel> categories = [];

  QuotesBloc() : super(QuotesInitial()) {
    on<LoadQuotes>(_loadCategories);
  }

  FutureOr<void> _loadCategories(
      LoadQuotes event, Emitter<QuotesState> emit) async {
    if (categories.isNotEmpty) {
      emit(QuotesLoadSuccess(categories));
      return;
    }
    emit(QuotesLoading());
    categories =
        await rootBundle.loadString("assets/json/azkar.json").then((data) {
      List<dynamic>? response = json.decode(data);
      print(response);
      if (response == null) {
        emit(QuotesLoadFailed(Exception("Couldn't load categories")));
      }
      final List<CategoryModel> res =
          response!.map((e) => CategoryModel.fromJson(e)).toList();
      return res;
    }).catchError((error) {
      return print(error.toString());
    });
    emit(QuotesLoadSuccess(categories));
  }
}