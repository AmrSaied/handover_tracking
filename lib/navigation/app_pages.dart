import 'package:get/get.dart';
import 'package:handover_tacking_task/presentation/map/map_screen.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.mapRoute;

  static final routes = [
    GetPage(
      name: Routes.mapRoute,
      page: () => const MapScreen(),
    ),
  ];
}
