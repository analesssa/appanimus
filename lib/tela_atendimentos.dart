import 'package:animus_senai/listar_atendimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: duplicate_import
import 'listar_atendimento.dart'; 
class AtendimentosPage extends StatelessWidget {
   AtendimentosPage({super.key});

  final TextEditingController petController = TextEditingController();
  final TextEditingController servicoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  Future<void> saveAtendimento(BuildContext context) async {
    try {
      final pet = petController.text;
      final servico = servicoController.text;
      final observacoes = observacoesController.text;

      if (pet.isEmpty || servico.isEmpty || observacoes.isEmpty) {
        return;
      }

      await FirebaseFirestore.instance.collection('atendimentos').add({
        'pet': pet,
        'servico': servico,
        'observacoes': observacoes,
        'data': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atendimento salvo com sucesso!')),
      );
      petController.clear();
      servicoController.clear();
      observacoesController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar atendimento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos'),
        backgroundColor: const Color.fromARGB(255, 76, 153, 230),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo Pet
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: petController,
                    decoration: const InputDecoration(
                      labelText: 'Pet 🐾',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Serviço
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: servicoController,
                    decoration: const InputDecoration(
                      labelText: 'Serviço 🛠️',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Observações
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: observacoesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Observações 📝',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Botão Salvar
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () => saveAtendimento(context),
                    child: const Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: const Color.fromARGB(255, 10, 170, 233),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botão Listar Atendimentos
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListAtendimentosPage(),
                      ),
                    );
                  },
                  child: const Text('Listar Atendimentos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color.fromARGB(255, 10, 170, 233),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
