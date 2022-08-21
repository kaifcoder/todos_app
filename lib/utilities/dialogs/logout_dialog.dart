import 'package:flutter/material.dart';
import 'package:todos_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionBuilder: () => {
      'Yes': true,
      'No': false,
    },
  ).then((value) => value ?? false);
}
