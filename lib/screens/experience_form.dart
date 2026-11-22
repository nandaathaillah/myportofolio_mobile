import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// A form screen that allows users to add a new work or organizational
/// experience entry to their portfolio.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _skillController = TextEditingController();

  String _role = "";
  String _company = "";
  String _employmentType = "Internship";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentRole = false;
  String? _dateError;

  final List<String> _skills = [];

  final List<String> _employmentTypes = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance',
    'Organization',
  ];

  @override
  void dispose() {
     super.dispose();
  }

  /// Formats a [DateTime] into `YYYY-MM-DD`, or returns `"Not selected"` if null.
  String _formatDate(DateTime? date) {
    if (date == null) return "Not selected";
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  /// Opens a calendar modal to select either the start or end date.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _dateError = null;
      });
    }
  }

  /// Validates that a start date is chosen and that the end date (if set)
  /// does not precede the start date.
  bool _validateDates() {
    if (_startDate == null) {
      setState(() => _dateError = "Please select a start date.");
      return false;
    }
    if (!_isCurrentRole &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      setState(
        () => _dateError = "End date cannot be earlier than start date.",
      );
      return false;
    }
    setState(() => _dateError = null);
    return true;
  }

  /// Adds a trimmed, non-duplicate skill tag from [_skillController] into [_skills].
  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) return;

    final alreadyExists = _skills.any(
      (existing) => existing.toLowerCase() == skill.toLowerCase(),
    );

    if (!alreadyExists) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    } else {
      _skillController.clear();
    }
  }

  /// Resets all form fields, date selections, toggles, and skill chips.
  void _resetForm() {
    _formKey.currentState!.reset();
    _skillController.clear();
    setState(() {
      _role = "";
      _company = "";
      _employmentType = "Internship";
      _description = "";
      _startDate = null;
      _endDate = null;
      _isCurrentRole = false;
      _dateError = null;
      _skills.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Add Experience Form'),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Role / Position ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "e.g., Software Engineer Intern",
                    labelText: "Role / Position",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _role = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Role cannot be empty.";
                    }
                    if (value.trim().length > 100) {
                      return "Role must be under 100 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Company / Organization ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "e.g., Universitas Indonesia",
                    labelText: "Company / Organization",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _company = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Company or organization cannot be empty.";
                    }
                    return null;
                  },
                ),
              ),

              // === Employment Type ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Employment Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _employmentType,
                  items: _employmentTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _employmentType = newValue;
                      });
                    }
                  },
                ),
              ),

              // === Currently Working Here Toggle ===
              SwitchListTile(
                title: const Text("I currently work here"),
                value: _isCurrentRole,
                activeThumbColor: primaryColor,
                onChanged: (bool value) {
                  setState(() {
                    _isCurrentRole = value;
                    if (_isCurrentRole) {
                      _endDate = null;
                      _dateError = null;
                    }
                  });
                },
              ),

              // === Start & End Date Pickers ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickDate(isStart: true),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _startDate == null
                              ? "Start Date *"
                              : "Start: ${_formatDate(_startDate)}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            _isCurrentRole ? null : () => _pickDate(isStart: false),
                        icon: const Icon(Icons.event),
                        label: Text(
                          _isCurrentRole
                              ? "End: Present"
                              : (_endDate == null
                                  ? "End Date (Optional)"
                                  : "End: ${_formatDate(_endDate)}"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    _dateError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              // === Interactive Skill Chips ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillController,
                        decoration: InputDecoration(
                          hintText: "e.g., Flutter, Django, PostgreSQL",
                          labelText: "Skills Used (Optional)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onSubmitted: (_) => _addSkill(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addSkill,
                      icon: Icon(Icons.add_circle, color: primaryColor, size: 32),
                      tooltip: "Add Skill",
                    ),
                  ],
                ),
              ),
              if (_skills.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _skills.map((skill) {
                      return InputChip(
                        label: Text(skill),
                        backgroundColor: primaryColor.withValues(alpha: 0.12),
                        deleteIconColor: primaryColor,
                        onDeleted: () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Describe your responsibilities and achievements",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description cannot be empty.";
                    }
                    return null;
                  },
                ),
              ),

              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: () {
                      final isFormValid = _formKey.currentState!.validate();
                      final isDateValid = _validateDates();

                      if (isFormValid && isDateValid) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Experience added successfully!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Role: $_role'),
                                    Text('Company: $_company'),
                                    Text('Type: $_employmentType'),
                                    Text('Start Date: ${_formatDate(_startDate)}'),
                                    Text(
                                      'End Date: ${_isCurrentRole || _endDate == null ? "Present" : _formatDate(_endDate)}',
                                    ),
                                    Text(
                                      'Skills: ${_skills.isEmpty ? "None" : _skills.join(", ")}',
                                    ),
                                    Text('Description: $_description'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetForm();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}