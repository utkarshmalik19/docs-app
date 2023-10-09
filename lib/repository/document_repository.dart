import 'dart:convert';

import 'package:docs_app/models/document_model.dart';
import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/utils/consts.dart';
import 'package:http/http.dart';

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexcepted error occurred', data: null);
    var res = await _client.post(Uri.parse('$serverUrl/doc/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
        body: jsonEncode({'createdAt': DateTime.now().millisecondsSinceEpoch}));
    try {
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      errorModel = ErrorModel(error: res.body, data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexcepted error occurred', data: null);
    var res = await _client.get(Uri.parse('$serverUrl/docs/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
       );
    try {
      switch (res.statusCode) {
        case 200:
        List<DocumentModel> documents = [];
        for(int i=0 ; i<jsonDecode(res.body).length; i++){
          documents.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      errorModel = ErrorModel(error: res.body, data: null);
    }
    return errorModel;
  }
}
