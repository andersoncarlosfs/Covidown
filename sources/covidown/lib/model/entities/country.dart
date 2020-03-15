//
import 'package:covidown/model/abstract_entity.dart';

class Country extends AbstractEntity {
  final String code;
  final String name;

  Country({this.code, this.name});

  getEmoji() {
    return computeEmoji(code);
  }

  //
  @override
  static computeEmoji(code) {

    //
    int flagOffset = 0x1F1E6;
    int ASCIIOffset = 0x41;

    //
    int firstChar = code.codeUnitAt(0) - ASCIIOffset + flagOffset;
    int secondChar = code.codeUnitAt(1) - ASCIIOffset + flagOffset;

    //
    String emoji = String.fromCharCode(firstChar) + String.fromCharCode(secondChar);

    return emoji;

  }

}