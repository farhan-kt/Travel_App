import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/db/model/data_model.dart';

ValueNotifier<List<TripModel>> ongoingTripsListNotifier = ValueNotifier([]);
ValueNotifier<List<TripModel>> upcomingTripsListNotifier = ValueNotifier([]);
ValueNotifier<List<TripModel>> successTripsListNotifier = ValueNotifier([]);

Future<void> addTrip(TripModel value) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  final _id = await tripDB.add(value);
  value.id = _id;
  DateTime startingDateTime =
      DateFormat('dd-MM-yyyy').parse(value.startingDate);
  DateTime endingDateTime = DateFormat('dd-MM-yyyy').parse(value.endingDate);
  DateTime now = DateTime.now();
// ongoingList Added
  if (startingDateTime.isBefore(now) && endingDateTime.isAfter(now)) {
    ongoingTripsListNotifier.value.add(value);
    ongoingTripsListNotifier.notifyListeners();
  }
  // upcomingList Added
  else if (startingDateTime.isAfter(now)) {
    upcomingTripsListNotifier.value.add(value);
    upcomingTripsListNotifier.notifyListeners();
  }
  // SuccessfulList Added
  else if (endingDateTime.isBefore(now)) {
    successTripsListNotifier.value.add(value);
    successTripsListNotifier.notifyListeners();
  }
}

Future<void> getAllTrip() async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  ongoingTripsListNotifier.value.clear();
  upcomingTripsListNotifier.value.clear();
  successTripsListNotifier.value.clear();

  final List<TripModel> allTrips = tripDB.values.toList();

  for (TripModel trip in allTrips) {
    DateTime startingDateTime =
        DateFormat('dd-MM-yyyy').parse(trip.startingDate);
    DateTime endingDateTime = DateFormat('dd-MM-yyyy').parse(trip.endingDate);
    DateTime now = DateTime.now();

    if (endingDateTime.isBefore(now)) {
      successTripsListNotifier.value.add(trip);
    } else if (startingDateTime.isBefore(now) && endingDateTime.isAfter(now)) {
      ongoingTripsListNotifier.value.add(trip);
    } else {
      upcomingTripsListNotifier.value.add(trip);
    }
  }
  ongoingTripsListNotifier.notifyListeners();
  upcomingTripsListNotifier.notifyListeners();
  successTripsListNotifier.notifyListeners();
}

bool isTripOngoing(TripModel trip) {
  DateTime startingDateTime = DateFormat('dd-MM-yyyy').parse(trip.startingDate);
  return startingDateTime.isBefore(DateTime.now());
}

Future<void> deleteTrip(int id) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.deleteAt(id);
  print('deleted');
  getAllTrip();
}

Future<void> editTrip(int id, TripModel value) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.putAt(id, value);
}

Future<void> deleteAllTrip() async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.clear();
  print('All trip deleted');
  getAllTrip();
}
