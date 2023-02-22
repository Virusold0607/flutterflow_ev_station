import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/bloc.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool loading = false;
  bool signedUp = false;
  User? firebaseUser;

  @override
  Widget build(BuildContext context) {
    signedUp = GoogleAuth.firebaseUser != null;
    return loading
        ? const Center(child: CircularProgressIndicator())
        : BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final favoriteBloc = context.read<FavoritesBloc>();
              return Scaffold(
                body: signedUp
                    ? ProfileWidget(
                        onLogOut: () async {
                          setState(() {
                            loading = true;
                          });
                          await GoogleAuth.signOutGoogle(context);
                          if (GoogleAuth.firebaseUser == null) {
                            favoriteBloc.add(FavoritesClear());
                            signedUp = false;
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                      )
                    : SignUpWidget(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          await GoogleAuth.signInWithGoogle(context);
                          if (GoogleAuth.firebaseUser != null) {
                            signedUp = true;
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                      ),
              );
            },
          );
  }
}
