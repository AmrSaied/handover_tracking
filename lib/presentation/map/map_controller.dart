import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover_tacking_task/core/constants.dart';
import 'package:handover_tacking_task/core/services/notification_service.dart';

class MapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final NotificationService _notificationService;
  late AnimationController animationController;
  late Tween<Offset> offsetAnimation;


  MapController(this._notificationService);

  GoogleMapController? mapController;
  late CameraPosition initialCameraPosition;
  late BitmapDescriptor _destinationIcon;

  final pickupLatLng = const LatLng(30.562036587630928, 31.159306557095796).obs;
  final driverLatLng = const LatLng(30.63842255923878, 31.086370775842106).obs;
  final deliveryLatLng =
      const LatLng(30.781089080201063, 30.996081366046194).obs;

  final showTripPolyLine = RxBool(false);
  final bearing = RxDouble(0.0);
  final position = RxDouble(0.0);
  final markers = <String, Marker>{}.obs;
  final polyLines = <PolylineId, Polyline>{}.obs;
  final coordinates = <LatLng>[].obs;
  final distance = RxDouble(0.0);

  final pickupReached = RxBool(false);
  final destinationReached = RxBool(false);
  final driverOnWay = RxBool(false);
  final nearDelivery = RxBool(false);
  final nearDelivery100M = RxBool(false);
  final nearPickup100M = RxBool(false);
  final nearPickup5km = RxBool(false);

  final confirmRate = RxBool(false);

  late Timer _timer;

  void onSubmit() {
    confirmRate(true);
    markers.clear();
    markers.addAll({
      "destination": Marker(
        markerId: const MarkerId("destination"),
        position: deliveryLatLng.value,
        flat: true,
        icon: _destinationIcon,
        anchor: const Offset(0.5, 0.5),
      ),
    });
  }

  Future<void> getPolyPoints(
    LatLng destLocation,
  ) async {
    try {
      coordinates.clear();
      PolylinePoints polyLinePoints = PolylinePoints();
      PolylineResult polylineResult =
          await polyLinePoints.getRouteBetweenCoordinates(
        Constants.mapKey,
        PointLatLng(driverLatLng.value.latitude, driverLatLng.value.longitude),
        PointLatLng(
          destLocation.latitude,
          destLocation.longitude,
        ),
        travelMode: TravelMode.driving,
      );

      debugPrint('points====================${polylineResult.points}');
      if (polylineResult.points.isNotEmpty) {
        for (final point in polylineResult.points) {
          coordinates.add(
            LatLng(point.latitude, point.longitude),
          );
          update();
        }
        debugPrint('cooordintes::::::::::::::::::::::: $coordinates');
        const id = PolylineId('1');
        Polyline poly = Polyline(
          polylineId: id,
          points: coordinates,
          color: Colors.deepOrange,
          visible: true,
          endCap: Cap.buttCap,
          startCap: Cap.roundCap,
          width: 4,
        );
        polyLines[id] = poly;
        debugPrint('polylines::::::::::::: $polyLines');
        // update();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> updatePolyline(bool isDestination, LatLng? point) async {
    if (coordinates.isEmpty && point != null && isDestination) {
      await getPolyPoints(point);
      return;
    }
    coordinates.removeAt(0);
    double dist = 0.0;
    for (var i = 0; i < coordinates.length - 1; i++) {
      dist += calculateDistance(
          coordinates[i].latitude,
          coordinates[i].longitude,
          coordinates[i + 1].latitude,
          coordinates[i + 1].longitude);
    }
    distance(dist);
    const id = PolylineId('1');
    Polyline poly = Polyline(
      polylineId: id,
      points: coordinates,
      color: Colors.deepOrange,
      visible: true,
      endCap: Cap.buttCap,
      startCap: Cap.roundCap,
      width: 4,
    );
    polyLines[id] = poly;
    update();
  }

  Future<void> addMarkersToMap(
    String markerId,
  ) async {
    markers.remove(markerId);
    LatLng latLng = driverLatLng.value;
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      ),
    );
    markers[markerId] = marker;
    // update();
    if (!showTripPolyLine.value) update();
  }

  Future<void> setupMarkers() async {
    final pickIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/icons/pick_icon.png',
    );
    _destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/icons/distention_icon.png',
    );
    markers.value = <String, Marker>{
      "driver": Marker(
        markerId: const MarkerId("driver"),
        position: driverLatLng.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        ),
      ),
      "pick": Marker(
        markerId: const MarkerId("pick"),
        position: pickupLatLng.value,
        flat: true,
        icon: pickIcon,
        anchor: const Offset(0.5, 0.5),
      ),
      "destination": Marker(
        markerId: const MarkerId("destination"),
        position: deliveryLatLng.value,
        flat: true,
        icon: _destinationIcon,
        anchor: const Offset(0.5, 0.5),
      ),
    };
  }

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    offsetAnimation = Tween<Offset>(
      begin: const Offset(0,.5),
      end: Offset.zero,
    );
    initialCameraPosition = CameraPosition(
      target: deliveryLatLng.value,
      zoom: 8.0,
    );
    showTripPolyLine(true);
    await setupMarkers();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _handlerDriverMovement(
    LatLng pickup,
    LatLng delivery,
  ) async {
    driverOnWay(true);
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final polyline = polyLines[const PolylineId('1')];
      if(polyline == null)return;
        if (polyline.points.isEmpty && showTripPolyLine.isFalse) {
        timer.cancel();
        return;
      }
      if(polyline.points.isEmpty)return;
      polyline.points.removeAt(0);
      final newLocation = polyLines[const PolylineId('1')]!.points.firstOrNull;
      if (coordinates.length > 1) {
        driverLatLng.value = LatLng(
          newLocation!.latitude,
          newLocation.longitude,
        );
      } else {
        pickupReached(true);
      }
      addMarkersToMap('driver');
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 12,
            target: LatLng(
              driverLatLng.value.latitude,
              driverLatLng.value.longitude,
            ),
          ),
        ),
      );

      if (pickupReached.value) {
        await updatePolyline(true, delivery);
      } else {
        updatePolyline(false, null);
      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    once(nearDelivery, _nearDelivery5km);
    once(nearPickup5km, _nearPickup5km);
    once(destinationReached, _onDestinationReached);
    once(driverOnWay, _onDriverMoved);
    ever(driverLatLng, _onDriverReachedFinalDest);
    once(pickupReached, _onPickupReached);
    ever(distance, _onDistanceChanged);
    await Future.delayed(const Duration(seconds: 5));
    await getPolyPoints(pickupLatLng.value);
    _handlerDriverMovement(pickupLatLng.value, deliveryLatLng.value);
  }

  Future<void> _onDriverMoved(bool _) async {
    await _notificationService.showNotification(
      'Hangover',
      'driver on his way',
    );
  }

  Future<void> _nearDelivery5km(bool _) async {
    await _notificationService.showNotification(
      'Hangover',
      'the driver is near the delivery destination',
    );
  }

  Future<void> _nearPickup5km(bool _) async {
    await _notificationService.showNotification(
      'Hangover',
      'the driver is near the pickup destination',
    );
  }

  Future<void> _onDestinationReached(bool _) async {
    await _notificationService.showNotification(
      'Hangover',
      'the driver has arrived to the delivery destination',
    );
  }

  Future<void> _onDistanceChanged(double value) async {
    if (pickupReached.isTrue) {
      if (4 < distance.value && distance.value < 5) {
        nearDelivery(true);
      } else if (0.08 < distance.value && distance.value < 0.110) {
        nearDelivery100M(true);
      } else if (distance.value == 0) {
        destinationReached(true);
      }
    } else {
      if (4 < distance.value && distance.value < 5) {
        nearPickup5km(true);
      } else if (0.08 < distance.value && distance.value < 0.110) {
        nearPickup100M(true);
      }
    }
  }

  Future<void> _onPickupReached(bool reached) async {
    await _notificationService.showNotification(
      'Hangover',
      'the driver has arrived to the pick up destination',
    );
  }

  void _onDriverReachedFinalDest(LatLng value) {
    final isSameLat = value.latitude.toStringAsFixed(2) ==
        deliveryLatLng.value.latitude.toStringAsFixed(2);
    final isSameLng = value.longitude.toStringAsFixed(2) ==
        deliveryLatLng.value.longitude.toStringAsFixed(2);
    showTripPolyLine.value = !(isSameLng && isSameLat);
  }

  @override
  void onClose() {
    _timer.cancel();
    mapController?.dispose();
    animationController.dispose();
    super.onClose();
  }
}
