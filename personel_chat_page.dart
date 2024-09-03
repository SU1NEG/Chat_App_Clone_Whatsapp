import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImageUrl;

  ChatScreen({required this.userName, required this.userImageUrl});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = List.generate(20, (index) => "Mesaj $index");
  Set<int> starredMessages = {};
  String? replyMessage;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  userName: widget.userName,
                  userImageUrl: widget.userImageUrl,
                  starredMessages: starredMessages,
                  messages: messages,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userImageUrl),
              ),
              SizedBox(width: 10),
              Text(widget.userName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Daha fazla seçenek için tıklama olayları
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (replyMessage != null)
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Icon(Icons.reply, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(child: Text("Cevapla: $replyMessage")),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        replyMessage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    _showMessageOptions(context, index);
                  },
                  child: ChatBubble(
                    message: messages[index],
                    isSentByMe: index % 2 == 0,
                    isStarred: starredMessages.contains(index),
                  ),
                );
              },
            ),
          ),
          MessageInput(
            onSend: (message) {
              setState(() {
                if (replyMessage != null) {
                  messages.add("Cevaplanan: $replyMessage\n$message");
                  replyMessage = null;
                } else {
                  messages.add(message);
                }
                _controller.clear();
              });
            },
            controller: _controller,
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.star, color: Colors.white),
              title: Text('Yıldız Ekle', style: TextStyle(color: Colors.white)),
              tileColor: Colors.orange,
              onTap: () {
                setState(() {
                  if (starredMessages.contains(index)) {
                    starredMessages.remove(index);
                  } else {
                    starredMessages.add(index);
                  }
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.reply, color: Colors.white),
              title: Text('Cevapla', style: TextStyle(color: Colors.white)),
              tileColor: Colors.orange,
              onTap: () {
                setState(() {
                  replyMessage = messages[index];
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forward, color: Colors.white),
              title: Text('İlet', style: TextStyle(color: Colors.white)),
              tileColor: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonsHomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: Colors.white),
              title: Text('Kopyala', style: TextStyle(color: Colors.white)),
              tileColor: Colors.orange,
              onTap: () {
                Clipboard.setData(ClipboardData(text: messages[index]));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.white),
              title: Text('Sil', style: TextStyle(color: Colors.white)),
              tileColor: Colors.orange,
              onTap: () {
                setState(() {
                  messages.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final bool isStarred;

  ChatBubble({
    required this.message,
    required this.isSentByMe,
    required this.isStarred,
  });

  List<String> _splitMessage(String message, int chunkSize) {
    List<String> chunks = [];
    for (int i = 0; i < message.length; i += chunkSize) {
      int end =
          (i + chunkSize < message.length) ? i + chunkSize : message.length;
      chunks.add(message.substring(i, end));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    List<String> splitMessage = _splitMessage(message, 30);

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSentByMe
              ? Colors.orange
              : const Color.fromARGB(255, 236, 236, 236),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment:
              isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isStarred)
              Align(
                alignment: isSentByMe ? Alignment.topRight : Alignment.topLeft,
                child: Icon(Icons.star, color: Colors.yellow, size: 16),
              ),
            SizedBox(height: isStarred ? 5 : 0),
            ...splitMessage.map((part) => Text(
                  part,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final Function(String) onSend;
  final TextEditingController controller;

  MessageInput({required this.onSend, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconTheme(
            data: IconThemeData(color: Colors.white),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // Belge ekleme olayları
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Fotoğraf ekleme olayları
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Bir mesaj yazın...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          IconTheme(
            data: IconThemeData(color: Colors.white),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    onSend(controller.text);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    // Ses kaydı başlatma olayları
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userImageUrl;
  final Set<int> starredMessages;
  final List<String> messages;

  ProfilePage({
    required this.userName,
    required this.userImageUrl,
    required this.starredMessages,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: userImageUrl.isNotEmpty
                      ? NetworkImage(userImageUrl)
                      : AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
                SizedBox(height: 20),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          _buildContainerTile(
            context,
            icon: Icons.photo,
            title: 'Medya, Bağlantılar ve Belgeler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaLinksDocumentsPage(),
                ),
              );
            },
          ),
          _buildContainerTile(
            context,
            icon: Icons.star,
            title: 'Yıldızlı Mesajlar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StarredMessagesPage(
                    starredMessages: starredMessages
                        .map((index) => messages[index])
                        .toList(),
                  ),
                ),
              );
            },
          ),
          _buildContainerTile(
            context,
            icon: Icons.notifications,
            title: 'Bildirimler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(),
                ),
              );
            },
          ),
          _buildContainerTile(
            context,
            icon: Icons.lock,
            title: 'Gizlilik ve Güvenlik',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyAndSecurityPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContainerTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        color: Color.fromARGB(199, 255, 153, 0), // Turuncu arka plan rengi
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: TextStyle(color: Colors.white)),
          onTap: onTap,
        ),
      ),
    );
  }
}

class MediaLinksDocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Medya, Bağlantılar ve Belgeler',
              style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Medya'),
              Tab(text: 'Bağlantılar'),
              Tab(text: 'Belgeler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MediaTab(),
            LinksTab(),
            DocumentsTab(),
          ],
        ),
      ),
    );
  }
}

class MediaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Gönderilen Medya'));
  }
}

class LinksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Gönderilen Bağlantılar'));
  }
}

class DocumentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Gönderilen Belgeler'));
  }
}

class StarredMessagesPage extends StatelessWidget {
  final List<String> starredMessages;

  StarredMessagesPage({required this.starredMessages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Yıldızlı Mesajlar', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: starredMessages.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(
                  vertical: 8.0), // Vertical margin between cards
              elevation: 4, // Shadow depth
              color: Color.fromARGB(234, 255, 153, 0), // Card background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0), // Padding inside the card
                title: Text(
                  starredMessages[index],
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white), // Optional: Adjust font size
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool isMuted = false;
  String selectedTone = 'Varsayılan';

  List<String> tones = ['Varsayılan', 'Ton 1', 'Ton 2', 'Ton 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Bildirimler', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Padding from the edges of the screen
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0), // Margin between cards
              elevation: 4, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              color: Colors.orange, // Card background color
              child: SwitchListTile(
                title:
                    Text('Sessize Al', style: TextStyle(color: Colors.white)),
                value: isMuted,
                onChanged: (bool value) {
                  setState(() {
                    isMuted = value;
                  });
                },
                activeColor:
                    Colors.white, // Color of the switch when it's active
                inactiveThumbColor:
                    Colors.white, // Color of the switch when it's inactive
                contentPadding: EdgeInsets.all(16.0), // Padding inside the card
                tileColor: Colors.orange, // Background color of the tile
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0), // Margin between cards
              elevation: 4, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              color: Colors.orange, // Card background color
              child: ListTile(
                title: Text('Bildirim Sesi',
                    style: TextStyle(color: Colors.white)),
                subtitle:
                    Text(selectedTone, style: TextStyle(color: Colors.white)),
                onTap: () {
                  _showTonePicker(context);
                },
                contentPadding: EdgeInsets.all(16.0), // Padding inside the card
                tileColor: Colors.orange, // Background color of the tile
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTonePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bildirim Sesi Seç',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: tones.map((String tone) {
              return RadioListTile<String>(
                title: Text(tone, style: TextStyle(color: Colors.white)),
                value: tone,
                groupValue: selectedTone,
                onChanged: (String? value) {
                  setState(() {
                    selectedTone = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
          backgroundColor: Colors.orange,
        );
      },
    );
  }
}

class PrivacyAndSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title:
            Text('Gizlilik ve Güvenlik', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Gizlilik ve Güvenlik Politikası'),
      ),
    );
  }
}

class PersonsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişiler'),
      ),
      body: Center(
        child: Text('Kişi Listesi'),
      ),
    );
  }
}
