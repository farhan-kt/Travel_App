import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_app/functions/db_functions.dart';
import 'package:travel_app/helper/colors.dart';
import 'package:travel_app/model/trip_model/trip_model.dart';
import 'package:travel_app/widgets/gallerybottomsheet.dart';
import 'package:travel_app/widgets/successful.dart';

class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});

  @override
  Widget build(BuildContext context) {
    getAllTrip();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: GreenColor.green,
          centerTitle: true,
          title: const Text('SUCCESSFUL TRIPS',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: YellowColor.yellow)),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.75,
                width: screenWidth * 0.97,
                child: ValueListenableBuilder(
                  valueListenable: successTripsListNotifier,
                  builder: (BuildContext ctx, List<TripModel> tripList,
                      Widget? child) {
                    if (tripList.isNotEmpty) {
                      return Expanded(
                        child: ListView.separated(
                          itemCount: tripList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (ctx, index) {
                            final data = tripList[index];
                            return SizedBox(
                              height: screenHeight * 0.24,
                              width: screenWidth * 0.97,
                              child: InkWell(
                                child: SuccessfulWidget(
                                  date: data.startingDate,
                                  place: data.endingingPoint,
                                  image: data.image,
                                  endDate: data.endingDate,
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return GalleryWidget(
                                        trip: data,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container(
                        height: screenHeight * 0.24,
                        width: screenWidth * 0.97,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            width: 2,
                            color: Colors.grey,
                          ),
                        ),
                        child: Lottie.asset(
                            'assets/Animation - 1702390293591.json',
                            fit: BoxFit.fill),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
