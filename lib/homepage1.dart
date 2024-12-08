import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SupabaseClient supabase = Supabase.instance.client;

  // Create item
  Future<void> createItem(String name, String description) async {
    try {
      final response = await supabase.from('items').insert({
        'name': name,
        'description': description,
      });

      print(response.data); // Print the actual data returned

      // Check if there's an error
      if (response.error != null) {
        print("Error creating item: ${response.error!.message}");
      } else if (response.data != null) {
        print("Item created successfully: ${response.data}");
      } else {
        print("Unexpected response: No error or data returned.");
      }
    } catch (e) {
      print("Error creating item: $e");
    }
  }

  // Update item
  Future<void> updateItem(String id, String name, String description) async {
    try {
      final response = await supabase
          .from('items')
          .update({'name': name, 'description': description}).eq('id', id);

      if (response.error != null) {
        throw response.error!.message;
      }
      print("Item updated successfully");
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      final response = await supabase.from('items').delete().eq('id', id);
      print(response);
      if (response.error != null) {
        throw response.error!.message;
      }
      print("Item deleted successfully");
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items List'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('items').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No items found."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(item['description'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _showEditDialog(context, item['id'], item['name'],
                            item['description']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _showDeleteConfirmation(context, item['id']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show dialog for adding an item
  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final description = descriptionController.text;
                if (name.isNotEmpty && description.isNotEmpty) {
                  createItem(name, description);
                  Navigator.pop(context);
                }
              },
              child: const Text('save'),
            ),
          ],
        );
      },
    );
  }

  //show dialog for editing an item
  void _showEditDialog(BuildContext context, int id, String currentName,
      String currentDescription) {
    final nameController = TextEditingController(text: currentName);
    final descriptionController =
        TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final description = descriptionController.text;
                if (name.isNotEmpty && description.isNotEmpty) {
                  updateItem(id.toString(), name, description);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation deleting an item
  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteItem(id.toString());
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
