import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/screens/preference_screen.dart';
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
    final userProvider = Provider.of<UserProvider>(context);
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
          ListTile(
            title: const Text("Notifications Permission"),
            trailing: Switch(
            value: userProvider.currentUser!.notificationsEnabled,
            onChanged: (newValue) {
              userProvider.toggleNotificationsEnabled();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newValue
                        ? 'Notfifcations Enabled'
                        : 'Notifications Disabled'),
                  ),
                );
            },),
            
          ),
          const Divider(),

          // Camera Permission
          ListTile(
            title: const Text('Camera Permission'),
            trailing: Switch(
              value: userProvider.currentUser!.cameraPermissionEnabled,
              onChanged: (newValue) {
                userProvider.toggleCameraPermission();
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
              value: userProvider.currentUser!.galleryPermissionEnabled,
              onChanged: (newValue) {
                userProvider.toggleGalleryPermission();
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
              value: userProvider.currentUser!.geolocationPermissionEnabled,
              onChanged: (newValue) {
                userProvider.toggleGeolocationPermission();
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
          const Divider(),
          ListTile(
            leading: Icon(Icons.tune),
            title: Text('Edit Preferences'),
            onTap: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PreferencesScreen(
                    allCategories: categories,
                    initialSelected: userProvider.currentUser?.preferences ?? [],
                    onSave: (prefs) async {
                      await userProvider.setPreferencesForUser(prefs);
                      if (!context.mounted) return;
                      Navigator.pop(context); 
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
