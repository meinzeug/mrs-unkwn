import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/monitoring_alert_service.dart';

class _TestAlertService extends MonitoringAlertService {
  int deliveries = 0;

  @override
  Future<void> deliver(MonitoringAlert alert) async {
    deliveries++;
  }
}

void main() {
  test('prevents duplicate alerts within cooldown', () async {
    final service = _TestAlertService();
    await service.trigger(
      MonitoringAlertType.screenTimeLimitExceeded,
      message: 'limit exceeded',
    );
    await service.trigger(
      MonitoringAlertType.screenTimeLimitExceeded,
      message: 'limit exceeded',
    );
    expect(service.history.length, 1);
    expect(service.deliveries, 1);
  });
}
