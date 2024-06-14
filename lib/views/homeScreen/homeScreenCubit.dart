import 'package:denomination/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreenCubit extends Cubit<HomeState> {
  TextEditingController categoryController = TextEditingController(text:"General");
  TextEditingController remarkController = TextEditingController();

  HomeScreenCubit()
      : super(HomeState(calculationList: [
    CalculationModel(
        initialValue: 2000,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 500,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 200,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 100,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 50,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 20,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 10,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 5,
        inputValueController: TextEditingController(),
        finalValue: 0),
    CalculationModel(
        initialValue: 2,
        inputValueController: TextEditingController(),
        finalValue: 0),

    CalculationModel(
        initialValue: 1,
        inputValueController: TextEditingController(),
        finalValue: 0),




  ], denominationList: [])) {

    historyList().then((historyList) {
      debugPrint("historyList:${historyList.length}");
      state.denominationList!.addAll(historyList);
    });

  }


  Future<List<DenominationModel>> historyList() async {
    final db = await sqliteDatabase.getDataBase();
    final List<Map<String, dynamic>> map = await db.query('HISTORY');

    if(map.isEmpty){
      return [];
    }

    return List.generate(map.length, (i) {
      return DenominationModel(
          id: map[i]['id'].toString(),
          category: map[i]['category'],
          remark: map[i]['remark'],
          dateTime: DateTime.parse(map[i]['dateTime']),
          totalValue: double.parse(map[i]['grandTotal']),);
    });
  }


  void updateValue(String value, int index) {
    double inputValue = 0;
    if (value.isNotEmpty) {
      inputValue = double.parse(value);
    } else {
      inputValue = 0;
    }
    state.calculationList![index].finalValue =
        state.calculationList![index].initialValue * inputValue;
    emit(state.copyWith(calculationList: state.calculationList!));
  }

  void saveDenomination(String categoryText, String remarkText) {
    DenominationModel item = DenominationModel(
        id: DateTime
            .now()
            .microsecondsSinceEpoch
            .toString(),
        category: categoryText,
        remark: remarkText,
        dateTime: DateTime.now(),
        totalValue: state.calculationList!.fold(0.0,
                (previousValue, element) =>
            previousValue + element.finalValue));

    state.denominationList!.add(item);
    insertDenomination(item);

    emit(state.copyWith(denominationList: state.denominationList!));
  }

  Future<void> insertDenomination(DenominationModel player) async {
    final db = await sqliteDatabase.getDataBase();

    await db.insert(
      'HISTORY',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      debugPrint("success: $value");
    });
  }


  Future<void> deleteListItem(String id, int index) async {
    debugPrint("id::::::::$id");
    final db = await sqliteDatabase.getDataBase();
    await db.delete("HISTORY", where: "id = ?", whereArgs: [id]).then((value) {
      debugPrint("deletedItem: $value");
    });
    state.denominationList!.removeAt(index);
    emit(state.copyWith(denominationList: state.denominationList));
  }
}

class HomeState {
  List<CalculationModel>? calculationList;
  List<DenominationModel>? denominationList;

  HomeState({this.calculationList, this.denominationList});

  HomeState copyWith({
    List<CalculationModel>? calculationList,
    List<DenominationModel>? denominationList,
  }) {
    return HomeState(
      calculationList: calculationList ?? this.calculationList,
      denominationList: denominationList ?? this.denominationList,
    );
  }
}

class CalculationModel {
  double initialValue = 0.0;
  TextEditingController inputValueController = TextEditingController();
  double finalValue = 0.0;

  CalculationModel({
    required this.initialValue,
    required this.inputValueController,
    required this.finalValue,
  });

  Map<String, String> toMap() =>
      {
        "initial_value": initialValue.toString(),
        "input_value": inputValueController.text,
        "final_value": finalValue.toString(),
      };
}

class DenominationModel {
  String id = "";
  String category = "";
  String remark = "";
  DateTime dateTime;
  double totalValue = 0.0;

  DenominationModel({
    required this.id,
    required this.category,
    required this.remark,
    required this.dateTime,
    required this.totalValue,
  });

  Map<String, String> toMap() =>
      {
        "denominationId": id,
        "category": category,
        "remark": remark,
        "grandTotal": totalValue.toString(),
        "dateTime": dateTime.toString(),
      };



}

extension Currency on double {
  String indianRupeeFormat() {
    return NumberFormat.currency(
        locale: 'en_IN', symbol: '₹ ', decimalDigits: 0)
        .format(this);
  }
}
