import 'package:flutter/material.dart';

class SystemSettings extends StatelessWidget {
  const SystemSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("System Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Preferences",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: false,
            onChanged: (val) {},
          ),
          const Divider(),
          const Text(
            "System Info",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const ListTile(
            title: Text("App Version"),
            subtitle: Text("1.0.0"),
          ),
          const ListTile(
            title: Text("Last Backup"),
            subtitle: Text("Never"),
          ),
        ],
      ),
    );
  }
}
