/// Settings Screen
///
/// Presentation layer for device settings and scanning.
/// Provides UI for Bluetooth and WiFi device discovery and URL input for WebView.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubits/settings_cubit/settings_cubit.dart';
import '../cubits/settings_cubit/settings_state.dart';
import '../widgets/bluetooth_section.dart';
import '../widgets/url_input_section.dart';
import '../widgets/wifi_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings'), elevation: 2),
        body: BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            // Handle Bluetooth Errors
            if (state.bluetoothStatus == DeviceStatus.error &&
                state.bluetoothError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.bluetoothError!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            // Handle WiFi Errors
            if (state.wifiStatus == DeviceStatus.error &&
                state.wifiError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.wifiError!),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                // URL Input Section
                UrlInputSection(),

                SizedBox(height: 24),

                // Bluetooth Section
                BluetoothSection(),

                SizedBox(height: 16),

                // WiFi Section
                WifiSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
