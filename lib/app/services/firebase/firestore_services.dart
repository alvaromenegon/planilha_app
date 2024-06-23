import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/classes/month_data_overview.dart';
import 'package:planilla_android/app/services/file_services.dart';
import 'package:planilla_android/app/core/classes/query.dart';

enum AddBalanceResults { idle, loading, success, invalidData }

enum SaveItemResults { idle, loading, success, noBalance, invalidData }

class FirestoreServices {
  final bool _debugMode = false;

  String get balancePath => _debugMode ? 'testBalance' : 'balance';
  String get dataPath => _debugMode ? 'test' : 'data';

  Future<List<Item>> getAllItems() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final rootSnapshot = await db.collection(dataPath).get();
    List<String> years = [];
    for (var docSnapshot in rootSnapshot.docs) {
      years.add(docSnapshot.id);
    }
    List<Item> items = [];
    try {
      for (var year in years) {
        for (int i = 1; i <= 12; i++) {
          final yearSnapshot =
              await db.collection(dataPath).doc(year).collection('$i').get();
          for (var docSnapshot in yearSnapshot.docs) {
            //print(docSnapshot.id);
            if (docSnapshot.exists) {
              items.add(Item.fromJson(docSnapshot.data()));
            }
          }
        }
      }
    } catch (e) {
      FileServices.writeLog(e.toString());
    }
    return items;
  }

  Future<List<MonthDataOverview>> getYearDataOverview(String year) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    List<MonthDataOverview> yearData = [];
    for (var i = 1; i <= 12; i++) {
      List<Item> monthlyData = [];
      final coll = db.collection(dataPath).doc(year).collection('$i');
      final snapshot = await coll.get();
      if (snapshot.docs.isNotEmpty) {
        monthlyData =
            snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList();
      }
      if (monthlyData.isNotEmpty) {
        num totalEurValue = 0;
        for (var item in monthlyData) {
          totalEurValue += item.eurValue;
        }
        yearData.add(MonthDataOverview(month: '$i', total: totalEurValue));
      }
    }
    return yearData;
  }

  Future<int> saveItem(Item item) async {
    if (!item.preValidate()) {
      return SaveItemResults.invalidData.index;
    }
    final String year = item.date.split('-')[0];
    String month = item.date.split('-')[1];
    if (month[0] == '0') {
      // remove leading zero
      month = month[1];
    }
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef = db.collection(dataPath).doc(year).collection(month);
    //Atualiza os saldos
    item.timestamp = Timestamp.now();
    await docRef.add(item.toJson());
    return SaveItemResults.success.index;
  }

  Future<List<Item>> getItems(String year, String month) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef =
        db.collection(dataPath).doc(year).collection(month).orderBy('date');
    //final docRef = db.collection('test').doc(year).collection(month);
    final data = await docRef.get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs.map((doc) => Item.fromJson(doc.data())).toList();
  }

  Future<List<Item>> getItemsWithQuery(CQuery query) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef =
        db.collection(dataPath).doc(query.year).collection(query.month);
    List<Item> items = [];
    dynamic val;
    if (query.field == 'Valor') {
      try {
        val = num.parse(query.value);
      } on FormatException {
        return items;
      }
    } else {
      val = query.value;
    }
    switch (query.queryOperator) {
      case '==':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field), isEqualTo: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '!=':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field), isNotEqualTo: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '>':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field), isGreaterThan: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '<':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field), isLessThan: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '>=':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field),
                isGreaterThanOrEqualTo: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '<=':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field),
                isLessThanOrEqualTo: val)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      default:
        final data = await docRef.get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
    }
    return items;
  }

  Future<List<int>> importItems(List<Item> data) async {
    List<int> saveResults = [];
    for (int i = 0; i < data.length; i++) {
      Item item = data[i];
      int result = await saveItem(item);
      saveResults.add(result);
      if (result == SaveItemResults.noBalance.index) {
        //Inserir o mesmo resultado para os demais itens
        //Assim não precisa chamar a função de salvamento para cada item
        //E a Lista será usada depois
        //para escrever um novo arquivo com os itens que não foram importados
        for (int j = i + 1; j < data.length; j++) {
          saveResults.add(SaveItemResults.noBalance.index);
        }
      }
    }
    await FileServices.writeImportResult(data, saveResults);
    return saveResults;
  }
}
