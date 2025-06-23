// import 'package:basic_chat_app/feature/auth/view/login_page.dart';
// import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(authProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome ${user?.name ?? ''}"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               ref.read(authProvider.notifier).logout();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginPage()),
//               );
//             },
//           )
//         ],
//       ),
//       body: const Center(child: Text("This is Home Page")),
//     );
//   }
// }
