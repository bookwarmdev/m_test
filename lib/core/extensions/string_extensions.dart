extension AssetName on String {
  String get svg => 'assets/svgs/$this.svg';
  String get png => 'assets/images/$this.png';
  String get jpg => 'assets/images/$this.jpg';
  String get gif => 'assets/gifs/$this.gif';
  String get json => 'assets/json/$this.json';
}

extension FormatNumber on String {
  String get formattedNumber {
    // Assuming this string contains a number
    return replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}
