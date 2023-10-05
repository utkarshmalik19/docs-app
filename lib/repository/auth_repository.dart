import 'dart:convert';

import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/models/user_model.dart';
import 'package:docs_app/utils/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<UserModel?>((ref) => null);
class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel = ErrorModel(error: 'Some unexcepted error occurred', data: null);
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName!,
            profilePic: user.photoUrl!,
            uid: '',
            token: '',
            );
            var res = await _client.post(Uri.parse('$serverUrl/api/signup'), body: userAcc.toJson(), headers: {
              'Content-Type': 'application/json; charset=UTF-8'
            });
            switch(res.statusCode){
              case 200:
              final newUser = userAcc.copyWith(
                uid: jsonDecode(res.body)['user']['_id']
              );
              errorModel = ErrorModel(error: null, data: newUser);
              break;
            }
      }
    } catch (e) {
    errorModel = ErrorModel(error: e.toString(), data: null);  
    }
    return errorModel;
  }

  
}
