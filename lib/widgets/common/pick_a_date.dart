import 'package:flutter/material.dart';
import '/resources/colors.dart';
import '/resources/utils.dart';

class PickADate extends StatefulWidget {
  final String labalText;
  final DateTime initialDate;
  final DateChangeCallback onDatePicked;
  PickADate(this.labalText,
      {required this.initialDate, required this.onDatePicked});
  @override
  _PickADateState createState() => _PickADateState();
}

class _PickADateState extends State<PickADate> {
  DateTime? date;

  @override
  void initState() {
    super.initState();
    // setDate(widget.initialDate);
  }

  TextEditingController controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    // widget.controller.text = "";
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (date != null) {
      setState(() {
        setDate();
      });
    } else {}
  }

  void setDate() {
    DateTime? dateTime;
    if (date == null) {
      dateTime = widget.initialDate;
    } else {
      dateTime = date;
    }
    if (dateTime != null) {
      controller.text = Utils.getDate(dateTime);
      widget.onDatePicked(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    setDate();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        controller: controller,
        showCursor: false,
        readOnly: true,
        style: const TextStyle(
            color: Color(ResColors.colorFontSplash), fontSize: 14),
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color(ResColors.colorPrimaryDarker),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Color(ResColors.colorPrimary))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Color(ResColors.colorPrimary))),
            labelText: widget.labalText,
            hintText: 'DD/MM/YYYY',
            hintStyle: const TextStyle(color: Color(ResColors.colorFontSplash)),
            labelStyle:
                const TextStyle(color: Color(ResColors.colorFontSplash))),
        cursorColor: const Color(ResColors.colorFontSplash),
        onTap: () => _selectDate(context),
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

typedef DateChangeCallback = void Function(DateTime selectedDate);
