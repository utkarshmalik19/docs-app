import 'dart:convert';

import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/models/user_model.dart';
import 'package:docs_app/repository/local_storage_repository.dart';
import 'package:docs_app/utils/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _localStorageRepository = localStorageRepository,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexcepted error occurred', data: null);
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
        var res = await _client.post(Uri.parse('$serverUrl/api/signup'),
            body: userAcc.toJson(),
            headers: {'Content-Type': 'application/json; charset=UTF-8'});
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['user']['token'],
            );
            errorModel = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexcepted error occurred', data: null);
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse('$serverUrl/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });
        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
                jsonEncode(jsonDecode(res.body)['user']['token'])).copyWith(token: token);
            errorModel = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }
}
