import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final bool emailVerified;
  final bool isAnonymous;
  final String? providerId;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.emailVerified,
    required this.isAnonymous,
    this.providerId,
    this.creationTime,
    this.lastSignInTime,
  });

  factory AppUser.fromFirebaseUser(User user) => AppUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
        emailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        providerId: user.providerData.isNotEmpty ? user.providerData[0].providerId : null,
        creationTime: user.metadata.creationTime,
        lastSignInTime: user.metadata.lastSignInTime,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'phoneNumber': phoneNumber,
        'emailVerified': emailVerified,
        'isAnonymous': isAnonymous,
        'providerId': providerId,
        'creationTime': creationTime?.toIso8601String(),
        'lastSignInTime': lastSignInTime?.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uid: json['uid'],
        email: json['email'],
        displayName: json['displayName'],
        photoURL: json['photoURL'],
        phoneNumber: json['phoneNumber'],
        emailVerified: json['emailVerified'],
        isAnonymous: json['isAnonymous'],
        providerId: json['providerId'],
        creationTime: json['creationTime'] != null ? DateTime.parse(json['creationTime']) : null,
        lastSignInTime: json['lastSignInTime'] != null ? DateTime.parse(json['lastSignInTime']) : null,
      );
}
