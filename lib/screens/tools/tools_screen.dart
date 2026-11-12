import 'package:flutter/material.dart';
import '../../models/tool_model.dart';
import '../../widgets/tool_card.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final List<ToolModel> _defaultTools = [
    ToolModel(
      id: '1',
      name: 'Visual Studio Code',
      description: 'The world\'s most popular lightweight code editor with great extensions.',
      link: 'https://code.visualstudio.com/',
      category: 'IDE',
      platform: 'Cross-platform',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '2',
      name: 'Git & GitHub',
      description: 'Essential version control and collaboration platform for every developer.',
      link: 'https://github.com/',
      category: 'Git',
      platform: 'Web / CLI',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '3',
      name: 'Postman',
      description: 'Comprehensive API development, testing, and documentation platform.',
      link: 'https://www.postman.com/',
      category: 'API',
      platform: 'Cross-platform',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '4',
      name: 'Docker Desktop',
      description: 'Containerize applications for consistent development and deployment.',
      link: 'https://www.docker.com/',
      category: 'DevOps',
      platform: 'Cross-platform',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '5',
      name: 'Figma',
      description: 'Collaborative interface design and prototyping tool used worldwide.',
      link: 'https://www.figma.com/',
      category: 'Design',
      platform: 'Web / Desktop',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '6',
      name: 'Notion',
      description: 'All-in-one workspace for notes, project management, and study planning.',
      link: 'https://www.notion.so/',
      category: 'Productivity',
      platform: 'Cross-platform',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '7',
      name: 'Android Studio',
      description: 'Official IDE for Android development with powerful emulators.',
      link: 'https://developer.android.com/studio',
      category: 'IDE',
      platform: 'Cross-platform',
      createdAt: DateTime.now(),
    ),
    ToolModel(
      id: '8',
      name: 'ChatGPT / Claude',
      description: 'AI pair programming, code debugging, and concept learning companions.',
      link: 'https://chat.openai.com/',
      category: 'AI',
      platform: 'Web',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Tools 🛠️'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemCount: _defaultTools.length,
        itemBuilder: (context, idx) {
          final tool = _defaultTools[idx];
          return ToolCard(tool: tool);
        },
      ),
    );
  }
}
