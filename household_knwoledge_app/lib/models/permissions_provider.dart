import 'package:flutter/material.dart';

class PermissionsProvider extends ChangeNotifier {
  bool _cameraPermissionEnabled = false;
  bool _galleryPermissionEnabled = false;
  bool _geolocationPermissionEnabled = false;
  bool _contactsPermissionEnabled = false;

  bool get cameraPermissionEnabled => _cameraPermissionEnabled;
  bool get galleryPermissionEnabled => _galleryPermissionEnabled;
  bool get geolocationPermissionEnabled => _geolocationPermissionEnabled;
  bool get contactsPermissionEnabled => _contactsPermissionEnabled;

  void toggleCameraPermission() {
    _cameraPermissionEnabled = !_cameraPermissionEnabled;
    notifyListeners();
  }

  void toggleGalleryPermission() {
    _galleryPermissionEnabled = !_galleryPermissionEnabled;
    notifyListeners();
  }

  void toggleGeolocationPermission() {
    _geolocationPermissionEnabled = !_geolocationPermissionEnabled;
    notifyListeners();
  }

  void toggleContactsPermission() {
    _contactsPermissionEnabled = !_contactsPermissionEnabled;
    notifyListeners();
  }
  
}
