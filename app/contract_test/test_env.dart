/// Service-role and URL readers for contract-test cleanup.
///
/// Repository calls use [Environment] (anon key). Only cleanup helpers
/// read [serviceRoleKey].
abstract final class TestEnv {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const serviceRoleKey = String.fromEnvironment(
    'SUPABASE_SERVICE_ROLE_KEY',
  );
}
