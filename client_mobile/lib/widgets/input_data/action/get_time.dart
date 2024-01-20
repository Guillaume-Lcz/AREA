import 'package:flutter/material.dart';

class GetTime {
  const GetTime({required this.context});

  final BuildContext context;

  Future<DateTime?> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2024, 1, 31),
    );

    if (selectedDate != null) {
      return selectedDate;
    } else {
      return null;
    }
  }

  Future<DateTime?> selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (selectedTime != null) {
      DateTime now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    } else {
      return null;
    }
  }
}
