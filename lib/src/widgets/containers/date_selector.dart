// import 'package:ahiaa_web/core/common/widgets/custom_shapes/containers/rounded_container.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_framework/responsive_framework.dart'; // Required for formatting the date

// class DatePickerContainerScreen extends StatefulWidget {
//   // 1. Add the callback function parameter
//   final Function(DateTime)? onDateSelected;

//   const DatePickerContainerScreen({
//     super.key,
//     this.onDateSelected, // Make it optional
//     this.initialDate,
//   });

//   final DateTime? initialDate;

//   @override
//   State<DatePickerContainerScreen> createState() =>
//       _DatePickerContainerScreenState();
// }

// class _DatePickerContainerScreenState extends State<DatePickerContainerScreen> {
//   // 1. State variable to hold the selected date
//   DateTime? _selectedDate;

//   // Function to show the Date Picker
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     // 2. Update the state if a date was selected
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });

//       // 3. Call the external callback function to notify the parent widget
//       widget.onDateSelected?.call(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final responsive = ResponsiveBreakpoints.of(context);

//     // 4. Format the date for display
//     final String dateDisplay = _selectedDate == null
//         ? widget.initialDate != null
//             ? DateFormat('dd/MM/yyyy').format(widget.initialDate!)
//             : 'dd/mm/yyyy'
//         : DateFormat('dd/MM/yyyy').format(_selectedDate!);

//     return TRoundedContainer(
//       width: responsive.isMobile ? double.infinity : 229,
//       height: 47.5,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       showBorder: true,
//       radius: 12,
//       // 5. Set the onTap parameter to the function that shows the date picker
//       onTap: () => _selectDate(),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               dateDisplay,
//               style: TextStyle(
//                 color: _selectedDate == null ? Colors.black : Colors.black,
//                 // fontSize: 16,
//               ),
//             ),
//             GestureDetector(
//                 onTap: () => _selectDate(),
//                 child: const MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: Icon(Iconsax.calendar_1))),
//           ],
//         ),
//       ),
//     );
//   }
// }
