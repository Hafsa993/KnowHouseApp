import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/permissions_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_drawer.dart';

class OptionsScreen extends StatelessWidget {
  // Notification
  final ValueNotifier<bool> notificationsEnabled = ValueNotifier(true);

  // Theme
  final ValueNotifier<bool> darkThemeOn = ValueNotifier(false);

  // Selected Language
  final ValueNotifier<String> selectedLanguage = ValueNotifier('English');

  // Available Languages
  final List<String> languages = ['English'];

  OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionsProvider = Provider.of<PermissionsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('Options'),
      ),
      drawer: const MenuDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Enable Notifications
          ValueListenableBuilder<bool>(
            valueListenable: notificationsEnabled,
            builder: (context, value, child) {
              return SwitchListTile(
                title: const Text('Enable Notifications'),
                value: value,
                onChanged: (newValue) {
                  notificationsEnabled.value = newValue;
                },
              );
            },
          ),
          const Divider(),

          // Camera Permission
          ListTile(
            title: const Text('Camera Permission'),
            trailing: Switch(
              value: permissionsProvider.cameraPermissionEnabled,
              onChanged: (newValue) {
                permissionsProvider.toggleCameraPermission();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue
                        ? 'Camera Permission Enabled'
                        : 'Camera Permission Disabled'),
                  ),
                );
              },
            ),
          ),

          // Gallery Permission
          ListTile(
            title: const Text('Gallery Permission'),
            trailing: Switch(
              value: permissionsProvider.galleryPermissionEnabled,
              onChanged: (newValue) {
                permissionsProvider.toggleGalleryPermission();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue
                        ? 'Gallery Permission Enabled'
                        : 'Gallery Permission Disabled'),
                  ),
                );
              },
            ),
          ),

          // Geolocation Permission
          ListTile(
            title: const Text('Geolocation Permission'),
            trailing: Switch(
              value: permissionsProvider.geolocationPermissionEnabled,
              onChanged: (newValue) {
                permissionsProvider.toggleGeolocationPermission();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue
                        ? 'Geolocation Permission Enabled'
                        : 'Geolocation Permission Disabled'),
                  ),
                );
              },
            ),
          ),

          // Contacts Permission
          ListTile(
            title: const Text('Contacts Permission'),
            trailing: Switch(
              value: permissionsProvider.contactsPermissionEnabled,
              onChanged: (newValue) {
                permissionsProvider.toggleContactsPermission();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue
                        ? 'Contacts Permission Enabled'
                        : 'Contacts Permission Disabled'),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Language Selection (Optional)
          ValueListenableBuilder<String>(
            valueListenable: selectedLanguage,
            builder: (context, value, child) {
              return ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedLanguage.value = newValue;
                    }
                  },
                  items: languages.map<DropdownMenuItem<String>>((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
