import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover_tacking_task/presentation/map/map_controller.dart';
import 'package:handover_tacking_task/presentation/map/widgets/delivered_success_dialog.dart';
import 'package:handover_tacking_task/presentation/map/widgets/delivery_request_dialog.dart';

class MapScreen extends GetView<MapController> {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return Positioned(
              top: 0,
              height: controller.confirmRate.isTrue
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: GetBuilder<MapController>(
                  init: controller,
                  builder: (controller) {
                    return GoogleMap(
                      mapType: MapType.terrain,
                      initialCameraPosition: controller.initialCameraPosition,
                      markers: Set<Marker>.of(
                        controller.markers.values,
                      ),
                      polylines: controller.showTripPolyLine.value
                          ? Set<Polyline>.of(controller.polyLines.values)
                          : {},
                      onCameraMoveStarted: () {
                        if (!controller.showTripPolyLine.value) {
                          controller.bearing(controller.position.value);
                        }
                      },
                      onMapCreated: (mapController) {
                        controller.mapController = mapController;
                      },
                      zoomControlsEnabled: false,
                    );
                  }),
            );
          }),
          Obx(
            () => Positioned(
              bottom: 0,
              height: controller.confirmRate.isTrue ? 0 : null,
              child: Opacity(
                opacity: controller.confirmRate.isTrue ? 0 : 1,
                child: SlideTransition(
                  position: controller.offsetAnimation.animate(CurvedAnimation(
                      parent: controller.animationController,
                      curve: Curves.easeIn)),
                  child: (controller.destinationReached.isTrue)
                      ? const DeliveredSuccessDialog()
                      : const DeliveryRequestDialog(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
