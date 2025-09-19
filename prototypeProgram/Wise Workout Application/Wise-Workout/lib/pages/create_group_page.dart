import 'package:flutter/material.dart';
import '../globals.dart';
import '../services/social_store.dart';
import '../services/auth_service_mock.dart';
import 'group_detail_page.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final social = Globals.social;
    final id = social.createGroup(
      name: _name.text.trim(),
      description: _desc.text.trim(),
    );
    // Optionally auto-join the creator (premium flow commonly does this)
    final auth = Globals.auth;
    final creatorId = auth.current?.id ?? 'guest';
    social.joinGroup(id, creatorId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GroupDetailPage(groupId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g., Early Risers',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What is this group about?',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter a description' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
