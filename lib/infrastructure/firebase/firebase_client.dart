abstract interface class FirebaseClient {
  Future<void> initialize();

  Future<void> connectToAuthEmulator(String host, int port);

  void connectToFirestoreEmulator(String host, int port);
}
