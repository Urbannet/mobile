import 'package:flutter/material.dart';
import 'package:fo_proprete_atalian/widgets/maintab.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 204, 204, 1.0),
      title: Center(
        child: Semantics(
          label: 'FO ATALIAN PROPRETE',
          child: InkWell(
            onTap: () {
              // Naviguez vers la page MainTab ici
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainTab()),
              );
            },
            child: Image.asset(
              'assets/images/logo.png',
              width: 190.0,
            ),
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
