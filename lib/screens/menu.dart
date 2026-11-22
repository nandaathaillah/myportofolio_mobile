import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  ///Main dashboard screen for the portofolio app.
  ///It acts as a stateless container that manages and displays the user
  ///via [InfoCard]s and provides navigation capabilities via a grid of [ItemCard]s.

  MyHomePage({super.key});

  ///String variables to hold user information
  final String npm = "2506557425"; 
  final String name = "Nanda Athaillah Nurano";
  final String className = "PBP KKI"; 
  
  ///List of items to be displayed in the grid view, each represented by an [ItemHomepage] object.
  final List<ItemHomepage> items = [
    ItemHomepage("View Projects", Icons.folder, const Color(0xFF0066FF)),
    ItemHomepage("Add Project", Icons.add_circle, const Color(0xFF0066FF)),
    ItemHomepage("Add Experience", Icons.work, const Color(0xFF0066FF)),
    ItemHomepage("Logout", Icons.logout, const Color(0xFF0066FF)),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding : const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
          //Horizontal list of items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
            ],
          ),
          const SizedBox(height: 16.0),
          //Centers the interactive grid of portfolio actions
          Center(
            child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to MyPortfolio Mobile!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,// Ensures the grid only takes up necessary space
                    // Dynamically maps the ItemHomepage data model to visual ItemCard widgets
                    children: items.map<Widget>((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
          )
          ]
        )
      )
    );
  }
}


/// [InfoCard] is a reusable, static display widget.
/// It's designed to render a short [title] and it's [content]
/// in a clean, card-like format. Primarily used for a profile data.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}
