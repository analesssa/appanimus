import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListarTutoresPage extends StatelessWidget {
  const ListarTutoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutores Cadastrados'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tutores').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tutores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tutores.length,
            itemBuilder: (context, index) {
              final tutorDoc = tutores[index];
              final tutor = tutorDoc.data() as Map<String, dynamic>;
              final nome = tutor['nome'] ?? 'Nome não informado';
              final cpf = tutor['cpf'] ?? 'CPF não informado';

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(nome),
                  subtitle: Text('CPF: $cpf'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _editarTutor(context, tutorDoc.id, tutor),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletarTutor(context, tutorDoc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Função para deletar o tutor do Firestore
  void _deletarTutor(BuildContext context, String tutorId) async {
    try {
      await FirebaseFirestore.instance.collection('tutores').doc(tutorId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutor deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar o tutor: $e')),
      );
    }
  }

  /// Função para editar as informações do tutor
  void _editarTutor(BuildContext context, String tutorId, Map<String, dynamic> tutor) {
    final nomeController = TextEditingController(text: tutor['nome']);
    final cpfController = TextEditingController(text: tutor['cpf']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tutor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do Tutor'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: cpfController,
                  decoration: const InputDecoration(labelText: 'CPF do Tutor'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('tutores').doc(tutorId).update({
                    'nome': nomeController.text,
                    'cpf': cpfController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tutor atualizado com sucesso!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar o tutor: $e')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
