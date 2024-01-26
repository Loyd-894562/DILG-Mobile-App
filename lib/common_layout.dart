// import 'package:flutter/material.dart';
// import '../screens/sidebar.dart';
// // import '../screens/home_screen.dart';

// class CommonLayout extends StatelessWidget {
//   final Widget body;
//   final int currentIndex;
//   final Function(int) onItemSelected;

//   CommonLayout({
//     required this.body,
//     required this.currentIndex,
//     required this.onItemSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App Title'),
//         // Add any common app bar content
//       ),
//       body: Row(
//         children: [
//           Sidebar(
//             currentIndex: currentIndex,
//             onItemSelected: onItemSelected,
//           ),
//           Expanded(
//             child: body,
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: onItemSelected,
//         items: [], // Add your bottom navigation bar items
//       ),
//     );
//   }
// }
