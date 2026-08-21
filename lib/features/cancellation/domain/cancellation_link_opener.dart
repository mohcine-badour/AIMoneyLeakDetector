/// Opens an official cancellation URL. Never treat this as a completed cancel.
abstract class CancellationLinkOpener {
  Future<bool> open(Uri uri);
}

class NoOpCancellationLinkOpener implements CancellationLinkOpener {
  const NoOpCancellationLinkOpener();

  @override
  Future<bool> open(Uri uri) async => true;
}
