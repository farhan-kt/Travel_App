import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/db/model/data_model.dart';
import 'package:travel_app/widgets/edit.dart';

ValueNotifier<List<TripModel>> ongoingTripsListNotifier = ValueNotifier([]);
ValueNotifier<List<TripModel>> upcomingTripsListNotifier = ValueNotifier([]);

Future<void> addOngoingTrip(TripModel value) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');

  final _onId = await tripDB.add(value);
  value.id = _onId;
  ongoingTripsListNotifier.value.add(value);

  ongoingTripsListNotifier.notifyListeners();
}

Future<void> addUpcomingTrip(TripModel value) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');

  final _upId = await tripDB.add(value);
  value.id = _upId;

  upcomingTripsListNotifier.value.add(value);

  upcomingTripsListNotifier.notifyListeners();
}

Future<void> getAllTrip() async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  ongoingTripsListNotifier.value.clear();
  upcomingTripsListNotifier.value.clear();

  final List<TripModel> allTrips = tripDB.values.toList();

  for (TripModel trip in allTrips) {
    if (isTripOngoing(trip)) {
      ongoingTripsListNotifier.value.add(trip);
    } else {
      upcomingTripsListNotifier.value.add(trip);
    }
  }

  ongoingTripsListNotifier.notifyListeners();
  upcomingTripsListNotifier.notifyListeners();
}

bool isTripOngoing(TripModel trip) {
  DateTime startingDateTime = DateFormat('dd-MM-yyyy').parse(trip.startingDate);
  return startingDateTime.isBefore(DateTime.now());
}

Future<void> deleteTrip(int id) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  tripDB.delete(id);
  getAllTrip();
}

Future<void> editTrip(int id, TripModel editTripsValues) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.putAt(id, editTripsValues);
  print(editTripsValues);
  await getAllTrip();
  ongoingTripsListNotifier.notifyListeners();
}
