import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/state/auth_state.dart';
import 'package:myportofolio_mobile/utils/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  bool _isSubmitting = false;
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
    'Research',
    'Volunteer',
  ];

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Not selected";
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

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

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState!.validate();
    final isDateValid = _validateDates();
    if (!isFormValid || !isDateValid) return;

    final ok = await ensureAuthenticated(context);
    if (!ok || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    setState(() => _isSubmitting = true);

    try {
      final experience = Experience(
        title: '${_role.trim()} at ${_company.trim()}',
        description: _description.trim(),
        category: _employmentType.toLowerCase(),
        isOngoing: _isCurrentRole,
      );

      await context.read<ApiClient>().createExperience(
            experience,
            token: token,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Experience saved!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ExperienceListScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to server.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                        onPressed: _isCurrentRole
                            ? null
                            : () => _pickDate(isStart: false),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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