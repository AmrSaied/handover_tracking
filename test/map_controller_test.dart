import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handover_tacking_task/core/services/notification_service.dart';
import 'package:handover_tacking_task/presentation/map/map_controller.dart';
import 'package:mockito/mockito.dart';

// Create a mock for the NotificationService
class MockNotificationService extends Mock implements NotificationService {}

class MockPolylinePoints extends Mock implements PolylinePoints {}

void main() {
  late MapController mapController;
  late MockNotificationService mockNotificationService;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockNotificationService = MockNotificationService();
    mapController = MapController(mockNotificationService);
    mapController.onInit();
  });

  /// on user submit the confirm rate is set to true
  /// and only one markers(destination marker) should be shown in the map
  test("Test onSubmit method", () async {
    await mapController.setupMarkers();
    mapController.onSubmit();
    final confirmRate = mapController.confirmRate.value;
    final markers = mapController.markers;
    expect(confirmRate, true);
    expect(markers.length, 1);
  });

  /// test if pickup location is the same as driver location
  /// no polyline points are shown only one point
  test("Test Get Polyline method", () async {
    mapController.driverLatLng(const LatLng(30.0, 31.0));
    await mapController.getPolyPoints(const LatLng(30.0, 31.0));
    final polyLine = mapController.polyLines.values.first;
    expect(polyLine.points.length, 1);
  });

 /// test if the destination is different from driver location
  /// there are multiple polyline points
  test("Test Get Polyline method different points", () async {
    mapController.driverLatLng(const LatLng(30.0, 31.0));
    await mapController.getPolyPoints(const LatLng(30.0, 31.1));
    final polyLine = mapController.polyLines.values.first;
    expect(polyLine.points.length>1, true);
  });
}
