enum DistanceUnit {
  miles(
    id: 1,
    name: 'Miles',
    shortName: 'Miles',
  ),
  kilometers(
    id: 2,
    name: 'Kilometers',
    shortName: 'Km',
  );

  const DistanceUnit({
    required this.id,
    required this.name,
    required this.shortName,
  });
  final int id;
  final String name;
  final String shortName;
}
