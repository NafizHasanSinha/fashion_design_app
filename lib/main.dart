import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login.dart';

// Supabase configuration credentials
const String supabaseUrl = 'https://fbwhrljmmlahxkpujmfq.supabase.co';
const String supabaseAnonKey = 'sb_publishable_ha0ahlfBKe8zpelf3LnVbQ_l4CiGA2J';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion Design Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827)),
        useMaterial3: true,
      ),
      home: const LoginSelectionScreen(),
    );
  }
}
