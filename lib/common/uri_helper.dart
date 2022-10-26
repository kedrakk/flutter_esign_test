extension URIToString on String {
  String stripString() {
    return substring(lastIndexOf('/') + 1);
  }
}
