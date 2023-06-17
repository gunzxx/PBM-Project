import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  int? id, latitude, longitude;
  String? name, email, address;

  UserState({
    this.id,
    this.name,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
  });
}
