import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handover_tacking_task/presentation/map/map_controller.dart';

class DeliveredSuccessDialog extends GetWidget<MapController> {
  const DeliveredSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 96,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 251, 175, 3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        25,
                      ),
                      topRight: Radius.circular(
                        25,
                      ),
                    ),
                  ),
                ),
              ),
              const Center(
                child: SizedBox(
                  height: 96,
                  width: 96,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://pps.whatsapp.net/v/t61.24694-24/315770834_1154581071856510_6304910095206711638_n.jpg?ccb=11-4&oh=01_AdQfyuU-yUoudvWzJEnh9XwA9f1RgTivhSojWeoYG74apQ&oe=650819C1&_nc_sid=000000&_nc_cat=104',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 251, 175, 3),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  empty: const Icon(Icons.star_rounded, color: Colors.white),
                  full: const Icon(Icons.star_rounded, color: Colors.deepOrange),
                  half: const Icon(Icons.star_half_rounded, color: Colors.deepOrange),
                ),
                itemSize: 60.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              _timeWidget('Pickup Time', '10:00 PM'),
              _timeWidget('Delivery Time', '10:30 PM'),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$30:00',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: controller.onSubmit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );

  }
}

Widget _timeWidget(String timeLabel, String timeValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          timeLabel,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          timeLabel,
        )
      ],
    ),
  );
}
