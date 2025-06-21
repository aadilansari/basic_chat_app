import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/notification_service.dart';

final notificationProvider = Provider((ref) => NotificationService());
