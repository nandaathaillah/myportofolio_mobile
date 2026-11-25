import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';
/// [ItemCard] is a reusable, interactive button widget.
/// 
/// It wraps an [ItemHomepage] configuration in an [InkWell] to provide 
/// Material touch ripples and triggers a localized [SnackBar] notification 
/// upon user interaction.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
            // Navigate to the appropriate screen
          
          if (item.name == "Add Project") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProjectFormPage(),
              ),
            );
          } else if (item.name == "Add Experience") {
            final ok = await ensureAuthenticated(context);
            if (!ok || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExperienceFormPage(),
              ),
            );
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You pressed the ${item.name} button!"))
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// A reusable data model representing a single interactive menu item.
/// 
/// Holds the configuration for the button's display [name] and graphical [icon].
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}


