/// A class that parses and compares software versions in the format
/// major.minor.bugfix.
class DottedVersion {
  static DottedVersion parse(String version) {
    var versions = version.split(".");
    if (versions.isEmpty || version.isEmpty) {
      throw Exception("Empty input");
    }

    var major = int.tryParse(versions[0]);
    if (major == null) {
      throw Exception("Invalid version (no major): $version");
    }

    var result = DottedVersion(
      major,
      versions.length > 1 ? (int.tryParse(versions[1]) ?? 0) : 0,
      versions.length > 2 ? (int.tryParse(versions[2]) ?? 0) : 0,
    );

    return result;
  }

  final int major;
  final int minor;
  final int patch;

  DottedVersion(this.major, this.minor, this.patch);

  int compareTo(DottedVersion other) {
    if (this < other) return -1;
    if (this > other) return 1;
    return 0;
  }

  bool isLessThan(String otherString) {
    return this < DottedVersion.parse(otherString);
  }

  bool operator <(DottedVersion other) {
    if (major != other.major) return major < other.major;
    if (minor != other.minor) return minor < other.minor;
    return patch < other.patch;
  }

  bool operator >(DottedVersion other) => other < this;

  bool operator <=(DottedVersion other) => this < other || this == other;

  bool operator >=(DottedVersion other) => this > other || this == other;

  @override
  bool operator ==(Object other) =>
      other is DottedVersion &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => "$major.$minor.$patch";
}
