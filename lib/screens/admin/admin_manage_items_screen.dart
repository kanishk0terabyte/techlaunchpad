import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class AdminManageItemsScreen extends StatefulWidget {
  final String title;
  final String collectionName;
  final List<FieldConfig> fields;

  const AdminManageItemsScreen({
    super.key,
    required this.title,
    required this.collectionName,
    required this.fields,
  });

  @override
  State<AdminManageItemsScreen> createState() => _AdminManageItemsScreenState();
}

class FieldConfig {
  final String key;
  final String label;
  final TextInputType type;
  final bool required;
  final List<String>? options;

  const FieldConfig({
    required this.key,
    required this.label,
    this.type = TextInputType.text,
    this.required = true,
    this.options,
  });
}

class _AdminManageItemsScreenState extends State<AdminManageItemsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _search = '';

  void _showAddEditSheet([DocumentSnapshot? doc]) {
    final isEditing = doc != null;
    final data = isEditing ? (doc.data() as Map<String, dynamic>? ?? {}) : <String, dynamic>{};
    final controllers = <String, TextEditingController>{};

    for (final f in widget.fields) {
      controllers[f.key] = TextEditingController(text: data[f.key]?.toString() ?? '');
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit ${widget.title}' : 'Add New ${widget.title}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    ...widget.fields.map((field) {
                      if (field.options != null && field.options!.isNotEmpty) {
                        String currentVal = controllers[field.key]!.text;
                        if (!field.options!.contains(currentVal)) {
                          currentVal = field.options!.first;
                          controllers[field.key]!.text = currentVal;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: DropdownButtonFormField<String>(
                            value: currentVal,
                            decoration: InputDecoration(labelText: field.label),
                            items: field.options!
                                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                                .toList(),
                            onChanged: (val) {
                              setSheetState(() => controllers[field.key]!.text = val ?? '');
                            },
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TextFormField(
                          controller: controllers[field.key],
                          keyboardType: field.type,
                          maxLines: field.key.contains('description') || field.key.contains('content') ? 3 : 1,
                          decoration: InputDecoration(
                            labelText: field.label,
                            hintText: 'Enter ${field.label.toLowerCase()}',
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () async {
                          final Map<String, dynamic> itemData = {};
                          for (final f in widget.fields) {
                            final val = controllers[f.key]!.text.trim();
                            if (f.key == 'tags' || f.key == 'skills' || f.key == 'resources') {
                              itemData[f.key] = val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                            } else if (f.key == 'rating') {
                              itemData[f.key] = double.tryParse(val) ?? 0.0;
                            } else if (f.key == 'isFree') {
                              itemData[f.key] = val.toLowerCase() == 'true' || val.toLowerCase() == 'yes';
                            } else {
                              itemData[f.key] = val;
                            }
                          }

                          try {
                            if (isEditing) {
                              await _firestoreService.updateDocument(
                                '${widget.collectionName}/${doc.id}',
                                itemData,
                              );
                            } else {
                              await _firestoreService.addDocument(widget.collectionName, itemData);
                            }
                            if (mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${widget.title} saved successfully!')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                        child: Text(isEditing ? 'Save Changes' : 'Publish Item'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('Are you sure you want to permanently delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _firestoreService.deleteDocument('${widget.collectionName}/$id');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.title}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditSheet(),
        icon: const Icon(Icons.add),
        label: Text('Add ${widget.title}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search_rounded),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              onChanged: (val) => setState(() => _search = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getCollection(widget.collectionName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                final filtered = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>? ?? {};
                  final title = (data['title'] ?? data['name'] ?? data['company'] ?? '').toString().toLowerCase();
                  return _search.isEmpty || title.contains(_search);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 56, color: Colors.grey.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        Text('No ${widget.title.toLowerCase()} found', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final doc = filtered[idx];
                    final data = doc.data() as Map<String, dynamic>? ?? {};
                    final title = data['title'] ?? data['name'] ?? data['company'] ?? 'Untitled';
                    final subtitle = data['category'] ?? data['platform'] ?? data['role'] ?? data['description'] ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        title: Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(subtitle.toString(), maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () => _showAddEditSheet(doc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _deleteItem(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
