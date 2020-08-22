import 'package:unit_converter/screen/home_screen.dart';

class Unit {
  final String key;
  final String name;

  Unit(this.key, this.name);
}

class Brain {
  Map<String, double> formulas;
  List<Unit> units;

  void initUnits(Conversions conversions) {
    formulas = {};
    units = [];
    switch (conversions) {
      case Conversions.VOLUME:
        formulas["ml-cl"] = 0.1;
        formulas["ml-dl"] = 0.01;
        formulas["ml-l"] = 0.001;
        formulas["ml-dal"] = 0.0001;
        formulas["ml-hl"] = 0.00001;
        formulas["ml-kl"] = 0.000001;

        formulas["cl-dl"] = 0.1;
        formulas["cl-l"] = 0.01;
        formulas["cl-dal"] = 0.001;
        formulas["cl-hl"] = 0.0001;
        formulas["cl-kl"] = 0.00001;
        formulas["cl-ml"] = 10;

        formulas["dl-l"] = 0.1;
        formulas["dl-dal"] = 0.01;
        formulas["dl-hl"] = 0.001;
        formulas["dl-kl"] = 0.0001;
        formulas["dl-cl"] = 10;
        formulas["dl-ml"] = 100;

        formulas["l-dal"] = 0.1;
        formulas["l-hl"] = 0.01;
        formulas["l-kl"] = 0.001;
        formulas["l-dl"] = 10;
        formulas["l-cl"] = 100;
        formulas["l-ml"] = 1000;

        formulas["dal-hl"] = 0.1;
        formulas["dal-kl"] = 0.01;
        formulas["dal-l"] = 10;
        formulas["dal-dl"] = 100;
        formulas["dal-cl"] = 1000;
        formulas["dal-ml"] = 10000;

        formulas["hl-kl"] = 0.1;
        formulas["hl-dal"] = 10;
        formulas["hl-l"] = 100;
        formulas["hl-dl"] = 1000;
        formulas["hl-cl"] = 10000;
        formulas["hl-ml"] = 100000;

        formulas["kl-hl"] = 10;
        formulas["kl-dal"] = 100;
        formulas["kl-l"] = 1000;
        formulas["kl-dl"] = 10000;
        formulas["kl-cl"] = 100000;
        formulas["kl-ml"] = 1000000;

        units = [
          Unit("ml", "Milliliter"),
          Unit("cl", "Centiliter"),
          Unit("dl", "Deciliter"),
          Unit("l", "Liter"),
          Unit("dal", "Decaliter"),
          Unit("hl", "Hectoliter "),
          Unit("kl", "Kiloliter")
        ];
        break;
      case Conversions.LENGTH:
        formulas["mm-cm"] = 0.1;
        formulas["mm-dm"] = 0.01;
        formulas["mm-m"] = 0.001;
        formulas["mm-dam"] = 0.0001;
        formulas["mm-hm"] = 0.00001;
        formulas["mm-km"] = 0.000001;

        formulas["cm-dm"] = 0.1;
        formulas["cm-m"] = 0.01;
        formulas["cm-dam"] = 0.001;
        formulas["cm-hm"] = 0.0001;
        formulas["cm-km"] = 0.00001;
        formulas["cm-mm"] = 10;

        formulas["dm-m"] = 0.1;
        formulas["dm-dam"] = 0.01;
        formulas["dm-hm"] = 0.001;
        formulas["dm-km"] = 0.0001;
        formulas["dm-cm"] = 10;
        formulas["dm-mm"] = 100;

        formulas["m-dam"] = 0.1;
        formulas["m-hm"] = 0.01;
        formulas["m-km"] = 0.001;
        formulas["m-dm"] = 10;
        formulas["m-cm"] = 100;
        formulas["m-mm"] = 1000;

        formulas["dam-hm"] = 0.1;
        formulas["dam-km"] = 0.01;
        formulas["dam-m"] = 10;
        formulas["dam-dm"] = 100;
        formulas["dam-cm"] = 1000;
        formulas["dam-mm"] = 10000;

        formulas["hm-km"] = 0.1;
        formulas["hm-dam"] = 10;
        formulas["hm-m"] = 100;
        formulas["hm-dm"] = 1000;
        formulas["hm-cm"] = 10000;
        formulas["hm-mm"] = 100000;

        formulas["km-hm"] = 10;
        formulas["km-dam"] = 100;
        formulas["km-m"] = 1000;
        formulas["km-dm"] = 10000;
        formulas["km-cm"] = 100000;
        formulas["km-mm"] = 1000000;

        units = [
          Unit("mm", "Millimeter"),
          Unit("cm", "Centimeter"),
          Unit("dm", "Decimeter"),
          Unit("m", "Meter"),
          Unit("dam", "Decameter"),
          Unit("hm", "Hectometer"),
          Unit("km", "Kilometer")
        ];
        break;
      case Conversions.WEIGHT:
        formulas["mg-cg"] = 0.1;
        formulas["mg-dg"] = 0.01;
        formulas["mg-g"] = 0.001;
        formulas["mg-dag"] = 0.0001;
        formulas["mg-hg"] = 0.00001;
        formulas["mg-kg"] = 0.000001;

        formulas["cg-dg"] = 0.1;
        formulas["cg-g"] = 0.01;
        formulas["cg-dag"] = 0.001;
        formulas["cg-hg"] = 0.0001;
        formulas["cg-kg"] = 0.00001;
        formulas["cg-mg"] = 10;

        formulas["dg-g"] = 0.1;
        formulas["dg-dag"] = 0.01;
        formulas["dg-hg"] = 0.001;
        formulas["dg-kg"] = 0.0001;
        formulas["dg-cg"] = 10;
        formulas["dg-mg"] = 100;

        formulas["g-dag"] = 0.1;
        formulas["g-hg"] = 0.01;
        formulas["g-kg"] = 0.001;
        formulas["g-dg"] = 10;
        formulas["g-cg"] = 100;
        formulas["g-mg"] = 1000;

        formulas["dag-hg"] = 0.1;
        formulas["dag-kg"] = 0.01;
        formulas["dag-g"] = 10;
        formulas["dag-dg"] = 100;
        formulas["dag-cg"] = 1000;
        formulas["dag-mg"] = 10000;

        formulas["hg-kg"] = 0.1;
        formulas["hg-dag"] = 10;
        formulas["hg-g"] = 100;
        formulas["hg-dg"] = 1000;
        formulas["hg-cg"] = 10000;
        formulas["hg-mg"] = 100000;

        formulas["kg-hg"] = 10;
        formulas["kg-dag"] = 100;
        formulas["kg-mg"] = 1000;
        formulas["kg-dg"] = 10000;
        formulas["kg-cg"] = 100000;
        formulas["kg-mg"] = 1000000;

        units = [
          Unit("mg", "Milligram"),
          Unit("cg", "Centigram"),
          Unit("dg", "Decigram"),
          Unit("g", "Gram"),
          Unit("dag", "Decagram"),
          Unit("hg", "Hectogram"),
          Unit("kg", "Kilogram")
        ];
        break;
      case Conversions.DISTANCE:
        formulas["in-ft"] = 1 / 12;
        formulas["in-yd"] = 1 / 36;
        formulas["in-mi"] = 1 / 63360;
        formulas["ft-yd"] = 1 / 3;
        formulas["ft-mi"] = 1 / 5280;
        formulas["yd-mi"] = 1 / 1760;

        formulas["mi-yd"] = 1760;
        formulas["mi-ft"] = 5280;
        formulas["mi-in"] = 63360;
        formulas["yd-ft"] = 3;
        formulas["yd-in"] = 36;
        formulas["ft-in"] = 12;

        units = [
          Unit("in", "Inch"),
          Unit("ft", "Foot"),
          Unit("yd", "Yard"),
          Unit("mi", "Mile")
        ];
        break;
    }
  }

  double calculate(Unit from, Unit to, double value) {
    var multiplier = formulas["${from.key}-${to.key}"] ?? 1;
    return multiplier * value;
  }
}
