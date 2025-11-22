import 'package:bloc/bloc.dart';
import '../../../data/datasources/device_data_source.dart';
import '../../../data/repositories/device_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final DeviceRepository _deviceRepository;

  SettingsCubit(this._deviceRepository) : super(const SettingsState());

  void saveUrl(String url) {
    emit(state.copyWith(savedUrl: url));
  }

  Future<void> scanBluetoothDevices() async {
    emit(
      state.copyWith(
        bluetoothStatus: DeviceStatus.loading,
        bluetoothError: null, // Clear previous error
      ),
    );

    try {
      final devices = await _deviceRepository.scanBluetoothDevices();
      emit(
        state.copyWith(
          bluetoothStatus: DeviceStatus.success,
          bluetoothDevices: devices,
        ),
      );
    } on DeviceException catch (e) {
      emit(
        state.copyWith(
          bluetoothStatus: DeviceStatus.error,
          bluetoothError: e.message,
          bluetoothDevices:
              [], // Clear list on error or keep previous? User said "return empty list safely"
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          bluetoothStatus: DeviceStatus.error,
          bluetoothError: 'Unexpected Bluetooth error',
          bluetoothDevices: [],
        ),
      );
    }
  }

  Future<void> scanWifiNetworks() async {
    emit(state.copyWith(wifiStatus: DeviceStatus.loading, wifiError: null));

    try {
      final networks = await _deviceRepository.scanWifiDevices();
      emit(
        state.copyWith(
          wifiStatus: DeviceStatus.success,
          wifiNetworks: networks,
        ),
      );
    } on DeviceException catch (e) {
      emit(
        state.copyWith(
          wifiStatus: DeviceStatus.error,
          wifiError: e.message,
          wifiNetworks: [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          wifiStatus: DeviceStatus.error,
          wifiError: 'Unexpected WiFi error',
          wifiNetworks: [],
        ),
      );
    }
  }
}
