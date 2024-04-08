import 'package:flutter/material.dart';
import '/resources/colors.dart';
import '/resources/utils.dart';

class PickATime extends StatefulWidget {
  final String labalText;
  final TimeOfDay initialTime;
  final TimeChangeCallback onTimePicked;
  const PickATime(this.labalText,
      {super.key, required this.initialTime, required this.onTimePicked});
  @override
  _PickATimeState createState() => _PickATimeState();
}

class _PickATimeState extends State<PickATime> {
  TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    // setDate(widget.initialDate);
  }

  TextEditingController controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    // widget.controller.text = "";
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        setTime();
      });
    } else {}
  }

  void setTime() {
    TimeOfDay? dateTime;
    if (time == null) {
      dateTime = widget.initialTime;
    } else {
      dateTime = time;
    }
    if (dateTime != null) {
      controller.text = Utils.getTime(dateTime);
      widget.onTimePicked(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    setTime();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextField(
        controller: controller,
        showCursor: false,
        readOnly: true,
        style: const TextStyle(color: Color(ResColors.colorFontSplash), fontSize: 14),
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color(ResColors.colorPrimaryDark),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Color(ResColors.colorPrimary))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Color(ResColors.colorPrimary))),
            labelText: widget.labalText,
            hintText: 'HH:mm',
            hintStyle: const TextStyle(color: Color(ResColors.colorFontSplash)),
            labelStyle: const TextStyle(color: Color(ResColors.colorFontSplash))),
        cursorColor: const Color(ResColors.colorFontSplash),
        onTap: () => _selectDate(context),
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

typedef TimeChangeCallback = void Function(TimeOfDay selectedTime);
