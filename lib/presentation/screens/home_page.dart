import 'dart:js';

import 'package:docs_app/models/document_model.dart';
import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/presentation/widgets/loader.dart';
import 'package:docs_app/repository/auth_repository.dart';
import 'package:docs_app/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:routemaster/routemaster.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signout();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }
  
  void navigateToDocument(BuildContext context, String documentId){
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
        IconButton(
            onPressed: () => createDocument(context, ref),
            icon: Icon(
              Icons.add,
              color: Colors.black,
            )),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ))
      ]),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 600,
              child: ListView.builder(itemCount: snapshot.data!.data.length,itemBuilder: (context, index) {
                DocumentModel document = snapshot.data!.data[index];
                return SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () => navigateToDocument(context, document.id),
                    child: Card(
                      child: Center(
                        child: Text(document.title),
                      ),
                    ),
                  ),
                );
              },),
            ),
          );
        },
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
      ),
    );
  }
}
