import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0066FF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  auth.isLoggedIn
                      ? 'Signed in as ${auth.username}'
                      : 'Explore personal projects and experiences!',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('Experiences'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () async {
              final ok = await ensureAuthenticated(context);
              if (!ok || !context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExperienceFormPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
            title: Text(auth.isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              if (auth.isLoggedIn) {
                await context.read<AuthState>().logout();
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out.')),
                );
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}