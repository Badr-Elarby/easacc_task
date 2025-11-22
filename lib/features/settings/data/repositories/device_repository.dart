/// Device Repository
///
/// Implements the repository pattern for device scanning operations.
/// Acts as a mediator between the presentation layer and data sources.

import '../datasources/device_data_source.dart';

abstract class DeviceRepository {
  /// Scan for Bluetooth devices
  Future<List<String>> scanBluetoothDevices();

  /// Scan for WiFi networks
  Future<List<String>> scanWifiDevices();
}

/// Implementation of DeviceRepository
/// Delegates scanning operations to DeviceDataSource
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource deviceDataSource;

  DeviceRepositoryImpl({required this.deviceDataSource});

  @override
  Future<List<String>> scanBluetoothDevices() async {
    try {
      return await deviceDataSource.scanBluetoothDevices();
    } catch (e) {
      // Rethrow to let Cubit handle the error
      rethrow;
    }
  }

  @override
  Future<List<String>> scanWifiDevices() async {
    try {
      return await deviceDataSource.scanWifiDevices();
    } catch (e) {
      // Rethrow to let Cubit handle the error
      rethrow;
    }
  }
}
