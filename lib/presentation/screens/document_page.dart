import 'package:docs_app/models/document_model.dart';
import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/presentation/screens/home_page.dart';
import 'package:docs_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentPage extends ConsumerStatefulWidget {
  final String id;
  const DocumentPage({super.key, required this.id});

  @override
  ConsumerState<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(ref.read(userProvider)!.token, widget.id);
    if(errorModel!.data!=null){
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {
        
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/docs.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 100,
                    child: TextField(
                      controller: titleController,
                      onSubmitted: (value) => updateTitle(ref, value),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          contentPadding: EdgeInsets.only(left: 10)),
                    ))
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade800, width: 0.1)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  label: Text('Share')),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              quill.QuillToolbar.basic(controller: _controller),
              Expanded(
                child: SizedBox(
                  height: 750,
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
