// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../modules/person_model.dart';

const String boxName = 'persons';
ValueNotifier<List<Person>> personNotifier = ValueNotifier([]);
Future<void> addPerson(Person person) async {
  var box = await Hive.openBox<Person>(boxName);
  await box.put('person', person);
  getPerson();
  personNotifier.notifyListeners();
  print('Person added: ${person.name}');
}

Person? getPerson() {
  var box = Hive.box<Person>(boxName);
  personNotifier.value = box.values.toList();
  personNotifier.notifyListeners();
  return null;
}

Future<void> updatePerson(Person person) async {
  var box = Hive.box<Person>(boxName);
  await box.put('person', person);
}

Future<void> deletePerson() async {
  var box = Hive.box<Person>(boxName);
  await box.delete('person');
}

