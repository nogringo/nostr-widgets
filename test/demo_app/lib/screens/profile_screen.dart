import 'package:demo_app/app_routes.dart';
import 'package:demo_app/controllers/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.home);
            },
            icon: Icon(Icons.home),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GetBuilder<Repository>(
                  builder: (c) {
                    return NUserProfile(
                      ndk: Get.find<Ndk>(),
                      onLogout: () {
                        if (Get.find<Ndk>().accounts.accounts.isEmpty) {
                          Get.offAllNamed(AppRoutes.signIn);
                        }

                        Repository.to.update();
                      },
                    );
                  },
                ),
                SizedBox(height: 32),
                RelaysView(),
                SizedBox(height: 32),
                GetBuilder<Repository>(
                  builder: (c) {
                    return NWCView();
                  },
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.switchAccount);
                  },
                  child: Text("Switch account"),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NWCView extends StatelessWidget {
  const NWCView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Repository.to.nwcConnection == null) {
      return TextField(
        controller: Repository.to.nwcSecretController,
        decoration: InputDecoration(
          suffixIcon: TextButton(
            onPressed: () {
              Repository.to.nwcConnect(Repository.to.nwcSecretController.text);
            },
            child: Text("Connect"),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
          hintText: "Nostr Wallet Connect String",
        ),
        onSubmitted: (_) {
          Repository.to.nwcConnect(Repository.to.nwcSecretController.text);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              "Balance",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).dividerColor),
            ),
            Spacer(),
            FutureBuilder(
              future: Repository.to.ndk.nwc.getBalance(
                Repository.to.nwcConnection!,
              ),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? snapshot.data!.balanceSats.toString() : "",
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).dividerColor),
                );
              },
            ),
            SizedBox(width: 8),
            Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary),
          ],
        ),
        SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            Get.toNamed(AppRoutes.switchAccount);
          },
          label: Text("Disconnect NWC"),
          icon: Icon(Icons.link_off),
        ),
      ],
    );
  }
}

class RelaysView extends StatelessWidget {
  const RelaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<Ndk>().userRelayLists.getSingleUserRelayList(
        Get.find<Ndk>().accounts.getPublicKey()!,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return Column(
          children: [
            ...snapshot.data!.urls.map(
              (url) => Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                elevation: 0,
                child: ListTile(title: Text(url)),
              ),
            ),
          ],
        );
      },
    );
  }
}
