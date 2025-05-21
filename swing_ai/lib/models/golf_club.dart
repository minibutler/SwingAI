class GolfClub {
  final String id;
  final String name;
  final double loft;
  final String type; // e.g., "4i", "5i", "PW", etc.

  GolfClub({
    required this.id,
    required this.name,
    required this.loft,
    required this.type,
  });

  @override
  String toString() => '$name ($type - $loft°)';
}

class ClubSet {
  final String id;
  final String brand;
  final String model;
  final int year;
  final List<GolfClub> clubs;

  ClubSet({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.clubs,
  });

  @override
  String toString() => '$brand $model ($year)';
}

// Predefined club sets based on the provided data
class ClubSets {
  static final List<ClubSet> allSets = [
    // 2013 Sets
    ClubSet(
      id: 'titleist-ap1-714',
      brand: 'Titleist',
      model: 'AP1 714',
      year: 2013,
      clubs: [
        GolfClub(
            id: 'titleist-ap1-714-4i',
            name: 'Titleist AP1 714',
            loft: 24,
            type: '4i'),
        GolfClub(
            id: 'titleist-ap1-714-5i',
            name: 'Titleist AP1 714',
            loft: 27,
            type: '5i'),
        GolfClub(
            id: 'titleist-ap1-714-6i',
            name: 'Titleist AP1 714',
            loft: 30,
            type: '6i'),
        GolfClub(
            id: 'titleist-ap1-714-7i',
            name: 'Titleist AP1 714',
            loft: 33,
            type: '7i'),
        GolfClub(
            id: 'titleist-ap1-714-8i',
            name: 'Titleist AP1 714',
            loft: 37,
            type: '8i'),
        GolfClub(
            id: 'titleist-ap1-714-9i',
            name: 'Titleist AP1 714',
            loft: 41,
            type: '9i'),
        GolfClub(
            id: 'titleist-ap1-714-pw',
            name: 'Titleist AP1 714',
            loft: 45,
            type: 'PW'),
        GolfClub(
            id: 'titleist-ap1-714-gw',
            name: 'Titleist AP1 714',
            loft: 50,
            type: 'GW'),
        GolfClub(
            id: 'titleist-ap1-714-sw',
            name: 'Titleist AP1 714',
            loft: 55,
            type: 'SW'),
        GolfClub(
            id: 'titleist-ap1-714-lw',
            name: 'Titleist AP1 714',
            loft: 60,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'taylormade-speedblade',
      brand: 'TaylorMade',
      model: 'SpeedBlade',
      year: 2013,
      clubs: [
        GolfClub(
            id: 'taylormade-speedblade-4i',
            name: 'TaylorMade SpeedBlade',
            loft: 20,
            type: '4i'),
        GolfClub(
            id: 'taylormade-speedblade-5i',
            name: 'TaylorMade SpeedBlade',
            loft: 23,
            type: '5i'),
        GolfClub(
            id: 'taylormade-speedblade-6i',
            name: 'TaylorMade SpeedBlade',
            loft: 26.5,
            type: '6i'),
        GolfClub(
            id: 'taylormade-speedblade-7i',
            name: 'TaylorMade SpeedBlade',
            loft: 30.5,
            type: '7i'),
        GolfClub(
            id: 'taylormade-speedblade-8i',
            name: 'TaylorMade SpeedBlade',
            loft: 35,
            type: '8i'),
        GolfClub(
            id: 'taylormade-speedblade-9i',
            name: 'TaylorMade SpeedBlade',
            loft: 39,
            type: '9i'),
        GolfClub(
            id: 'taylormade-speedblade-pw',
            name: 'TaylorMade SpeedBlade',
            loft: 44,
            type: 'PW'),
        GolfClub(
            id: 'taylormade-speedblade-gw',
            name: 'TaylorMade SpeedBlade',
            loft: 49,
            type: 'GW'),
        GolfClub(
            id: 'taylormade-speedblade-sw',
            name: 'TaylorMade SpeedBlade',
            loft: 54,
            type: 'SW'),
        GolfClub(
            id: 'taylormade-speedblade-lw',
            name: 'TaylorMade SpeedBlade',
            loft: 59,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'ping-g25',
      brand: 'Ping',
      model: 'G25',
      year: 2013,
      clubs: [
        GolfClub(id: 'ping-g25-4i', name: 'Ping G25', loft: 23, type: '4i'),
        GolfClub(id: 'ping-g25-5i', name: 'Ping G25', loft: 26, type: '5i'),
        GolfClub(id: 'ping-g25-6i', name: 'Ping G25', loft: 29, type: '6i'),
        GolfClub(id: 'ping-g25-7i', name: 'Ping G25', loft: 32, type: '7i'),
        GolfClub(id: 'ping-g25-8i', name: 'Ping G25', loft: 36, type: '8i'),
        GolfClub(id: 'ping-g25-9i', name: 'Ping G25', loft: 40, type: '9i'),
        GolfClub(id: 'ping-g25-pw', name: 'Ping G25', loft: 45, type: 'PW'),
        GolfClub(id: 'ping-g25-gw', name: 'Ping G25', loft: 50, type: 'GW'),
        GolfClub(id: 'ping-g25-sw', name: 'Ping G25', loft: 54, type: 'SW'),
        GolfClub(id: 'ping-g25-lw', name: 'Ping G25', loft: 58, type: 'LW'),
      ],
    ),

    // 2017 Sets
    ClubSet(
      id: 'titleist-ap1-716',
      brand: 'Titleist',
      model: 'AP1 716',
      year: 2017,
      clubs: [
        GolfClub(
            id: 'titleist-ap1-716-4i',
            name: 'Titleist AP1 716',
            loft: 21,
            type: '4i'),
        GolfClub(
            id: 'titleist-ap1-716-5i',
            name: 'Titleist AP1 716',
            loft: 24,
            type: '5i'),
        GolfClub(
            id: 'titleist-ap1-716-6i',
            name: 'Titleist AP1 716',
            loft: 27,
            type: '6i'),
        GolfClub(
            id: 'titleist-ap1-716-7i',
            name: 'Titleist AP1 716',
            loft: 30,
            type: '7i'),
        GolfClub(
            id: 'titleist-ap1-716-8i',
            name: 'Titleist AP1 716',
            loft: 34,
            type: '8i'),
        GolfClub(
            id: 'titleist-ap1-716-9i',
            name: 'Titleist AP1 716',
            loft: 39,
            type: '9i'),
        GolfClub(
            id: 'titleist-ap1-716-pw',
            name: 'Titleist AP1 716',
            loft: 43,
            type: 'PW'),
        GolfClub(
            id: 'titleist-ap1-716-gw',
            name: 'Titleist AP1 716',
            loft: 48,
            type: 'GW'),
        GolfClub(
            id: 'titleist-ap1-716-sw',
            name: 'Titleist AP1 716',
            loft: 53,
            type: 'SW'),
        GolfClub(
            id: 'titleist-ap1-716-lw',
            name: 'Titleist AP1 716',
            loft: 58,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'taylormade-m2',
      brand: 'TaylorMade',
      model: 'M2',
      year: 2017,
      clubs: [
        GolfClub(
            id: 'taylormade-m2-4i',
            name: 'TaylorMade M2',
            loft: 19,
            type: '4i'),
        GolfClub(
            id: 'taylormade-m2-5i',
            name: 'TaylorMade M2',
            loft: 21.5,
            type: '5i'),
        GolfClub(
            id: 'taylormade-m2-6i',
            name: 'TaylorMade M2',
            loft: 25,
            type: '6i'),
        GolfClub(
            id: 'taylormade-m2-7i',
            name: 'TaylorMade M2',
            loft: 28.5,
            type: '7i'),
        GolfClub(
            id: 'taylormade-m2-8i',
            name: 'TaylorMade M2',
            loft: 33,
            type: '8i'),
        GolfClub(
            id: 'taylormade-m2-9i',
            name: 'TaylorMade M2',
            loft: 38,
            type: '9i'),
        GolfClub(
            id: 'taylormade-m2-pw',
            name: 'TaylorMade M2',
            loft: 43.5,
            type: 'PW'),
        GolfClub(
            id: 'taylormade-m2-gw',
            name: 'TaylorMade M2',
            loft: 49,
            type: 'GW'),
        GolfClub(
            id: 'taylormade-m2-sw',
            name: 'TaylorMade M2',
            loft: 54,
            type: 'SW'),
        GolfClub(
            id: 'taylormade-m2-lw',
            name: 'TaylorMade M2',
            loft: 59,
            type: 'LW'),
      ],
    ),

    // 2021 Sets
    ClubSet(
      id: 'titleist-t300',
      brand: 'Titleist',
      model: 'T300',
      year: 2021,
      clubs: [
        GolfClub(
            id: 'titleist-t300-4i',
            name: 'Titleist T300',
            loft: 20,
            type: '4i'),
        GolfClub(
            id: 'titleist-t300-5i',
            name: 'Titleist T300',
            loft: 23,
            type: '5i'),
        GolfClub(
            id: 'titleist-t300-6i',
            name: 'Titleist T300',
            loft: 26,
            type: '6i'),
        GolfClub(
            id: 'titleist-t300-7i',
            name: 'Titleist T300',
            loft: 29,
            type: '7i'),
        GolfClub(
            id: 'titleist-t300-8i',
            name: 'Titleist T300',
            loft: 33,
            type: '8i'),
        GolfClub(
            id: 'titleist-t300-9i',
            name: 'Titleist T300',
            loft: 38,
            type: '9i'),
        GolfClub(
            id: 'titleist-t300-pw',
            name: 'Titleist T300',
            loft: 43,
            type: 'PW'),
        GolfClub(
            id: 'titleist-t300-gw',
            name: 'Titleist T300',
            loft: 48,
            type: 'GW'),
        GolfClub(
            id: 'titleist-t300-sw',
            name: 'Titleist T300',
            loft: 53,
            type: 'SW'),
        GolfClub(
            id: 'titleist-t300-lw',
            name: 'Titleist T300',
            loft: 58,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'callaway-mavrik',
      brand: 'Callaway',
      model: 'Mavrik',
      year: 2021,
      clubs: [
        GolfClub(
            id: 'callaway-mavrik-4i',
            name: 'Callaway Mavrik',
            loft: 18,
            type: '4i'),
        GolfClub(
            id: 'callaway-mavrik-5i',
            name: 'Callaway Mavrik',
            loft: 21,
            type: '5i'),
        GolfClub(
            id: 'callaway-mavrik-6i',
            name: 'Callaway Mavrik',
            loft: 24,
            type: '6i'),
        GolfClub(
            id: 'callaway-mavrik-7i',
            name: 'Callaway Mavrik',
            loft: 27,
            type: '7i'),
        GolfClub(
            id: 'callaway-mavrik-8i',
            name: 'Callaway Mavrik',
            loft: 31.5,
            type: '8i'),
        GolfClub(
            id: 'callaway-mavrik-9i',
            name: 'Callaway Mavrik',
            loft: 36,
            type: '9i'),
        GolfClub(
            id: 'callaway-mavrik-pw',
            name: 'Callaway Mavrik',
            loft: 41,
            type: 'PW'),
        GolfClub(
            id: 'callaway-mavrik-gw',
            name: 'Callaway Mavrik',
            loft: 46,
            type: 'GW'),
        GolfClub(
            id: 'callaway-mavrik-sw',
            name: 'Callaway Mavrik',
            loft: 51,
            type: 'SW'),
        GolfClub(
            id: 'callaway-mavrik-lw',
            name: 'Callaway Mavrik',
            loft: 56,
            type: 'LW'),
      ],
    ),

    // 2023 Sets
    ClubSet(
      id: 'titleist-t200',
      brand: 'Titleist',
      model: 'T200',
      year: 2023,
      clubs: [
        GolfClub(
            id: 'titleist-t200-4i',
            name: 'Titleist T200',
            loft: 21,
            type: '4i'),
        GolfClub(
            id: 'titleist-t200-5i',
            name: 'Titleist T200',
            loft: 24,
            type: '5i'),
        GolfClub(
            id: 'titleist-t200-6i',
            name: 'Titleist T200',
            loft: 27,
            type: '6i'),
        GolfClub(
            id: 'titleist-t200-7i',
            name: 'Titleist T200',
            loft: 30,
            type: '7i'),
        GolfClub(
            id: 'titleist-t200-8i',
            name: 'Titleist T200',
            loft: 34,
            type: '8i'),
        GolfClub(
            id: 'titleist-t200-9i',
            name: 'Titleist T200',
            loft: 39,
            type: '9i'),
        GolfClub(
            id: 'titleist-t200-pw',
            name: 'Titleist T200',
            loft: 44,
            type: 'PW'),
        GolfClub(
            id: 'titleist-t200-gw',
            name: 'Titleist T200',
            loft: 49,
            type: 'GW'),
        GolfClub(
            id: 'titleist-t200-sw',
            name: 'Titleist T200',
            loft: 54,
            type: 'SW'),
        GolfClub(
            id: 'titleist-t200-lw',
            name: 'Titleist T200',
            loft: 59,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'ping-g430',
      brand: 'Ping',
      model: 'G430',
      year: 2023,
      clubs: [
        GolfClub(id: 'ping-g430-4i', name: 'Ping G430', loft: 20, type: '4i'),
        GolfClub(id: 'ping-g430-5i', name: 'Ping G430', loft: 23, type: '5i'),
        GolfClub(id: 'ping-g430-6i', name: 'Ping G430', loft: 26, type: '6i'),
        GolfClub(id: 'ping-g430-7i', name: 'Ping G430', loft: 29, type: '7i'),
        GolfClub(id: 'ping-g430-8i', name: 'Ping G430', loft: 33, type: '8i'),
        GolfClub(id: 'ping-g430-9i', name: 'Ping G430', loft: 38.5, type: '9i'),
        GolfClub(id: 'ping-g430-pw', name: 'Ping G430', loft: 44, type: 'PW'),
        GolfClub(id: 'ping-g430-gw', name: 'Ping G430', loft: 49, type: 'GW'),
        GolfClub(id: 'ping-g430-sw', name: 'Ping G430', loft: 54, type: 'SW'),
        GolfClub(id: 'ping-g430-lw', name: 'Ping G430', loft: 58, type: 'LW'),
      ],
    ),

    // 2025 Sets (estimated)
    ClubSet(
      id: 'titleist-t350',
      brand: 'Titleist',
      model: 'T350',
      year: 2025,
      clubs: [
        GolfClub(
            id: 'titleist-t350-4i',
            name: 'Titleist T350',
            loft: 20,
            type: '4i'),
        GolfClub(
            id: 'titleist-t350-5i',
            name: 'Titleist T350',
            loft: 23,
            type: '5i'),
        GolfClub(
            id: 'titleist-t350-6i',
            name: 'Titleist T350',
            loft: 26,
            type: '6i'),
        GolfClub(
            id: 'titleist-t350-7i',
            name: 'Titleist T350',
            loft: 29,
            type: '7i'),
        GolfClub(
            id: 'titleist-t350-8i',
            name: 'Titleist T350',
            loft: 33,
            type: '8i'),
        GolfClub(
            id: 'titleist-t350-9i',
            name: 'Titleist T350',
            loft: 38,
            type: '9i'),
        GolfClub(
            id: 'titleist-t350-pw',
            name: 'Titleist T350',
            loft: 43,
            type: 'PW'),
        GolfClub(
            id: 'titleist-t350-gw',
            name: 'Titleist T350',
            loft: 48,
            type: 'GW'),
        GolfClub(
            id: 'titleist-t350-sw',
            name: 'Titleist T350',
            loft: 53,
            type: 'SW'),
        GolfClub(
            id: 'titleist-t350-lw',
            name: 'Titleist T350',
            loft: 58,
            type: 'LW'),
      ],
    ),
    ClubSet(
      id: 'callaway-ai-smoke',
      brand: 'Callaway',
      model: 'Ai Smoke',
      year: 2025,
      clubs: [
        GolfClub(
            id: 'callaway-ai-smoke-4i',
            name: 'Callaway Ai Smoke',
            loft: 18,
            type: '4i'),
        GolfClub(
            id: 'callaway-ai-smoke-5i',
            name: 'Callaway Ai Smoke',
            loft: 21,
            type: '5i'),
        GolfClub(
            id: 'callaway-ai-smoke-6i',
            name: 'Callaway Ai Smoke',
            loft: 24,
            type: '6i'),
        GolfClub(
            id: 'callaway-ai-smoke-7i',
            name: 'Callaway Ai Smoke',
            loft: 27,
            type: '7i'),
        GolfClub(
            id: 'callaway-ai-smoke-8i',
            name: 'Callaway Ai Smoke',
            loft: 31.5,
            type: '8i'),
        GolfClub(
            id: 'callaway-ai-smoke-9i',
            name: 'Callaway Ai Smoke',
            loft: 36.5,
            type: '9i'),
        GolfClub(
            id: 'callaway-ai-smoke-pw',
            name: 'Callaway Ai Smoke',
            loft: 41,
            type: 'PW'),
        GolfClub(
            id: 'callaway-ai-smoke-gw',
            name: 'Callaway Ai Smoke',
            loft: 46,
            type: 'GW'),
        GolfClub(
            id: 'callaway-ai-smoke-sw',
            name: 'Callaway Ai Smoke',
            loft: 51,
            type: 'SW'),
        GolfClub(
            id: 'callaway-ai-smoke-lw',
            name: 'Callaway Ai Smoke',
            loft: 56,
            type: 'LW'),
      ],
    ),
  ];

  // Helper methods to filter club sets
  static List<ClubSet> getByYear(int year) {
    return allSets.where((set) => set.year == year).toList();
  }

  static List<ClubSet> getByBrand(String brand) {
    return allSets
        .where((set) => set.brand.toLowerCase() == brand.toLowerCase())
        .toList();
  }

  static ClubSet? getById(String id) {
    try {
      return allSets.firstWhere((set) => set.id == id);
    } catch (e) {
      return null;
    }
  }
}
