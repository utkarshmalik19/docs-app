import 'package:docs_app/presentation/screens/home_page.dart';
import 'package:docs_app/presentation/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
'/': (route) => MaterialPage(child: LoginPage())
});

final loggedInRoute = RouteMap(routes: {
'/': (route) => MaterialPage(child: HomePage())
});