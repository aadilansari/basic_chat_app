import 'package:basic_chat_app/core/localization/app_localization.dart';
import 'package:basic_chat_app/core/widgets/custom_appbar.dart';
import 'package:basic_chat_app/data/models/user_model.dart';
import 'package:basic_chat_app/data/services/paired_user_storage_service.dart';
import 'package:basic_chat_app/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_page.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }  

  Future<void> _loadUsers() async {
    users = await PairedUserStorageService().getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final currentUser = ref.watch(authProvider);

    return Scaffold(
  appBar:CustomAppBar(
  title: t.translate('home'),
  hideBackButton: true,
),
  body: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    
    children: [
      const SizedBox(height: 20),
      Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Hero(
                     tag: 'profile-avatar',
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/icon/icon.png"),
                    ),
                  ),
                
                ],
              ),
              const SizedBox(height: 12),
              Text(
               currentUser?.name?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
              currentUser?.email?? 'Unknown',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
               const SizedBox(height: 4),
              Text(
              currentUser?.phone?? 'Unknown',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 30),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(),
      ),
       Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Text(
         t.translate('chat_list'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
     
       Expanded(
            child: users.isEmpty
                ? Center(child: Text(t.translate('no_paired_user_found')))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, index) {
                      final user = users[index];
                      return  GestureDetector(
                        onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(user: user),
                              ),
                            );
                        },
                        child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                          Text(
                                       user.name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                       Text(
                                       user.email,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),),
                      );
                    },
                  ),
          ),
    ],
  ),
);

  }
}
