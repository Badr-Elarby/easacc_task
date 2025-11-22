import 'package:equatable/equatable.dart';

enum DeviceStatus { initial, loading, success, error }

class SettingsState extends Equatable {
  final List<String> bluetoothDevices;
  final List<String> wifiNetworks;
  final String? savedUrl;
  final DeviceStatus bluetoothStatus;
  final DeviceStatus wifiStatus;
  final String? bluetoothError;
  final String? wifiError;

  const SettingsState({
    this.bluetoothDevices = const [],
    this.wifiNetworks = const [],
    this.savedUrl,
    this.bluetoothStatus = DeviceStatus.initial,
    this.wifiStatus = DeviceStatus.initial,
    this.bluetoothError,
    this.wifiError,
  });

  SettingsState copyWith({
    List<String>? bluetoothDevices,
    List<String>? wifiNetworks,
    String? savedUrl,
    DeviceStatus? bluetoothStatus,
    DeviceStatus? wifiStatus,
    String? bluetoothError,
    String? wifiError,
  }) {
    return SettingsState(
      bluetoothDevices: bluetoothDevices ?? this.bluetoothDevices,
      wifiNetworks: wifiNetworks ?? this.wifiNetworks,
      savedUrl: savedUrl ?? this.savedUrl,
      bluetoothStatus: bluetoothStatus ?? this.bluetoothStatus,
      wifiStatus: wifiStatus ?? this.wifiStatus,
      bluetoothError: bluetoothError ?? this.bluetoothError,
      wifiError: wifiError ?? this.wifiError,
    );
  }

  @override
  List<Object?> get props => [
    bluetoothDevices,
    wifiNetworks,
    savedUrl,
    bluetoothStatus,
    wifiStatus,
    bluetoothError,
    wifiError,
  ];
}
