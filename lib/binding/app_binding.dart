import 'package:get/get.dart';
import 'package:handover_tacking_task/core/services/notification_service.dart';
import 'package:handover_tacking_task/presentation/map/map_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationService());
    Get.put(MapController(Get.find<NotificationService>()));
  }
}
