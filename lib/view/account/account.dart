import 'package:flutter/material.dart';
import 'package:port_karo/res/constant_appbar.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/view/account/widgets/account_detail.dart';
import 'package:port_karo/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}
class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: PortColor.greyLight.withOpacity(0.7),
      body: const Column(
        children: [
          ConstantAppbar(),
          AccountDetail(),
        ],
      ),
    );
  }
}
