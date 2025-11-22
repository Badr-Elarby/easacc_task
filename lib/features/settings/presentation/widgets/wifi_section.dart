import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit/settings_cubit.dart';
import '../cubits/settings_cubit/settings_state.dart';

class WifiSection extends StatefulWidget {
  const WifiSection({super.key});

  @override
  State<WifiSection> createState() => _WifiSectionState();
}

class _WifiSectionState extends State<WifiSection> {
  String? _selectedWifiNetwork;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.wifiStatus != current.wifiStatus ||
          previous.wifiNetworks != current.wifiNetworks,
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
                      'WiFi Networks',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: state.wifiStatus == DeviceStatus.loading
                          ? null
                          : () => cubit.scanWifiNetworks(),
                      icon: state.wifiStatus == DeviceStatus.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      tooltip: 'Scan WiFi',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: state.wifiStatus == DeviceStatus.loading
                      ? null
                      : () => cubit.scanWifiNetworks(),
                  icon: const Icon(Icons.wifi_find),
                  label: Text(
                    state.wifiStatus == DeviceStatus.loading
                        ? 'Scanning...'
                        : 'Scan WiFi Networks',
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 12),
                if (state.wifiNetworks.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value:
                        _selectedWifiNetwork != null &&
                            state.wifiNetworks.contains(_selectedWifiNetwork)
                        ? _selectedWifiNetwork
                        : null,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Select WiFi Network',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wifi),
                    ),
                    items: state.wifiNetworks.map((network) {
                      return DropdownMenuItem(
                        value: network,
                        child: Text(
                          network,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWifiNetwork = value;
                      });
                    },
                  )
                else if (state.wifiStatus == DeviceStatus.success)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No WiFi networks found',
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
