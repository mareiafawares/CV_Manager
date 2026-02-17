import 'dart:ui';
import 'package:cv_manager/features/auth/screens/community_screen.dart';
import 'package:cv_manager/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart'; 

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool isDarkTheme = true; 
  bool isEditingName = false;
  final TextEditingController _nameController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? "User Name";
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // تأكدي أن عدد الصفحات هنا يساوي عدد الأيقونات في الأسفل
  List<Widget> get _pages => [
    HomeScreen(isDark: isDarkTheme), 
    CommunityPage(isDark: isDarkTheme),
    const Center(child: Text("Messages Coming Soon", style: TextStyle(color: Colors.white))), // صفحة مؤقتة للرسائل
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      endDrawer: _buildGlassDrawer(),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkTheme 
              ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
              : [const Color(0xFF6A5AE0), const Color(0xFF9587D3), const Color(0xFF00E5FF)],
          ),
        ),
        child: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _pages),
            Positioned(
              top: 50, right: 20, 
              child: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
                onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 65.0,
        items: <Widget>[
          Icon(Icons.home_rounded, size: 30, color: _currentIndex == 0 ? const Color(0xFF6A5AE0) : Colors.white),
          Icon(Icons.groups_3_rounded, size: 30, color: _currentIndex == 1 ? const Color(0xFF6A5AE0) : Colors.white),
          Icon(Icons.mark_as_unread_sharp, size: 30, color: _currentIndex == 2 ? const Color(0xFF6A5AE0) : Colors.white),
        ],
        buttonBackgroundColor: Colors.white, 
        color: isDarkTheme ? const Color(0xFF9587D3).withOpacity(0.4) : Colors.white.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildGlassDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkTheme ? const Color(0xFF0F2027).withOpacity(0.85) : const Color(0xFF2C5364).withOpacity(0.9),
            border: const Border(left: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            children: [
              _buildDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    _buildDrawerItem(Icons.language_rounded, "App Language", "العربية / English", () {}),
                    _buildDrawerItem(
                      Icons.color_lens_rounded, 
                      "Theme Mode", 
                      isDarkTheme ? "Dark Glass" : "Neon Glow", 
                      () => setState(() => isDarkTheme = !isDarkTheme)
                    ),
                    _buildDrawerItem(Icons.info_rounded, "About App", "Version 1.0.3", () {}),
                  ],
                ),
              ),
              _buildLogoutTile(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          _buildProfileAvatar(),
          const SizedBox(height: 15),
          _buildNameField(),
          Text(user?.email ?? "", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Color(0xFF9587D3), Colors.cyanAccent]),
          ),
          child: const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF0F2027),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0, right: 0,
          child: Container(
            height: 30, width: 30,
            decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: isEditingName 
      ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_rounded, color: Colors.cyanAccent, size: 28),
              onPressed: () async {
                await user?.updateDisplayName(_nameController.text);
                setState(() => isEditingName = false);
              },
            ),
          ],
        )
      : InkWell(
          onTap: () => setState(() => isEditingName = true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit_note_rounded, color: Colors.cyanAccent, size: 22),
              const SizedBox(width: 5),
              Flexible(child: Text(_nameController.text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF9587D3)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11)) : null,
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      title: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      onTap: () async {
        try {
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()), 
              (route) => false,
            );
          }
        } catch (e) {
          debugPrint("Logout error: $e");
        }
      },
    );
  }
}