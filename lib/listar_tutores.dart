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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          onPressed: () => _confirmarDelecao(context, tutorDoc.id, nome),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Função para confirmar a remoção do tutor
  void _confirmarDelecao(BuildContext context, String tutorId, String nome) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar remoção'),
          content: Text('Confirmar remoção do tutor "$nome" do sistema?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('tutores').doc(tutorId).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tutor removido com sucesso!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao remover o tutor: $e')),
                  );
                }
              },
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
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
