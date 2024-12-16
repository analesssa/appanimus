import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPetPage extends StatefulWidget {
  final String petId;
  final Map<String, dynamic> petData;

  const EditarPetPage({super.key, required this.petId, required this.petData});

  @override
  _EditarPetPageState createState() => _EditarPetPageState();
}

class _EditarPetPageState extends State<EditarPetPage> {
  late TextEditingController _nomeController;
  late TextEditingController _donoController;
  late TextEditingController _racaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.petData['nomePet']);
    _donoController = TextEditingController(text: widget.petData['nomeDono']);
    _racaController = TextEditingController(text: widget.petData['racaPet']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _donoController.dispose();
    _racaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pet'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _donoController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Dono',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _racaController,
                decoration: const InputDecoration(
                  labelText: 'Raça do Pet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _atualizarPet,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _atualizarPet() async {
    try {
      await FirebaseFirestore.instance.collection('pets').doc(widget.petId).update({
        'nomePet': _nomeController.text,
        'nomeDono': _donoController.text,
        'racaPet': _racaController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet atualizado com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o pet: $e')),
      );
    }
  }
}
