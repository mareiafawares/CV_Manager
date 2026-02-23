import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cv_manager/features/cv_builder/screens/final_cv_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatefulWidget {
  final bool isDark;
  const CommunityPage({super.key, required this.isDark});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String searchQuery = "";
  final Map<String, bool> _likedProfiles = {};
  
  
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> _sendNotification(String? targetUserId, String cvName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final String finalReceiverId = (targetUserId == null || targetUserId.isEmpty) 
        ? currentUser.uid 
        : targetUserId;

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'receiverId': finalReceiverId,
        'senderName': currentUser.displayName ?? "User",
        'senderId': currentUser.uid,
        'message': "liked your CV ($cvName)",
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint("Notification Error: $e");
    }
  }

  
  void _deleteMyCV(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete CV?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will permanently remove your CV from the community. Are you sure?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('cvs').doc(docId).delete();
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("CV deleted successfully")),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDark 
                ? [const Color(0xFF0F2027), const Color(0xFF2C5364)] 
                : [const Color(0xFF6A5AE0), const Color(0xFF9587D3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Center(
                  child: Text(
                    "Talent Community",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // مربع البحث
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search creators...",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cvs')
                      .where('isPublic', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No profiles found", style: TextStyle(color: Colors.white70)));
                    }

                    var docs = snapshot.data!.docs.where((doc) {
                      var name = (doc['name'] ?? "").toString().toLowerCase();
                      return name.contains(searchQuery);
                    }).toList();

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;
                        String docId = docs[index].id;
                        return _buildGlassCard(data, docId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(Map<String, dynamic> data, String docId) {
    bool isLiked = _likedProfiles[docId] ?? false;
   
    bool isMine = data['userId'] == currentUserId;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
         
          Positioned(
            top: 12,
            right: 12,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    bool alreadyLiked = _likedProfiles[docId] ?? false;
                    setState(() { _likedProfiles[docId] = !alreadyLiked; });

                    if (!alreadyLiked) {
                      await _sendNotification(data['userId'], data['name'] ?? "User");
                      await FirebaseFirestore.instance.collection('cvs').doc(docId).update({
                        'likesCount': FieldValue.increment(1)
                      });
                    } else {
                      await FirebaseFirestore.instance.collection('cvs').doc(docId).update({
                        'likesCount': FieldValue.increment(-1)
                      });
                    }
                  },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.redAccent : Colors.white70,
                    size: 24,
                  ),
                ),
                Text(
                  "${data['likesCount'] ?? 0}",
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
         
          if (isMine)
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () => _deleteMyCV(docId),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 20),
                ),
              ),
            ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    data['name'] ?? "User",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FinalCVView(data: data))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: const Text("View", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}