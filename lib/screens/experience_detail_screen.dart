import 'package:material_ui/material_ui.dart';
import '../models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(experience.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text(experience.category)),
                Chip(
                  label: Text(experience.isOngoing ? 'Ongoing' : 'Completed'),
                ),
                Chip(
                  avatar: const Icon(Icons.star, size: 16),
                  label: Text('${experience.starCount}'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              experience.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}