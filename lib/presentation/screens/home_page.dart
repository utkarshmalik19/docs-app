import 'package:docs_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void signOut(WidgetRef ref){
    ref.read(authRepositoryProvider).signout();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add, color: Colors.black,)),
        IconButton(onPressed: () {}, icon: Icon(Icons.logout, color: Colors.black,))
      ]),
      body: Center(child: Text(ref.watch(userProvider)!.uid)),
    );
  }
}
