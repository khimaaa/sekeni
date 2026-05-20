import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../services/app_state.dart';
import '../widgets/local_image.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _picker = ImagePicker();
  final List<String> _photoPaths = [];
  PropertyCategory _category = PropertyCategory.home;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final images = await _picker.pickMultiImage(imageQuality: 85);
    if (images.isEmpty) return;
    setState(() {
      _photoPaths.addAll(images.map((x) => x.path));
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final price = _priceController.text.trim();
    if (title.isEmpty || location.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remplissez tous les champs')),
      );
      return;
    }
    context.read<AppState>().addOwnerProperty(
          title: title,
          location: location,
          price: price,
          category: _category,
          photoPaths: List.from(_photoPaths),
        );
    _titleController.clear();
    _locationController.clear();
    _priceController.clear();
    setState(() => _photoPaths.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bien publié dans « Mes biens »'),
        backgroundColor: Color(0xFF007A3D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Ajouter un bien',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickPhotos,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: _photoPaths.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 48, color: Colors.orange),
                          SizedBox(height: 12),
                          Text(
                            'Appuyez pour ajouter des photos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: LocalImage(path: _photoPaths.first, height: 200),
                      ),
              ),
            ),
            if (_photoPaths.length > 1) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photoPaths.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LocalImage(path: _photoPaths[i], height: 72, width: 72),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _photoPaths.removeAt(i)),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                PropertyCategory.home,
                PropertyCategory.apartment,
              ].map((cat) {
                final sel = _category == cat;
                return ChoiceChip(
                  label: Text(cat.label),
                  selected: sel,
                  onSelected: (_) => setState(() => _category = cat),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              _category == PropertyCategory.apartment
                  ? 'Appartement meublé avec wifi'
                  : 'Maison / studio non meublé, sans wifi',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _field('Nom du bien', _titleController, Icons.home_work),
            const SizedBox(height: 12),
            _field('Quartier à Nouakchott', _locationController, Icons.location_on),
            const SizedBox(height: 12),
            _field('Prix (MRU)', _priceController, Icons.attach_money),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Publier', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String hint, TextEditingController c, IconData icon) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
