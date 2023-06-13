extension XList<T> on List<T> {
  int indexWhereOrElse(bool Function(T element) test,
      {int Function()? orElse}) {
    final index = indexWhere(test);
    if (index >= 0) {
      return index;
    } else {
      return orElse?.call() ?? index;
    }
  }
}
