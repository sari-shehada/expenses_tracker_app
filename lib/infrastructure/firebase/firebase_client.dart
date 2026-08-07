abstract interface class FirebaseClient {
  Future<void> initialize();

  Future<void> connectToAuthEmulator(String host, int port);

  void connectToStorageEmulator(String host, int port);
}
