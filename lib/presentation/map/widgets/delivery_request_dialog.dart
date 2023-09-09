import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handover_tacking_task/presentation/map/map_controller.dart';

class DeliveryRequestDialog extends GetView<MapController> {
  const DeliveryRequestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(context),
        _buildUserInfo(context),
      ],
    );
  }


  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 96,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 48,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 251, 175, 3),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
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
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 251, 175, 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Amr Saied',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(() {
              return Column(
                children: [
                  _buildStepperItem('On the way', controller.driverOnWay.isTrue),
                  _buildStepperItem('Picked up deliver', controller.pickupReached.isTrue),
                  _buildStepperItem('Near Deliver Destination', controller.nearDelivery.isTrue),
                  _buildStepperItem('Delivery package', controller.destinationReached.isTrue, isLastStep: true),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStepperItem(String stepName, bool isAchieved, {bool isLastStep = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAchieved ? Colors.black : const Color.fromARGB(255, 254, 214, 120),
              ),
            ),
            if (!isLastStep)
              SizedBox(
                height: 20,
                child: VerticalDivider(
                  thickness: 2,
                  color: isAchieved ? Colors.black : const Color.fromARGB(255, 254, 214, 120),
                ),
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            stepName,
            style: TextStyle(
              height: 0.9,
              color: isAchieved ? Colors.black : const Color.fromARGB(255, 254, 214, 120),
            ),
          ),
        )
      ],
    );
  }
}
