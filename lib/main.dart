import 'package:docs_app/models/error_model.dart';
import 'package:docs_app/presentation/screens/home_page.dart';
import 'package:docs_app/presentation/screens/login_page.dart';
import 'package:docs_app/repository/auth_repository.dart';
import 'package:docs_app/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    
    super.initState();
    getUserData();
  }
  void getUserData() async{
   errorModel = await ref.read(authRepositoryProvider).getUserData(); 
   if(errorModel!=null && errorModel!.data !=null){
    ref.read(userProvider.notifier).update((state) => errorModel!.data);
   }
  }
  @override
  Widget build(BuildContext context) {
    
    return  MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final user = ref.watch(userProvider);
        if(user!=null && user.token.isNotEmpty){
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: RoutemasterParser(),
      
    );
  }
  
  
}