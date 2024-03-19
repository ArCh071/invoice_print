import 'package:flutter/material.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';

class Homeprovider with ChangeNotifier {
  bool tax = false;

//........handle inclusive and exclusive button
  void handleSGSTCheckbox(bool value) {
    tax = value;
    notifyListeners();
  }

  bool show = false;
  GlobalKey globalKey = GlobalKey();
  String? selectedValue = '1';

  showtrue() async {
    show = true;
    notifyListeners();
  }

  showfalse() async {
    show = false;
    notifyListeners();
  }

  final converter = AmountToWords();
  double? taxs;
  gettax({double? gettax}) async {
    taxs = gettax! / 2;
    gettaxtotal();
    notifyListeners();
  }

  gettax2({double? gettax}) async {
    taxs = gettax! / 1;
    gettaxtotal();
    notifyListeners();
  }

  double? amount;
  getamount({double? qty, double? rate}) async {
    amount = rate! * qty!;
    notifyListeners();
  }

  getamountinclusive({double? qty, double? rate}) async {
    double tot = rate! * qty!;
    amount = tot - (taxttotal! + taxttotal!);

    notifyListeners();
  }

  getamountinclusive2({double? qty, double? rate}) async {
    double tot = rate! * qty!;

    amount = tot - (taxttotal!);

    notifyListeners();
  }

  double? taxttotal;
  gettaxtotal() async {
    double amt = (taxs! * amount!) / 100;
    String amts = amt.toStringAsFixed(3);
    taxttotal = double.parse(amts);
    notifyListeners();
  }

  String? grandtotal;
  int? roundoff;
  String? word;
  getgrandtotal() async {
    double amt = amount! + taxttotal! + taxttotal!;
    String? amts = amt.toStringAsFixed(3);

    List<String> parts = amts.split('.');
    grandtotal = '${parts[0]}.000';
    double val = double.parse(grandtotal!);
    word = converter.convertAmountToWords(val, ignoreDecimal: true);
    roundoff = int.parse(parts[1]);
    print("grand.1.....$grandtotal");
    notifyListeners();
  }

  getgrandtotal2() async {
    double amt = amount! + taxttotal!;
    String? amts = amt.toStringAsFixed(3);
    List<String> parts = amts.split('.');
    grandtotal = '${parts[0]}.000';

    double val = double.parse(grandtotal!);
    word = converter.convertAmountToWords(val, ignoreDecimal: true);
    roundoff = int.parse(parts[1]);
    print("grand.2.....$grandtotal");
    notifyListeners();
  }

  String? taxword;
  gettaxinword() async {
    double value = taxttotal! + taxttotal!;
    double val = double.parse(value.toString());
    taxword = converter.convertAmountToWords(val, ignoreDecimal: true);
    notifyListeners();
  }

  // ....handle textfiled value

  bool submit = false;
  bool submit2 = false;
  bool submit3 = false;
  changesubmit({bool? submiting}) async {
    submit = submiting!;
    notifyListeners();
  }

  changesubmit2({bool? submiting}) async {
    submit2 = submiting!;
    notifyListeners();
  }

  changesubmit3({bool? submiting}) async {
    submit3 = submiting!;
    notifyListeners();
  }

  String? addressname = "STONEAGE INDUSTRIES";
  String? addressadd1 = "CHOLA ROAD,PATTANNUR P O";
  String? addressadd2 = "NAYATTUPARA";
  String? addresscity;
  String? addressstate = "Kerala";
  String? addressstatecode = "32";
  String? addresspincode = "670595";
  String? addressmob = "9605252181,9048133316,7510252181";
  String? addresslandline = "0490 2486316";
  String? addressgst = "32AEGFS8891H1ZK";

  gettheaddress(
      {String? name,
      String? address1,
      String? address2,
      String? city,
      String? state,
      String? statecode,
      String? pincode,
      String? mob,
      String? landline,
      String? gst}) async {
    addressadd1 = address1;
    addressadd2 = address2;
    addresscity = city;
    addressgst = gst;
    addresslandline = landline;
    addressmob = mob;
    addressname = name;
    addressstate = state;
    addressstatecode = statecode;
    addresspincode = pincode;
    notifyListeners();
  }

  String? shippingaddressname = "STONEAGE INDUSTRIES";
  String? shippingaddressadd1 = "CHOLA ROAD,PATTANNUR P O";
  String? shippingaddressadd2 = "NAYATTUPARA";
  String? shippingaddresscity;
  String? shippingaddressstate = "Kerala";
  String? shippingaddressstatecode = "32";
  String? shippingaddresspincode = "670595";
  String? shippingaddressmob = "9605252181,9048133316,7510252181";
  String? shippingaddresslandline = "0490 2486316";
  String? shippingaddressgst = "32AEGFS8891H1ZK";

  gettheshippingaddress(
      {String? name,
      String? address1,
      String? address2,
      String? city,
      String? state,
      String? statecode,
      String? pincode,
      String? mob,
      String? landline,
      String? gst}) async {
    shippingaddressadd1 = address1;
    shippingaddressadd2 = address2;
    shippingaddresscity = city;
    shippingaddressgst = gst;
    shippingaddresslandline = landline;
    shippingaddressmob = mob;
    shippingaddressname = name;
    shippingaddressstate = state;
    shippingaddressstatecode = statecode;
    shippingaddresspincode = pincode;
    notifyListeners();
  }

  String? buyeraddressname = "STONEAGE INDUSTRIES";
  String? buyeraddressadd1 = "CHOLA ROAD,PATTANNUR P O";
  String? buyeraddressadd2 = "NAYATTUPARA";
  String? buyeraddresscity;
  String? buyeraddressstate = "Kerala";
  String? buyeraddressstatecode = "32";
  String? buyeraddresspincode = "670595";
  String? buyeraddressmob = "9605252181,9048133316,7510252181";
  String? buyeraddresslandline = "0490 2486316";
  String? buyeraddressgst = "32AEGFS8891H1ZK";

  getthebuyeraddress(
      {String? name,
      String? address1,
      String? address2,
      String? city,
      String? state,
      String? statecode,
      String? pincode,
      String? mob,
      String? landline,
      String? gst}) async {
    buyeraddressadd1 = address1;
    buyeraddressadd2 = address2;
    buyeraddresscity = city;
    buyeraddressgst = gst;
    buyeraddresslandline = landline;
    buyeraddressmob = mob;
    buyeraddressname = name;
    buyeraddressstate = state;
    buyeraddressstatecode = statecode;
    buyeraddresspincode = pincode;
    notifyListeners();
  }
}
