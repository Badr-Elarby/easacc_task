import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit/settings_cubit.dart';
import '../cubits/settings_cubit/settings_state.dart';

class BluetoothSection extends StatefulWidget {
  const BluetoothSection({super.key});

  @override
  State<BluetoothSection> createState() => _BluetoothSectionState();
}

class _BluetoothSectionState extends State<BluetoothSection> {
  String? _selectedBluetoothDevice;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.bluetoothStatus != current.bluetoothStatus ||
          previous.bluetoothDevices != current.bluetoothDevices,
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bluetooth Devices',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: state.bluetoothStatus == DeviceStatus.loading
                          ? null
                          : () => cubit.scanBluetoothDevices(),
                      icon: state.bluetoothStatus == DeviceStatus.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      tooltip: 'Scan Bluetooth',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: state.bluetoothStatus == DeviceStatus.loading
                      ? null
                      : () => cubit.scanBluetoothDevices(),
                  icon: const Icon(Icons.bluetooth_searching),
                  label: Text(
                    state.bluetoothStatus == DeviceStatus.loading
                        ? 'Scanning...'
                        : 'Scan Bluetooth Devices',
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 12),
                if (state.bluetoothDevices.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value:
                        _selectedBluetoothDevice != null &&
                            state.bluetoothDevices.contains(
                              _selectedBluetoothDevice,
                            )
                        ? _selectedBluetoothDevice
                        : null,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Select Bluetooth Device',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bluetooth),
                    ),
                    items: state.bluetoothDevices.map((device) {
                      return DropdownMenuItem(
                        value: device,
                        child: Text(
                          device,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBluetoothDevice = value;
                      });
                    },
                  )
                else if (state.bluetoothStatus == DeviceStatus.success)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No Bluetooth devices found',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
