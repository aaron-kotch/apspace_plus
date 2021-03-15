class Polished {

  final String modCode;
  final String modName;

  Polished({this.modCode, this.modName});

  factory Polished.get(Map<String, dynamic> yes) {

    return Polished(
      modCode: 'code',
      modName: 'name',
    );
  }



}