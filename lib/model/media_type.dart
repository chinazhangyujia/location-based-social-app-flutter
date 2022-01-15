enum MediaType {
  IMAGE,
  VIDEO
}

MediaType getMediaTypeByName(String name) {
  return name == 'VIDEO' ? MediaType.VIDEO : MediaType.IMAGE;
}

extension ParseToString on MediaType {
  String name() {
    return toString().split('.').last;
  }
}