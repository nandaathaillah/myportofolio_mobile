import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../state/auth_state.dart';

Future<bool> ensureAuthenticated(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (auth.isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return loggedIn == true && auth.isLoggedIn;
}