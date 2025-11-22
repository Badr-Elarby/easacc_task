/// Device Data Source
///
/// Defines the contract for device scanning operations.
/// Implementations handle Bluetooth and WiFi device discovery.

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceException implements Exception {
  final String message;
  DeviceException(this.message);
  @override
  String toString() => message;
}

abstract class DeviceDataSource {
  /// Scan for nearby Bluetooth devices
  Future<List<String>> scanBluetoothDevices();

  /// Scan for nearby WiFi networks
  Future<List<String>> scanWifiDevices();
}

class DeviceDataSourceImpl implements DeviceDataSource {
  @override
  Future<List<String>> scanBluetoothDevices() async {
    try {
      // 1. Check Platform
      if (!Platform.isAndroid && !Platform.isIOS) {
        return []; // Return empty for unsupported platforms
      }

      // 2. Request Permissions Safely
      try {
        if (Platform.isAndroid) {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.bluetoothScan,
            Permission.bluetoothConnect,
            Permission.location,
          ].request();

          if (statuses.values.any((status) => !status.isGranted)) {
            throw DeviceException('Bluetooth permissions denied');
          }
        }
      } catch (e) {
        throw DeviceException('Failed to request permissions: ${e.toString()}');
      }

      // 3. Check Support & State
      try {
        if (await FlutterBluePlus.isSupported == false) {
          throw DeviceException('Bluetooth is not supported on this device');
        }

        // Check if Bluetooth is ON
        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState != BluetoothAdapterState.on) {
          // Try to turn it on (Android only)
          if (Platform.isAndroid) {
            try {
              await FlutterBluePlus.turnOn();
              // Wait for it to turn on
              await FlutterBluePlus.adapterState
                  .where((s) => s == BluetoothAdapterState.on)
                  .first
                  .timeout(const Duration(seconds: 3));
            } catch (e) {
              throw DeviceException('Bluetooth is disabled. Please enable it.');
            }
          } else {
            throw DeviceException('Bluetooth is disabled. Please enable it.');
          }
        }
      } catch (e) {
        if (e is DeviceException) rethrow;
        throw DeviceException('Bluetooth error: ${e.toString()}');
      }

      // 4. Start Scan Safely
      try {
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 4),
          androidUsesFineLocation: true,
        );
      } catch (e) {
        throw DeviceException(
          'Failed to start Bluetooth scan. Is location enabled?',
        );
      }

      // 5. Wait for results
      await Future.delayed(const Duration(seconds: 4));

      // 6. Get Results
      List<ScanResult> results = [];
      try {
        results = FlutterBluePlus.lastScanResults;
        await FlutterBluePlus.stopScan();
      } catch (e) {
        // Ignore stop scan errors
      }

      // 7. Process Results
      final Set<String> uniqueDevices = {};
      for (var r in results) {
        String name = r.device.platformName;
        if (name.isEmpty) name = r.device.name;
        if (name.isNotEmpty) {
          uniqueDevices.add(name);
        }
      }

      // Return empty list if none found (UI will handle "No devices found")
      return uniqueDevices.toList();
    } on DeviceException {
      rethrow;
    } catch (e) {
      throw DeviceException('Unexpected Bluetooth error: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> scanWifiDevices() async {
    try {
      // 1. Check Platform
      if (!Platform.isAndroid && !Platform.isIOS) {
        return [];
      }

      // 2. Request Permissions
      try {
        if (Platform.isAndroid) {
          final status = await Permission.location.request();
          if (!status.isGranted) {
            throw DeviceException(
              'Location permission required for WiFi scanning',
            );
          }
        }
      } catch (e) {
        throw DeviceException('Failed to request location permission');
      }

      // 3. Check Capability
      try {
        final canScan = await WiFiScan.instance.canStartScan();
        if (canScan != CanStartScan.yes) {
          switch (canScan) {
            case CanStartScan.noLocationPermissionRequired:
              throw DeviceException('Location permission required');
            case CanStartScan.noLocationPermissionDenied:
              throw DeviceException('Location permission denied');
            case CanStartScan.noLocationServiceDisabled:
              throw DeviceException('Location services are disabled');
            case CanStartScan.failed:
              throw DeviceException('WiFi scan failed to start');
            default:
              throw DeviceException('Cannot start WiFi scan: $canScan');
          }
        }
      } catch (e) {
        if (e is DeviceException) rethrow;
        // If we can't check capability, try scanning anyway or fail safe
        throw DeviceException('Unable to verify WiFi capability');
      }

      // 4. Start Scan
      try {
        final result = await WiFiScan.instance.startScan();
        if (!result) {
          throw DeviceException('Failed to trigger WiFi scan');
        }
      } catch (e) {
        if (e is DeviceException) rethrow;
        throw DeviceException('WiFi scan error: ${e.toString()}');
      }

      // 5. Wait
      await Future.delayed(const Duration(seconds: 2));

      // 6. Get Results
      try {
        final networks = await WiFiScan.instance.getScannedResults();

        final Set<String> uniqueSsids = {};
        for (var network in networks) {
          if (network.ssid.isNotEmpty) {
            uniqueSsids.add(network.ssid);
          }
        }
        return uniqueSsids.toList();
      } catch (e) {
        throw DeviceException('Failed to retrieve WiFi results');
      }
    } on DeviceException {
      rethrow;
    } catch (e) {
      throw DeviceException('Unexpected WiFi error: ${e.toString()}');
    }
  }
}
