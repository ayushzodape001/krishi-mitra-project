// main.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';

// --- CONFIGURATION ---
const String apiUrl = "https://krishi-mitra-backend-cqk7.onrender.com/chat"; // Replace with your URL

void main() {
  runApp(const KarsApp());
}

// --- BLACK & GREEN THEME ---
const Color kBackgroundColor = Color(0xFF121212);
const Color kPrimaryGreen = Color(0xFF22F59B);
const Color kAiBubbleColor = Color(0xFF2E2E2E);
const Color kTextColor = Color(0xFFE1E1E1);
const Color kHintTextColor = Color(0xFF888888);

// --- APP THEME & SETUP ---
class KarsApp extends StatelessWidget {
  const KarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krishi Mitra',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply(bodyColor: kTextColor)),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// --- DATA MODEL ---
class Message {
  final String text;
  final bool isUser;
  final File? image;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, this.image}) : timestamp = DateTime.now();
}

// --- CHAT SCREEN WIDGET ---
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }
  
  void _addInitialMessage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _addMessageToList(Message(text: "Hello! I am Krishi Mitra, your agricultural assistant.", isUser: false));
  }

  void _addMessageToList(Message message) {
    _messages.insert(0, message);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 600));
  }

  // --- API LOGIC ---
  Future<void> _sendMessage({String? text, File? image}) async {
    if ((text == null || text.isEmpty) && image == null) return;

    final userMessage = Message(text: text ?? "", isUser: true, image: image);
    setState(() => _isLoading = true);
    _addMessageToList(userMessage);
    _textController.clear();

    String? base64Image;
    if (image != null) {
      final bytes = await image.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text ?? '', 'image': base64Image}),
      );
      
      setState(() => _isLoading = false);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _addMessageToList(Message(text: data['answer'], isUser: false));
      } else {
        _handleError("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _handleError("Error: Connection Failed");
    }
  }

  void _handleError(String message) {
    _addMessageToList(Message(text: message, isUser: false));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      _sendMessage(text: _textController.text, image: File(pickedFile.path));
    }
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // --- UI BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                return _buildAnimatedMessageItem(_messages[index], animation);
              },
            ),
          ),
          if (_isLoading) const TypingIndicator(),
          _buildChatInput(),
          _buildTeamCredit(),
        ],
      ),
    );
  }
  
  // --- AESTHETIC WIDGETS ---
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Text(
        'Krishi Mitra',
        style: GoogleFonts.inter(
          color: kTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnimatedMessageItem(Message message, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
        child: _MessageBubble(message: message),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.fromLTRB(16,0,16,12),
      decoration: BoxDecoration(
        color: kAiBubbleColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: kTextColor, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Ask a question...',
                hintStyle: TextStyle(color: kHintTextColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
              onSubmitted: (text) => _sendMessage(text: text),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo_outlined, color: kHintTextColor),
            onPressed: _pickImage,
          ),
          const SizedBox(width: 4),
          AnimatedSendButton(
            onTap: () => _sendMessage(text: _textController.text),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTeamCredit() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              "Made with ♥ by Team Code_Crew",
              style: GoogleFonts.inter(
                color: kHintTextColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- MESSAGE BUBBLE & ANIMATION WIDGETS ---
class _MessageBubble extends StatelessWidget {
  final Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isUser ? kPrimaryGreen : kAiBubbleColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: Image.file(message.image!)),
              ),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.black : kTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      )..repeat(reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 150), () { if(mounted) _controllers[1].forward(); });
    Future.delayed(const Duration(milliseconds: 300), () { if(mounted) _controllers[2].forward(); });
  }

  @override
  void dispose() {
    for (var controller in _controllers) { controller.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: List.generate(3, (index) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: _controllers[index], curve: Curves.easeOut),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: const CircleAvatar(radius: 4, backgroundColor: kHintTextColor),
            ),
          );
        }),
      ),
    );
  }
}

class AnimatedSendButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedSendButton({super.key, required this.onTap});

  @override
  State<AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<AnimatedSendButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), reverseDuration: const Duration(milliseconds: 300));
     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut, reverseCurve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: const CircleAvatar(
          radius: 22,
          backgroundColor: kPrimaryGreen,
          child: Icon(Icons.arrow_upward, color: Colors.black, size: 24),
        ),
      ),
    );
  }
}

