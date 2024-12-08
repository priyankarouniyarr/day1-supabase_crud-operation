import 'package:flutter/material.dart';
import 'package:flutter_supabase_crud/homepage1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //superbase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://yxqplgoxcgbrudpxjavq.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl4cXBsZ294Y2dicnVkcHhqYXZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzNzc5MzUsImV4cCI6MjA0ODk1MzkzNX0.-QxjM88ybNe5TyIYVXz-IStSOzj2su7Z2AWhEmIjkzE');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD OPERATIONS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Homepage(),
    );
  }
}
