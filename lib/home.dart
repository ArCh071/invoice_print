import 'dart:ffi';

import 'dart:ui' as ui; // Import dart:ui library
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invoice/homeprovider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Double? totalprice;
  GlobalKey globalKey = GlobalKey();
  Uint8List? ppdfData;

  captureAndConvertToPdf() async {
    final model = context.read<Homeprovider>();

    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              margin: pw.EdgeInsets.zero,
              height: PdfPageFormat.a4.availableHeight,
              width: PdfPageFormat.a4.availableWidth,
              child: pw.Center(
                child: pw.Image(pw.MemoryImage(pngBytes), fit: pw.BoxFit.cover),
              ));
        },
      ),
    );

    final Uint8List pdfData = await pdf.save(); // Save PDF asynchronously

    setState(() {
      ppdfData = pdfData;
    });

    Printing.sharePdf(bytes: pdfData, filename: 'invoice.pdf');
    await model.showfalse();
    // Optionally, you can print the PDF or save it to a file
    // Printing.sharePdf(bytes: _pdfData, filename: 'example.pdf');
    // File('example.pdf').writeAsBytes(_pdfData);
  }

  String? selectedValue;

  final TextEditingController invoiceno = TextEditingController();
  final TextEditingController goodsname = TextEditingController();
  final TextEditingController goodsqty = TextEditingController();
  final TextEditingController goodsprice = TextEditingController();
  final TextEditingController totaltax = TextEditingController();
  final TextEditingController hsn = TextEditingController();

  final TextEditingController dateController = TextEditingController(
      text:
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final model = context.read<Homeprovider>();
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != DateTime.now()) {
        setState(() {
          dateController.text = "${picked.day}-${picked.month}-${picked.year}";
        });
      }
    }

    //................address

    final TextEditingController name =
        TextEditingController(text: model.addressname);
    final TextEditingController address1 =
        TextEditingController(text: model.addressadd1);
    final TextEditingController address2 =
        TextEditingController(text: model.addressadd2);
    final TextEditingController city =
        TextEditingController(text: model.addresscity);
    final TextEditingController state =
        TextEditingController(text: model.addressstate);
    final TextEditingController statecode =
        TextEditingController(text: model.addressstatecode);
    final TextEditingController pincode =
        TextEditingController(text: model.addresspincode);
    final TextEditingController mobile =
        TextEditingController(text: model.addressmob);
    final TextEditingController landline =
        TextEditingController(text: model.addresslandline);
    final TextEditingController gst =
        TextEditingController(text: model.addressgst);

    void address() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: address1,
                    decoration: const InputDecoration(
                        hintText: 'Address Line1',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: address2,
                    decoration: const InputDecoration(
                      hintText: 'Address Line2',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: city,
                    decoration: const InputDecoration(
                        hintText: 'City',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: state,
                    decoration: const InputDecoration(
                        hintText: 'State',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: statecode,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'State Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: pincode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Pin Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: landline,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Landline Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: gst,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'GST',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: .02 * w),
                    child: InkWell(
                      onTap: () {
                        model.changesubmit(submiting: true);
                        model.gettheaddress(
                            address1: address1.text,
                            address2: address2.text,
                            city: city.text,
                            gst: gst.text,
                            landline: landline.text,
                            mob: mobile.text,
                            name: name.text,
                            pincode: pincode.text,
                            state: state.text,
                            statecode: statecode.text);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: .065 * h,
                        width: MediaQuery.of(context).size.width / 1.8,
                        decoration: BoxDecoration(
                            color: Colors.green, border: Border.all()),
                        child: const Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    }

    //................address for consignee

    final TextEditingController shippingname =
        TextEditingController(text: model.shippingaddressname);
    final TextEditingController shippingaddress1 =
        TextEditingController(text: model.shippingaddressadd1);
    final TextEditingController shippingaddress2 =
        TextEditingController(text: model.shippingaddressadd2);
    final TextEditingController shippingcity =
        TextEditingController(text: model.shippingaddresscity);
    final TextEditingController shippingstate =
        TextEditingController(text: model.shippingaddressstate);
    final TextEditingController shippingstatecode =
        TextEditingController(text: model.shippingaddressstatecode);
    final TextEditingController shippingpincode =
        TextEditingController(text: model.shippingaddresspincode);
    final TextEditingController shippingmobile =
        TextEditingController(text: model.shippingaddressmob);
    final TextEditingController shippinglandline =
        TextEditingController(text: model.shippingaddresslandline);
    final TextEditingController shippinggst =
        TextEditingController(text: model.shippingaddressgst);

    void shippingaddress() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingname,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingaddress1,
                    decoration: const InputDecoration(
                        hintText: 'Address Line1',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingaddress2,
                    decoration: const InputDecoration(
                      hintText: 'Address Line2',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingcity,
                    decoration: const InputDecoration(
                        hintText: 'City',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingstate,
                    decoration: const InputDecoration(
                        hintText: 'State',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingstatecode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'State Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingpincode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Pin Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippingmobile,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippinglandline,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Landline Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: shippinggst,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'GST',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: .02 * w),
                    child: InkWell(
                      onTap: () {
                        model.changesubmit2(submiting: true);
                        model.gettheshippingaddress(
                            address1: shippingaddress1.text,
                            address2: shippingaddress2.text,
                            city: shippingcity.text,
                            gst: shippinggst.text,
                            landline: shippinglandline.text,
                            mob: shippingmobile.text,
                            name: shippingname.text,
                            pincode: shippingpincode.text,
                            state: shippingstate.text,
                            statecode: shippingstatecode.text);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: .065 * h,
                        width: MediaQuery.of(context).size.width / 1.8,
                        decoration: BoxDecoration(
                            color: Colors.green, border: Border.all()),
                        child: const Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    }

    //................address for billing

    final TextEditingController billingname =
        TextEditingController(text: model.buyeraddressname);
    final TextEditingController billingaddress1 =
        TextEditingController(text: model.buyeraddressadd1);
    final TextEditingController billingaddress2 =
        TextEditingController(text: model.buyeraddressadd2);
    final TextEditingController billingcity =
        TextEditingController(text: model.buyeraddresscity);
    final TextEditingController billingstate =
        TextEditingController(text: model.buyeraddressstate);
    final TextEditingController billingstatecode =
        TextEditingController(text: model.buyeraddressstatecode);
    final TextEditingController billingpincode =
        TextEditingController(text: model.buyeraddresspincode);
    final TextEditingController billingmobile =
        TextEditingController(text: model.buyeraddressmob);
    final TextEditingController billinglandline =
        TextEditingController(text: model.buyeraddresslandline);
    final TextEditingController billinggst =
        TextEditingController(text: model.buyeraddressgst);

    void billingaddress() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingname,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingaddress1,
                    decoration: const InputDecoration(
                        hintText: 'Address Line1',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingaddress2,
                    decoration: const InputDecoration(
                      hintText: 'Address Line2',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingcity,
                    decoration: const InputDecoration(
                        hintText: 'City',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingstate,
                    decoration: const InputDecoration(
                        hintText: 'State',
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingstatecode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'State Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingpincode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Pin Code',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billingmobile,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billinglandline,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Landline Number',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                  TextField(
                    controller: billinggst,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'GST',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: .015 * h,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: .02 * w),
                    child: InkWell(
                      onTap: () {
                        model.changesubmit3(submiting: true);
                        model.getthebuyeraddress(
                            address1: shippingaddress1.text,
                            address2: shippingaddress2.text,
                            city: shippingcity.text,
                            gst: shippinggst.text,
                            landline: shippinglandline.text,
                            mob: shippingmobile.text,
                            name: shippingname.text,
                            pincode: shippingpincode.text,
                            state: shippingstate.text,
                            statecode: shippingstatecode.text);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: .065 * h,
                        width: MediaQuery.of(context).size.width / 1.8,
                        decoration: BoxDecoration(
                            color: Colors.green, border: Border.all()),
                        child: const Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    }

    // ..............main view

    return Scaffold(
      body: Stack(children: [
        Consumer<Homeprovider>(builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: .05 * h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: .05 * w,
                    ),
                    child: Column(children: [
                      TextField(
                          readOnly: true,
                          controller: dateController,
                          onTap: () {
                            selectDate(context);
                          }),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Invoice Number",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: invoiceno,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Goods Name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: goodsname,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Goods Quantity",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: goodsqty,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Goods Price",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: goodsprice,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                activeColor:
                                    const Color.fromARGB(255, 49, 113, 53),
                                value: '1',
                                groupValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              ),
                              const Text("SGST & CGST")
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  activeColor:
                                      const Color.fromARGB(255, 49, 113, 53),
                                  value: '2',
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  }),
                              const Text("IGST")
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Total tax",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: totaltax,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "HSN/SAC",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: hsn,
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            activeColor: const Color.fromARGB(255, 49, 113, 53),
                            value: value.tax,
                            onChanged: (bool? values) {
                              value.handleSGSTCheckbox(values!);
                            },
                          ),
                          const Text(
                            'Inclusive Tax',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: .015 * h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right:
                                              BorderSide(color: Colors.grey))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: .015 * h,
                                        horizontal: .02 * w),
                                    child: model.submit == false
                                        ? const Text(
                                            "Address",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Text(
                                            "${value.addressname == null ? '' : '${value.addressname}\n'}${value.addressadd1 == null ? '' : '${value.addressadd1}\n'}${value.addressadd2 == null && value.addresscity == null ? '' : '${value.addressadd2}${value.addresscity}\n'}${value.addresspincode == null ? '' : '${value.addresspincode}\n'}${value.addressmob == null ? '' : 'Mob: ${value.addressmob}\n'}${value.addresslandline == null ? '' : '${value.addresslandline}\n'}${value.addressgst == null ? '' : 'GSTIN/UIN: ${value.addressgst}\n'}${value.addressstate == null ? '' : 'State Name: ${value.addressstate} '}${value.addressstatecode == null ? '' : 'Code: ${value.addressstatecode}'}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    address();
                                  },
                                  child: Container(
                                    height: .065 * h,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all()),
                                    child: const Center(
                                      child: Text(
                                        "CHANGE ADDRESS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: .02 * h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right:
                                              BorderSide(color: Colors.grey))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: .015 * h,
                                        horizontal: .02 * w),
                                    child: value.submit2 == false
                                        ? const Text(
                                            "Consignee (Ship to)",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Text(
                                            "Consignee (Ship to)\n${value.shippingaddressname!.isEmpty ? '' : '${value.shippingaddressname}\n'}${value.shippingaddressadd1!.isEmpty ? '' : '${value.shippingaddressadd1}\n'}${value.shippingaddressadd2!.isEmpty && value.shippingaddresscity!.isEmpty ? '' : '${value.shippingaddressadd2}${value.shippingaddresscity}\n'}${value.shippingaddresspincode!.isEmpty ? '' : '${value.shippingaddresspincode}\n'}${value.shippingaddressmob!.isEmpty ? '' : 'Mob: ${value.shippingaddressmob}\n'}${value.shippingaddresslandline!.isEmpty ? '' : '${value.shippingaddresslandline}\n'}${value.shippingaddressgst!.isEmpty ? '' : 'GSTIN/UIN: ${value.shippingaddressgst}\n'}${value.shippingaddressstate!.isEmpty ? '' : 'State Name: ${value.shippingaddressstate} '}${value.shippingaddressstatecode!.isEmpty ? '' : 'Code: ${value.shippingaddressstatecode}'}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    shippingaddress();
                                  },
                                  child: Container(
                                    height: .065 * h,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all()),
                                    child: const Center(
                                      child: Text(
                                        "CHANGE SHIPPING ADDRESS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: .02 * h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.grey),
                                          left: BorderSide(color: Colors.grey),
                                          right:
                                              BorderSide(color: Colors.grey))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: .015 * h,
                                        horizontal: .02 * w),
                                    child: value.submit3 == false
                                        ? const Text(
                                            "Address",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Text(
                                            "Buyer (Bill to)\n${value.buyeraddressname == null ? '' : '${value.buyeraddressname}\n'}${value.buyeraddressadd1 == null ? '' : '${value.buyeraddressadd1}\n'}${value.buyeraddressadd2 == null && value.buyeraddresscity == null ? '' : '${value.buyeraddressadd2}${value.buyeraddresscity}\n'}${value.buyeraddresspincode!.isEmpty ? '' : '${value.buyeraddresspincode}\n'}${value.buyeraddressmob!.isEmpty ? '' : 'Mob: ${value.buyeraddressmob}\n'}${value.buyeraddresslandline!.isEmpty ? '' : '${value.buyeraddresslandline}\n'}${value.buyeraddressgst!.isEmpty ? '' : 'GSTIN/UIN: ${value.buyeraddressgst}\n'}${value.buyeraddressstate!.isEmpty ? '' : 'State Name: ${value.buyeraddressstate} '}${value.buyeraddressstatecode!.isEmpty ? '' : 'Code: ${value.buyeraddressstatecode}'}",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    billingaddress();
                                  },
                                  child: Container(
                                    height: .065 * h,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all()),
                                    child: const Center(
                                      child: Text(
                                        "CHANGE BILLING ADDRESS",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: .02 * h,
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: isloading,
                          builder: (context, loading, child) {
                            return InkWell(
                              onTap: () async {
                                if (goodsname.text.isEmpty) {
                                  isloading.value = false;
                                  Fluttertoast.showToast(
                                      msg: "Goods Name is empty");
                                }
                                if (goodsprice.text.isEmpty) {
                                  isloading.value = false;
                                  Fluttertoast.showToast(
                                      msg: "Goods price is empty");
                                }
                                if (goodsqty.text.isEmpty) {
                                  isloading.value = false;
                                  Fluttertoast.showToast(
                                      msg: "Goods quantity is empty");
                                }

                                FocusScope.of(context).unfocus();

                                double rate = double.parse(goodsprice.text);
                                double qty = double.parse(goodsqty.text);
                                if (value.tax == true) {
                                  isloading.value = true;
                                  await value.showtrue();
                                  double totaltaxs =
                                      double.parse(totaltax.text.toString());
                                  selectedValue == '1'
                                      ? await value.gettax(gettax: totaltaxs)
                                      : await value.gettax2(gettax: totaltaxs);
                                  selectedValue == '1'
                                      ? await value.getamountinclusive(
                                          qty: qty, rate: rate)
                                      : await value.getamountinclusive2(
                                          qty: qty, rate: rate);

                                  selectedValue == '1'
                                      ? await value.getgrandtotal()
                                      : await value.getgrandtotal2();
                                  await value.gettaxinword();
                                } else {
                                  isloading.value = true;
                                  await value.showtrue();
                                  await value.getamount(qty: qty, rate: rate);
                                  double totaltaxs =
                                      double.parse(totaltax.text.toString());
                                  selectedValue == '1'
                                      ? await value.gettax(gettax: totaltaxs)
                                      : await value.gettax2(gettax: totaltaxs);
                                  selectedValue == '1'
                                      ? await value.getgrandtotal()
                                      : await value.getgrandtotal2();
                                  await value.gettaxinword();
                                }
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  await captureAndConvertToPdf();
                                  isloading.value = false;
                                });
                              },
                              child: Container(
                                height: .065 * h,
                                decoration: BoxDecoration(
                                    color: Colors.green, border: Border.all()),
                                child: Center(
                                  child: isloading.value == true
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "CREATE AND SHARE PDF",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                ),
                              ),
                            );
                          }),
                    ]),
                  ),
                ],
              ),
            ),
          );
        }),

        // .................display the view of invoice

        Positioned(
            left: -600,
            child: Consumer<Homeprovider>(builder: (context, value, child) {
              return SizedBox(
                height: 680.h,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Container(
                        color: Colors
                            .white, // Set background color as per your requirement
                        child: Column(children: [
                          95.verticalSpace,
                          Text(
                            "Tax Invoice",
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.w800),
                          ),
                          2.verticalSpace,
                          Container(
                              decoration: BoxDecoration(border: Border.all()),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      right: BorderSide(),
                                    )),
                                    height: 70.h,
                                    width: 166.w,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            value.submit == false
                                                ? const SizedBox()
                                                : Text(
                                                    value.addressname == null
                                                        ? ''
                                                        : '${value.addressname}',
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                            value.submit == false
                                                ? const SizedBox()
                                                : Text(
                                                    "${value.addressadd1 == null ? '' : '${value.addressadd1}\n'}${value.addressadd2 == null && value.addresscity == null ? '' : '${value.addressadd2}${value.addresscity}\n'}${value.addresspincode == null ? '' : '${value.addresspincode}\n'}${value.addressmob == null ? '' : 'Mob: ${value.addressmob}\n'}${value.addresslandline == null ? '' : '${value.addresslandline}\n'}${value.addressgst == null ? '' : 'GSTIN/UIN: ${value.addressgst}\n'}${value.addressstate == null ? '' : 'State Name: ${value.addressstate} '}${value.addressstatecode == null ? '' : 'Code: ${value.addressstatecode}'}",
                                                    style: TextStyle(
                                                        fontSize: 6.sp),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        height: 78.w,
                                        width: 96.w,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  width: 95.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide())),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " Invoice No      e-Way Bill No",
                                                        style: TextStyle(
                                                            fontSize: 7.sp),
                                                      ),
                                                      Text(
                                                        invoiceno.text.isEmpty
                                                            ? ''
                                                            : " ${invoiceno.text}",
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide())),
                                                  width: 95.w,
                                                  child: Text(
                                                    " Delivery Note",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  width: 95.w,
                                                  child: Text(
                                                    " Reference No. & Date",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 70.h,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  width: 96.w,
                                                  height: 90.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide())),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " Dated",
                                                        style: TextStyle(
                                                            fontSize: 7.sp),
                                                      ),
                                                      Text(
                                                        dateController
                                                                .text.isEmpty
                                                            ? ''
                                                            : " ${dateController.text}",
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide())),
                                                width: 96.w,
                                                child: Text(
                                                  " Mode/Term of Payment",
                                                  style:
                                                      TextStyle(fontSize: 7.sp),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  width: 96.w,
                                                  child: Text(
                                                    " Other Reference",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(), right: BorderSide())),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            right: BorderSide(),
                                            bottom: BorderSide())),
                                    height: 80.h,
                                    width: 166.w,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            value.submit2 == false
                                                ? const SizedBox()
                                                : Text(
                                                    "Consignee (ship to)",
                                                    style: TextStyle(
                                                        fontSize: 6.sp),
                                                  ),
                                            Text(
                                              value.submit2 == false
                                                  ? ''
                                                  : '${value.shippingaddressname}',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            value.submit2 == false
                                                ? const SizedBox()
                                                : Text(
                                                    "${value.shippingaddressadd1!.isEmpty ? '' : '${value.shippingaddressadd1}\n'}${value.shippingaddressadd2!.isEmpty && value.shippingaddresscity!.isEmpty ? '' : '${value.shippingaddressadd2}${value.shippingaddresscity}\n'}${value.shippingaddresspincode!.isEmpty ? '' : '${value.shippingaddresspincode}\n'}${value.shippingaddressmob!.isEmpty ? '' : 'Mob: ${value.shippingaddressmob}\n'}${value.shippingaddresslandline!.isEmpty ? '' : '${value.shippingaddresslandline}\n'}${value.shippingaddressgst!.isEmpty ? '' : 'GSTIN/UIN: ${value.shippingaddressgst}\n'}${value.shippingaddressstate!.isEmpty ? '' : 'State Name: ${value.shippingaddressstate} '}${value.shippingaddressstatecode!.isEmpty ? '' : 'Code: ${value.shippingaddressstatecode}'}",
                                                    style: TextStyle(
                                                      fontSize: 6.sp,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 88.w,
                                        width: 96.5.w,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  width: 95.5.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              right:
                                                                  BorderSide(),
                                                              bottom:
                                                                  BorderSide())),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " Buyer's order No",
                                                        style: TextStyle(
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              right:
                                                                  BorderSide(),
                                                              bottom:
                                                                  BorderSide())),
                                                  width: 95.5.w,
                                                  child: Text(
                                                    " Dispatch Doc No",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              right:
                                                                  BorderSide(),
                                                              bottom:
                                                                  BorderSide())),
                                                  width: 95.5.w,
                                                  child: Text(
                                                    " Dispatch through",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  width: 95.5.w,
                                                  child: Text(
                                                    " Terms of Delivery",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 79.h,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  width: 95.5.w,
                                                  height: 90.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide())),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        " Dated",
                                                        style: TextStyle(
                                                            fontSize: 7.sp),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide())),
                                                width: 95.5.w,
                                                child: Text(
                                                  " Delivery Note Date",
                                                  style:
                                                      TextStyle(fontSize: 7.sp),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              bottom:
                                                                  BorderSide())),
                                                  width: 95.6.w,
                                                  child: Text(
                                                    " Destination",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  width: 84.w,
                                                  child: Text(
                                                    " ",
                                                    style: TextStyle(
                                                        fontSize: 7.sp),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      right: BorderSide(),
                                    )),
                                    height: 80.h,
                                    width: 166.w,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            value.submit3 == false
                                                ? const SizedBox()
                                                : Text(
                                                    "Buyer (Bill to)",
                                                    style: TextStyle(
                                                        fontSize: 6.sp),
                                                  ),
                                            Text(
                                              value.submit3 == false
                                                  ? ''
                                                  : '${value.buyeraddressname}',
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            value.submit3 == false
                                                ? const SizedBox()
                                                : Text(
                                                    "${value.buyeraddressadd1 == null ? '' : '${value.buyeraddressadd1}\n'}${value.buyeraddressadd2 == null && value.buyeraddresscity == null ? '' : '${value.buyeraddressadd2}${value.buyeraddresscity}\n'}${value.buyeraddresspincode!.isEmpty ? '' : '${value.buyeraddresspincode}\n'}${value.buyeraddressmob!.isEmpty ? '' : 'Mob: ${value.buyeraddressmob}\n'}${value.buyeraddresslandline!.isEmpty ? '' : '${value.buyeraddresslandline}\n'}${value.buyeraddressgst!.isEmpty ? '' : 'GSTIN/UIN: ${value.buyeraddressgst}\n'}${value.buyeraddressstate!.isEmpty ? '' : 'State Name: ${value.buyeraddressstate} '}${value.buyeraddressstatecode!.isEmpty ? '' : 'Code: ${value.buyeraddressstatecode}'}",
                                                    style: TextStyle(
                                                        fontSize: 6.sp),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              height: 20.h,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 19.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 18.w,
                                        child: Text(
                                          "Sl No",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 19.h,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Text(
                                            "Description of Goods",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 7.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 19.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 40.w,
                                        child: Text(
                                          "HSN/SAC",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 19.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 42.w,
                                        child: Text(
                                          "Quantity",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 19.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 37.w,
                                        child: Text(
                                          "Rate",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 19.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 19.w,
                                        child: Text(
                                          "Per",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 19.h,
                                        width: 43.w,
                                        child: Text(
                                          "Amount",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              height: 71.h,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 70.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 18.w,
                                        child: Text(
                                          "1",
                                          style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 70.h,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    goodsname.text.isEmpty
                                                        ? ''
                                                        : goodsname.text,
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              20.verticalSpace,
                                              selectedValue == '1'
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "OUTPUT CGST ${value.taxs ?? ''}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      6.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "OUTPUT SGST ${value.taxs ?? ''}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      6.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "OUTPUT IGST ${value.taxs ?? ''}",
                                                          style: TextStyle(
                                                              fontSize: 6.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Less",
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "ROUND OFF",
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 70.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 40.w,
                                        child: Text(
                                          hsn.text,
                                          style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 70.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 42.w,
                                        child: Text(
                                          "${goodsqty.text} NOS",
                                          style: TextStyle(
                                              fontSize: 5.5.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Container(
                                        height: 70.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 37.w,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  goodsprice.text,
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            20.verticalSpace,
                                            selectedValue == '1'
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            value.taxs == null
                                                                ? ''
                                                                : value.taxs
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            value.taxs == null
                                                                ? ''
                                                                : value.taxs
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        value.taxs == null
                                                            ? ''
                                                            : value.taxs
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 6.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 70.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 19.w,
                                        child: Column(
                                          children: [
                                            Text(
                                              "NOS",
                                              style: TextStyle(
                                                  fontSize: 6.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            20.verticalSpace,
                                            selectedValue == '1'
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            " %",
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            " %",
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Text(
                                                        " %",
                                                        style: TextStyle(
                                                            fontSize: 6.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 70.h,
                                        width: 43.w,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  value.amount == null
                                                      ? ''
                                                      : value.amount.toString(),
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                            20.verticalSpace,
                                            selectedValue == '1'
                                                ? Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            value.taxttotal ==
                                                                    null
                                                                ? ''
                                                                : "${value.taxttotal!}",
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            value.taxttotal ==
                                                                    null
                                                                ? ''
                                                                : "${value.taxttotal!}",
                                                            style: TextStyle(
                                                                fontSize: 6.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        value.taxttotal == null
                                                            ? ''
                                                            : "${value.taxttotal!}",
                                                        style: TextStyle(
                                                            fontSize: 6.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "(-)0.${value.roundoff ?? ''}",
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              height: 14.85.h,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 14.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 18.w,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 14.h,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total ",
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 14.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 40.w,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 14.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 42.w,
                                        child: Text(
                                          "${goodsqty.text} NOS",
                                          style: TextStyle(
                                              fontSize: 6.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 14.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 37.w,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 14.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 19.w,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14.h,
                                        width: 43.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "₹ ${value.grandtotal ?? 0}",
                                                style: TextStyle(
                                                    fontSize: 6.sp,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(),
                                    right: BorderSide(),
                                    bottom: BorderSide())),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(" Amount Chargable (in words)",
                                        style: TextStyle(
                                            fontSize: 7.sp,
                                            fontWeight: FontWeight.w500)),
                                    Text("E & O.E ",
                                        style: TextStyle(
                                            fontSize: 7.sp,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            " INR ${value.word ?? ''} Only",
                                            style: TextStyle(
                                                fontSize: 7.sp,
                                                fontWeight: FontWeight.w800)),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                          Container(
                              height: 27.sp,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 26.sp,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Text(
                                            "HSN/SAC",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 26.sp,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 50.sp,
                                        child: Text(
                                          "Taxable Value",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 26.sp,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 70.sp,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 70.sp,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide())),
                                              child: Text(
                                                selectedValue == '1'
                                                    ? "Central Tax"
                                                    : "Integrated Tax",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 8.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 12.5.h,
                                                  width: 23.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                              right:
                                                                  BorderSide())),
                                                  child: Text(
                                                    " Rate ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 8.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Text(
                                                  "Amount ",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 8.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      selectedValue == '1'
                                          ? Container(
                                              height: 26.sp,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide())),
                                              width: 70.sp,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 70.sp,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                bottom:
                                                                    BorderSide())),
                                                    child: Text(
                                                      "State Tax",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 8.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 12.5.h,
                                                        width: 23.w,
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                                    right:
                                                                        BorderSide())),
                                                        child: Text(
                                                          " Rate ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 8.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Amount ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        height: 26.sp,
                                        width: 50.sp,
                                        child: Text(
                                          "Total",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              height: 26.sp,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 25.sp,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Text(
                                            hsn.text.isEmpty ? '' : hsn.text,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 7.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 25.sp,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 50.sp,
                                        child: Text(
                                          value.amount == null
                                              ? ''
                                              : value.amount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 25.sp,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 70.sp,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 23.w,
                                              height: 25.sp,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide())),
                                              child: Text(
                                                value.taxs == null
                                                    ? ''
                                                    : value.taxs.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 7.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  value.taxttotal == null
                                                      ? ''
                                                      : "${value.taxttotal!}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      selectedValue == '1'
                                          ? Container(
                                              height: 25.sp,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide())),
                                              width: 70.sp,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 25.sp,
                                                    width: 23.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                right:
                                                                    BorderSide())),
                                                    child: Text(
                                                      value.taxs == null
                                                          ? ''
                                                          : value.taxs
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 7.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        value.taxttotal == null
                                                            ? ''
                                                            : "${value.taxttotal!}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 7.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        height: 25.sp,
                                        width: 50.sp,
                                        child: Text(
                                          value.taxttotal == null
                                              ? ''
                                              : "${selectedValue == '1' ? value.taxttotal! + value.taxttotal! : value.taxttotal}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                              height: 16.h,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(),
                                      right: BorderSide(),
                                      bottom: BorderSide())),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 15.h,
                                          decoration: const BoxDecoration(
                                              border:
                                                  Border(right: BorderSide())),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Total  ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 7.sp,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 15.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 50.sp,
                                        child: Text(
                                          value.amount == null
                                              ? ''
                                              : value.amount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Container(
                                        height: 15.h,
                                        decoration: const BoxDecoration(
                                            border:
                                                Border(right: BorderSide())),
                                        width: 70.sp,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 15.h,
                                              width: 23.w,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide())),
                                              child: const Text(
                                                "          ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  value.taxttotal == null
                                                      ? ''
                                                      : "${value.taxttotal!}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      selectedValue == '1'
                                          ? Container(
                                              height: 15.h,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide())),
                                              width: 70.sp,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 23.w,
                                                    height: 15.h,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                right:
                                                                    BorderSide())),
                                                    child: const Text(
                                                      "          ",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        value.taxttotal == null
                                                            ? ''
                                                            : "${value.taxttotal!}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 7.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        height: 15.h,
                                        width: 50.sp,
                                        child: Text(
                                          value.taxttotal == null
                                              ? ''
                                              : "${selectedValue == '1' ? value.taxttotal! + value.taxttotal! : value.taxttotal}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 7.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(),
                                    right: BorderSide(),
                                    bottom: BorderSide())),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Tax Amount (in words): ",
                                      style: TextStyle(
                                        fontSize: 7.sp,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "INR ${value.taxword ?? ''} only",
                                        style: TextStyle(
                                            fontSize: 7.sp,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          " Declaration",
                                          style: TextStyle(
                                            fontSize: 7.sp,
                                          ),
                                        ),
                                        Text(
                                          " We declare that this invoice shows the actual price of the ",
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                        Text(
                                          " goods described and that all particulars are true and ",
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                        Text(
                                          " correct",
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 31.h,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(),
                                                top: BorderSide())),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "for STONEAGE INDUSTRIES ",
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Authorized Signatory ",
                                                  style: TextStyle(
                                                    fontSize: 6.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          3.verticalSpace,
                          Text(
                            "This is a Computer Generated Invoice",
                            style: TextStyle(
                                fontSize: 6.sp, fontWeight: FontWeight.w700),
                          )

                          //tablellll
                        ])),
                  ),
                ),
              );
            }))
      ]),
    );
  }
}
