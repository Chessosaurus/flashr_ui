import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DBInitializer{

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: 'https://alhcmnttuuzaspxtifhb.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsaGNtbnR0dXV6YXNweHRpZmhiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxMDkyMTgwNCwiZXhwIjoyMDI2NDk3ODA0fQ.GjoiLrLVKQ7noHZcw2HIPhl_boc0SgB-6Ru9wrPRxQo',
    );
  }
}