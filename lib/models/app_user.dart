/// SDK-independent identity. Personal fields must not be used in analytics.
class AppUser {
  const AppUser({required this.uid, this.displayName, this.email});
  final String uid;
  final String? displayName;
  final String? email;
}
