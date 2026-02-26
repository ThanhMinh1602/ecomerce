import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProvider {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  static const String users = 'users';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String categories = 'categories';
  static const String banners = 'banners';
}
