import 'dart:async';
import 'dart:convert';
import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/models/name_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'event.dart';

part 'state.dart';

class NamesBloc extends Bloc<NamesEvent, NamesState> {
  List<NameModel> names = [];

  NamesBloc() : super(NamesInitial()) {
    on<LoadNames>(_loadCategories);
  }

  FutureOr<void> _loadCategories(
      LoadNames event, Emitter<NamesState> emit) async {
    if (names.isNotEmpty) {
      emit(NamesLoadSuccess(names));
      return;
    }
    emit(NamesLoading());
    names = await rootBundle
        .loadString("assets/json/names_of_allah.json")
        .then((data) {
      List<dynamic>? response = json.decode(data);
      print(response);
      if (response == null) {
        emit(NamesLoadFailed(Exception("Couldn't load categories")));
      }
      final List<NameModel> res =
          response!.map((e) => NameModel.fromJson(e)).toList();
      return res;
    }).catchError((error) {
      return print(error.toString());
    });
    emit(NamesLoadSuccess(names));
  }
}