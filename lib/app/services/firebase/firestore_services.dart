// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/balance.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/classes/month_data_overview.dart';
import 'package:planilla_android/app/core/classes/total_balance.dart';
import 'package:planilla_android/app/core/errors/errors.dart';
import 'package:planilla_android/app/services/file_services.dart';
import 'package:planilla_android/app/util/util.dart';
import 'package:planilla_android/app/core/classes/query.dart';

enum AddBalanceResults { idle, loading, success, invalidData }

enum SaveItemResults { idle, loading, success, noBalance, invalidData }

class FirestoreServices {
  final bool _debugMode = true;

  String get balancePath => _debugMode ? 'testBalance' : 'balance';
  String get dataPath => _debugMode ? 'test' : 'data';

  Future<List<Item>> getAllItems() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final rootSnapshot = await db.collection('data').get();
    List<String> years = [];
    for (var docSnapshot in rootSnapshot.docs) {
      years.add(docSnapshot.id);
    }
    List<Item> items = [];
    try {
      for (var year in years) {
        for (int i = 1; i <= 12; i++) {
          final yearSnapshot =
              await db.collection('data').doc(year).collection('$i').get();
          for (var docSnapshot in yearSnapshot.docs) {
            //print(docSnapshot.id);
            if (docSnapshot.exists) {
              items.add(Item.fromJson(docSnapshot.data()));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return items;
  }

  ///newBalanceID = o id do saldo que será adicionado
  ///
  ///newExcRate = a taxa de câmbio do saldo que será adicionado
  ///e entrará na média ponderada
  ///
  ///newValue = o valor do saldo que será adicionado,
  ///também para utilizar no cálculo da média ponderada.
  ///
  ///Em TS, era um único parâmetro do tipo AvgExcRate,
  ///mas separado para melhor visualização
  Future<num> updateAverageExcRate(
      String newBalanceId, num newExcRate, num newValue) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    //final docRef = db.collection('balance').doc('averageExcRate');
    final docRef = db.collection(balancePath).doc('averageExcRate');
    final data = await docRef.get();
    if (data.exists) {
      final json = data.data() ?? {};
      //final num oldExcRate = json['exchangeRate'];
      print(json);
      final balancesUsed = json['balancesUsed'];
      print(balancesUsed);
      final List<Balance> allBalances = await getBalances();
      //Calcular a média ponderada
      //Encontrar os saldos que estão sendo usados para calcular a média
      //Ou seja, se o balanceId está em balancesUsed
      final List<Balance> balancesToUse = allBalances
          .where((balance) => balancesUsed.contains(balance.balanceId))
          .toList();
      //Obter o somatório dos valores dos saldos que estão sendo usados
      final num sumEurValues = balancesToUse.fold(
          0, (previousValue, element) => previousValue + element.eurValue);
      //Obter o resultado da multiplicação de cada saldo pelo valor da taxa de câmbio
      final num sumExcRates = balancesToUse.fold(
          0, (previousValue, element) => previousValue + element.excRateAtDate);
      //Obter o novo valor do saldo que será adicionado
      final num newSumEurValues = sumEurValues + newValue;
      //Obter o novo valor da multiplicação do saldo pelo valor da taxa de câmbio
      final num newSumExcRates = sumExcRates + (newValue * newExcRate);
      //Calcular a nova taxa de câmbio
      final num updatedExcRate = newSumExcRates / newSumEurValues;

      //Atualizar o documento
      await docRef.update({
        'exchangeRate': Util.roundToPrecision(value: updatedExcRate),
        'balancesUsed': [...balancesUsed, newBalanceId],
        'lastUpdate': Timestamp.now()
      });
      return updatedExcRate;
    }
    return 0;
  }

  Future<int> addBalance(Balance balance) async {
    if (!balance.preValidate()) {
      return AddBalanceResults.invalidData.index;
    }
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    //final docRef = db.collection('balance').doc();
    final coll = db.collection(balancePath);
    final collCount = await coll.count().get();
    final count = collCount.count ?? 0;
    if (count < 2) {
      // < 2 porque há 2 documentos que não são saldos
      return -1;
    }
    balance.balanceId = '${count - 2}';
    balance.currentEurValue = balance.eurValue;
    balance.brlValue =
        Util.roundToPrecision(value: balance.eurValue * balance.excRateAtDate);
    balance.currentBrlValue =
        Util.roundToPrecision(value: balance.eurValue * balance.excRateAtDate);

    try {
      await updateAverageExcRate(
          balance.balanceId, balance.excRateAtDate, balance.eurValue);
      await coll.doc(balance.balanceId).set(balance.toJson());
      await coll.doc('totalBalance').update({
        'totalEurBalance': FieldValue.increment(balance.eurValue),
        'totalBrlBalance':
            FieldValue.increment(balance.eurValue * balance.excRateAtDate)
      });
    } catch (e) {
      print(e);
      return -1;
    }
    return AddBalanceResults.success.index;
  }

  Future<List<MonthDataOverview>> getYearDataOverview(String year) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    List<MonthDataOverview> yearData = [];
    for (var i = 1; i <= 12; i++) {
      List<Item> monthlyData = [];
      final coll = db.collection(dataPath).doc(year).collection('$i');
      //final coll = db.collection('test').doc(year).collection('$i'); //test collection
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

  Future<TotalBalance> getTotalBalance() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef = db
        .collection('testBalance')
        .doc('totalBalance'); //test collection(balance)
    final snapshot = await docRef.get();

    if (!snapshot.exists || snapshot.data() == null) {
      print('Não foi possível encontrar o saldo total.');
      return TotalBalance(totalEurBalance: 0, totalBrlBalance: 0);
    }
    return TotalBalance.fromJson(snapshot.data() ?? {});
  }

  Future<List<Balance>> getBalances() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef =
        //db.collection('balance').where('currentEurValue', isGreaterThan: 0);
        db.collection(balancePath).where('currentEurValue', isGreaterThan: 0);
    final data = await docRef.get();
    if (data.docs.isEmpty) {
      return [];
    }
    return data.docs.map((doc) => Balance.fromJson(doc.data())).toList();
  }

  Future<num> getExchangeRate() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    //final docRef = db.collection('balance').doc('averageExcRate');
    final docRef = db.collection(balancePath).doc('averageExcRate');
    final data = await docRef.get();
    print(data.data());
    if (data.exists) {
      return data.data()?['exchangeRate'];
    }
    return 0;
  }

  Future<TotalBalance> updateBalance(num eurValue) async {
    final List<Balance> balanceList = await getBalances();
    print(balanceList);
    if (balanceList.isEmpty) {
      throw NoBalanceAvailable();
    }
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;

    final Balance currentBalance = balanceList.first;
    final totalBalance = await getTotalBalance();
    final oldEurBalance = totalBalance.totalEurBalance;
    final exchangeRate = await getExchangeRate();
    final newEurBalance =
        Util.roundToPrecision(value: (oldEurBalance - eurValue));
    if (newEurBalance < 0) {
      throw NoBalanceAvailable();
    }
    var newBrlBalance =
        Util.roundToPrecision(value: (newEurBalance * exchangeRate));
    TotalBalance newTotalBalance = TotalBalance(
      totalEurBalance: newEurBalance,
      totalBrlBalance: newBrlBalance,
    );

    if (currentBalance.currentEurValue < eurValue) {
      var valueToNextBalance = eurValue;

      List<Balance> updatedBalanceList = [];
      for (var i = 0; i < balanceList.length; i++) {
        num eurBalanceAvailable = balanceList[i].currentEurValue;
        if ((i == balanceList.length - 1) &&
            (valueToNextBalance > eurBalanceAvailable)) {
          // se não houver mais saldo disponível, cancela a operação
          throw NoBalanceAvailable();
        }
        num changedEurBalance = 0;
        if (eurBalanceAvailable > valueToNextBalance) {
          changedEurBalance = valueToNextBalance;
        } else {
          changedEurBalance = eurBalanceAvailable;
        }
        valueToNextBalance -= changedEurBalance;

        /*updatedBalanceList.add({
                    ...balance[i],
                    currentEurValue: Util.roundToPrecision((eurBalanceAvailable - changedEurBalance), 3),
                    currentBrlValue: Util.roundToPrecision(((eurBalanceAvailable - changedEurBalance) * exchangeRate), 3),
                })*/
        var newBalanceToSave = balanceList[i];
        newBalanceToSave.currentEurValue = Util.roundToPrecision(
            value: (eurBalanceAvailable - changedEurBalance));
        newBalanceToSave.currentBrlValue = Util.roundToPrecision(
            value: ((eurBalanceAvailable - changedEurBalance) * exchangeRate));
        updatedBalanceList.add(newBalanceToSave);

        if (valueToNextBalance == 0) {
          break;
        }
      }
      final batch = db.batch();
      for (var balance in updatedBalanceList) {
        //final balanceRef = db.collection('balance').doc(balance.balanceId);
        final balanceRef = db
            .collection(balancePath)
            .doc(balance.balanceId); //test collection(balance)
        batch.update(balanceRef, balance.toJson());
      }

      /*updatedBalanceList.forEach((balance) => {
                final balanceRef = doc(db, 'balance', balance.balanceId);
                batch.update(balanceRef, balance);
            });*/
      //atualiza os saldos que foram modificados
      await batch.commit();
    } else {
      var currentBalanceCopy = currentBalance;
      currentBalanceCopy.currentEurValue = Util.roundToPrecision(
          value: (currentBalance.currentEurValue - eurValue));
      currentBalanceCopy.currentBrlValue = Util.roundToPrecision(
          value: (currentBalance.currentBrlValue - (eurValue * exchangeRate)));

      final newBalance = currentBalanceCopy.toJson();
      /*{
                ...currentBalance,
                currentEurValue: Util.roundToPrecision((currentBalance.currentEurValue - eurValue), 2),
                currentBrlValue: Util.roundToPrecision((currentBalance.currentBrlValue - (eurValue * exchangeRate)), 2),
            }*/
      //await updateDoc(doc(db, 'balance', '${currentBalance.balanceId}'), newBalance);
      await db
          //.collection('balance')
          .collection('testBalance')
          .doc(currentBalance.balanceId)
          .update(newBalance);
    }
    await db
        //.collection('balance')
        .collection('testBalance')
        .doc('totalBalance')
        .update(newTotalBalance.toJson());
    //final updatedTotalBalance = await getTotalBalance();
    //await updateDoc(doc(db, 'balance', 'totalBalance'), newTotalBalance);
    //final updatedTotalBalance = await getTotalBalance();
    //setTotalBalance(updatedTotalBalance as TotalBalance);
    return newTotalBalance;
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

    final num eurValue = item.eurValue;
    TotalBalance newTotalBalance =
        TotalBalance(totalEurBalance: 0, totalBrlBalance: 0);

    try {
      newTotalBalance = await updateBalance(eurValue);
    } on NoBalanceAvailable {
      return SaveItemResults.noBalance.index;
    }
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    //final docRef = db.collection('data').doc(year).collection(month);
    final docRef = db.collection(dataPath).doc(year).collection(month);
    //Atualiza os saldos
    item.brlValue = item.eurValue * await getExchangeRate();
    item.eurBalance = newTotalBalance.totalEurBalance;
    item.brlBalance = newTotalBalance.totalBrlBalance;
    item.timestamp = Timestamp.now();
    await docRef.add(item.toJson());
    return SaveItemResults.success.index;
  }

  Future<List<Item>> getItems(String year, String month) async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    final docRef = db.collection(dataPath).doc(year).collection(month);
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
    //final docRef = db.collection('data').doc(query.year).collection(query.month);
    final docRef =
        db.collection(dataPath).doc(query.year).collection(query.month);
    List<Item> items = [];
    switch (query.queryOperator) {
      case '==':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field), isEqualTo: query.value)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      case '!=':
        final data = await docRef
            .where(CQuery.fieldConversion(query.field),
                isNotEqualTo: query.value)
            .get();
        if (data.docs.isNotEmpty) {
          items = data.docs.map((doc) => Item.fromJson(doc.data())).toList();
        }
      //TODO: implementar os outros operadores
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
