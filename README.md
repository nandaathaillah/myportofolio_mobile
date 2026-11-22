# myportofolio_mobile

## Project Description
MyPortfolio Mobile is a basic cross-platform Flutter application that serves as a personal portfolio dashboard. It features a custom visual aesthetic and displays user identity information alongside interactive action buttons.

## Setup Instructions
1. Clone this repository.
2. Open the project folder in VS Code.
3. Open the terminal and run `flutter pusb get` to load dependencies.
4. Run `flutter run` to launch the application in your browser or emulator of your choice.

## AI Disclosure
During this assignment, I used Google's Gemini :
* Troubleshooting and resolving duplicate `MyHomePage` class errors.
* Implementing a custom Hex color code (`0xFF0066FF`) for the overarching Material theme.


### Assignment 7

1. **Explain what a widget tree is in Flutter and how parent-child relationships work between widgets.**
   In Flutter, the UI is built using a tiered structure called a widget tree. Every element on the screen is a widget, and these widgets are nested inside one another. The parent-child relationship means that a parent widget dictates the layout, constraints, and styling of the child widgets nested inside. For example, 'Scaffold' (parent) contains a 'Column' (child), which in turn acts as a parent to multiple 'Row' and 'GridView' widgets (it's children).

2. **List all the widgets you used in this project and explain each of their functions.**
   * **MaterialApp:** The root widget that provides Material Design theming, navigation, and global configuration.
   * **Scaffold:** Provides the basic visual layout structure (like the app bar and body canvas) for a standard Material screen.
   * **AppBar:** The top navigation bar displaying the app's title.
   * **Column / Row:** Layout widgets that arrange their children vertically (Column) or horizontally (Row).
   * **Center:** A layout widget that perfectly centers its child within itself.
   * **Padding:** Adds empty space (insets) around its child widget.
   * **SizedBox:** A simple box used here to create fixed vertical spacing between widgets.
   * **Card / Material:** Container widgets that provide elevated surfaces, drop shadows, and background colors.
   * **Container:** A versatile widget used to apply specific width constraints and padding to the `InfoCard`.
   * **Text:** Renders formatted strings of text on the screen.
   * **Icon:** Displays glyphs from the Material Icons library.
   * **GridView:** A scrollable, 2D array of widgets used to display the action buttons in a 3-column grid.
   * **InkWell:** A rectangular area that responds to touch with a Material ripple effect.
   * **SnackBar:** A lightweight pop-up message displayed at the bottom of the screen upon button interaction.

3. **What is the purpose of the MaterialApp widget? Explain why this widget is commonly used as the root widget in Flutter applications.**
    'MaterialApp' is a convenience widget that wraps several widgets commonly required for applications implementing Material Design. It's used as the root widget because it establishes the global state for the app's routing (navigation), overarching visual theme ('ThemeData'), localization and system overlays. Without it, we havef to manually configure these core settings for every page.

4. **Explain the difference between StatelessWidget and StatefulWidget. When should you choose StatelessWidget, and when is StatefulWidget necessary?**
   * A `StatelessWidget` is immutable (once it is built, it cannot be change/modified). It's used for static UI elements that depends only on the configuration provided when they were built (Like `InfoCard` and `ItemCard`). 
   * A `StatefulWidget` is mutable (state that can update dynamically over time (like a user filling out a form or a counter incrementing)). Choose a `StatefulWidget` when the UI needs to redraw itself in response to user interactions or incoming data after the initial build.

5. **What is BuildContext and why is it crucial in Flutter? How is it used inside the build method?**
    'BuildContext' tells Flutter where a widget is located within the widget tree. It's important because it allows widgets to interact with their parents and access globally provided data. Inside the 'buid' method, it's used to look up the tree to find inherited configurations. Ex: 'Theme.of(content)' uses the 'BuildContext' to find the nearest 'MaterialApp' theme to apply the blue colorand `ScaffoldMessenger.of(context)` uses it to find the nearest `Scaffold` to display the `SnackBar`.


6. **Explain the concept of hot reload in Flutter and how it differs from hot restart. When can you not rely on hot reload and must instead perform a hot restart or full restart?**

    Hot Reload injects updated source code files directly into the running Dart Virtual Machine (VM), instantly updating the UI while preserving the app's current state. Hot Restart, on the other hand, completely destroys the app's state and recompile the code from scratch, starting the app back at the default screen. Hot Reload isn't reliable and a Hot or Full Restart is needed when adding new assets, tweaking global variables, editing main(), or pulling in new packages in pubspec.yaml.

### Assignment 8

1. **Differences between `Navigator.push()`, `Navigator.pushReplacement()`, and `Navigator.pop()`:**
   - **`Navigator.push()`** adds a new route on top of the current navigation stack, keeping the previous screen underneath so the user can return to it.
   - **`Navigator.pushReplacement()`** removes the current top route from the stack and replaces it with the new route, preventing the stack from growing endlessly when switching top-level screens.
   - **`Navigator.pop()`** removes the current top route from the stack and returns the user to the route immediately underneath it (or closes a modal/dialog).
   - **Action card navigation:** Opening the Experience form from the home screen's action card uses **`Navigator.push()`** so the user can return to the dashboard using the system Back button.
   - **Drawer Home option:** Selecting **Home** in `LeftDrawer` calls **`Navigator.pushReplacement()`** with `MyHomePage()`, replacing the current form screen with the home screen so pressing Back afterward does not bounce the user back into the form.

2. **Consistency via `Scaffold`, `AppBar`, and `Drawer`:**
   - Wrapping every screen (`MyHomePage`, `ProjectFormPage`, and `ExperienceFormPage`) in a `Scaffold` with a shared `AppBar` structure and the same reusable `LeftDrawer` widget ensures identical top-bar placement, navigation behavior, and visual hierarchy across the app.
   - **Theme color reuse example:** The portfolio's primary blue (`Color(0xFF0066FF)`, accessed via `Theme.of(context).colorScheme.primary`) is consistently applied to the `AppBar` background on `MyHomePage`, `ProjectFormPage`, and `ExperienceFormPage`, as well as the `DrawerHeader`, the `Save` `ElevatedButton`, and the active `SwitchListTile` / skill `InputChip` accents.

3. **Form layout, spacing, and scrolling:**
   - The form uses a `SingleChildScrollView` wrapping a `Column` of padded input fields (`TextFormField`, `DropdownButtonFormField`, `SwitchListTile`, `Row` of date picker buttons, and `Wrap` for skill chips) to present fields in a clean, scannable vertical flow.
   - When screen space is limited—such as on narrow phone screens or when the on-screen keyboard pops up—`SingleChildScrollView` prevents `RenderFlex` overflow errors and lets the user scroll smoothly to reach every input and the **Save** button. Meanwhile, `Padding`, `SizedBox`, and `Wrap` keep touch targets comfortably separated and allow dynamic elements like skill chips to wrap onto new lines without clipping horizontally.

4. **Roles of `GlobalKey<FormState>`, `validator`, and `validate()`:**
   - **`GlobalKey<FormState>`** (`_formKey`) uniquely identifies the `Form` widget and provides access to its `FormState` from outside the form tree.
   - **`validator`** is a callback attached to each `TextFormField` that inspects the current input and returns an error string if invalid (or `null` if valid).
   - **`validate()`** (`_formKey.currentState!.validate()`) triggers every field's `validator` at once when **Save** is pressed, displaying inline error messages next to any failing fields and returning `true` only if all fields pass.
   - **Example of a rejected value:** Entering only spaces (`"   "`) in the **Role / Position** field is rejected because `value.trim().isEmpty` catches whitespace-only input (and selecting an End Date earlier than the Start Date is rejected by `_validateDates()`). Choosing a specific input widget or keyboard type alone is insufficient because keyboards only hint at input format—users can still leave required fields blank, paste invalid text, enter whitespace, or pick logically invalid date ranges, all of which require explicit validation logic.

## AI Disclosure for Assigment 8
- **Tools Used:** Gemini.
- **Prompt Strategy & Assisted Parts:** Used to design `ExperienceFormPage` model fields, scaffold the form layout (`showDatePicker`, `SwitchListTile` for "Currently Working Here", and `InputChip` skill tags), wire up `LeftDrawer` and `ItemCard` navigation.
- **Limitations & Manual Fixes:** AI-generated Flutter codes can sometimes reference API properties that differ across Flutter SDK versions (things like `activeThumbColor` vs. `activeColor` or `withValues` vs. `withOpacity`) and cannot directly run the app. All navigation flows (action card `push` vs. drawer `pushReplacement`), validation edge cases (empty/whitespace inputs and inverted date ranges), and `flutter analyze` checks were manually tested and verified locally in Chrome and VS Code.