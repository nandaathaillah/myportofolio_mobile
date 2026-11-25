import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../services/api_client.dart';
import '../widgets/left_drawer.dart';
import 'experience_detail_screen.dart';

class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = context.read<ApiClient>().fetchExperiences();
  }

  Future<void> _refresh() async {
    setState(() {
      _experiencesFuture = context.read<ApiClient>().fetchExperiences();
    });
    await _experiencesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiences')),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Experience>>(
          future: _experiencesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(child: Text('Error: ${snapshot.error}')),
                ],
              );
            }
            final experiences = snapshot.data ?? [];
            if (experiences.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No experiences yet.')),
                ],
              );
            }
            return ListView.builder(
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final exp = experiences[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(exp.title),
                    subtitle: Text(
                      '${exp.category} • ${exp.isOngoing ? "Ongoing" : "Completed"}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ExperienceDetailScreen(experience: exp),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}