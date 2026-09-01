import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momentum/core/core.dart';

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({super.key});

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  int weekOffset = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    String monthName = DateFormat("MMMM").format(weekDates.first);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset--;
                  });
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
              Text(
                monthName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset++;
                  });
                },
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final date = weekDates[index];
                bool isSelected =
                    DateFormat('d').format(selectedDate) ==
                        DateFormat('d').format(date) &&
                    selectedDate.month == date.month &&
                    selectedDate.year == date.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepOrangeAccent : null,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("d").format(date),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat("E").format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: weekDates.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }
}
