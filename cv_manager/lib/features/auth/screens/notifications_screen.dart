import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  final bool isDark;
  const NotificationsScreen({super.key, required this.isDark});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  
  @override
  void initState() {
    super.initState();
   
    _markAllAsRead();
  }

  
  Future<void> _markAllAsRead() async {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    
    try {
     
      var query = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in query.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
     
    } catch (e) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

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
                    "Notifications",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('receiverId', isEqualTo: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No notifications yet", style: TextStyle(color: Colors.white70))
                      );
                    }

                    var docs = snapshot.data!.docs;
                    docs.sort((a, b) {
                      var aTime = a['createdAt'] as Timestamp?;
                      var bTime = b['createdAt'] as Timestamp?;
                      if (aTime == null || bTime == null) return 0;
                      return bTime.compareTo(aTime);
                    });

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.favorite, color: Colors.redAccent),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  "${data['senderName']} ${data['message']}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
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
}