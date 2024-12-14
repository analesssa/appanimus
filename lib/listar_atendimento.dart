import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListAtendimentosPage extends StatelessWidget {
  const ListAtendimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos Listados'),
        backgroundColor: const Color.fromARGB(255, 76, 153, 230),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('atendimentos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar atendimentos.'));
          }

          final atendimentos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: atendimentos.length,
            itemBuilder: (context, index) {
              final atendimento = atendimentos[index];
              final atendimentoData = atendimento.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(atendimentoData['pet'] ?? 'Sem Nome'),
                subtitle: Text('${atendimentoData['servico'] ?? 'Sem Serviço'} - ${atendimentoData['observacoes'] ?? 'Sem Observações'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editarAtendimento(context, atendimento.id, atendimentoData),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletarAtendimento(context, atendimento.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Função para deletar o atendimento do Firestore
  void _deletarAtendimento(BuildContext context, String atendimentoId) async {
    try {
      await FirebaseFirestore.instance.collection('atendimentos').doc(atendimentoId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atendimento deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar o atendimento: $e')),
      );
    }
  }

  /// Função para editar as informações do atendimento
  void _editarAtendimento(BuildContext context, String atendimentoId, Map<String, dynamic> atendimentoData) {
    final petController = TextEditingController(text: atendimentoData['pet']);
    final servicoController = TextEditingController(text: atendimentoData['servico']);
    final observacoesController = TextEditingController(text: atendimentoData['observacoes']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Atendimento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: petController,
                  decoration: const InputDecoration(labelText: 'Nome do Pet'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: servicoController,
                  decoration: const InputDecoration(labelText: 'Serviço'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: observacoesController,
                  decoration: const InputDecoration(labelText: 'Observações'),
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
                  await FirebaseFirestore.instance.collection('atendimentos').doc(atendimentoId).update({
                    'pet': petController.text,
                    'servico': servicoController.text,
                    'observacoes': observacoesController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Atendimento atualizado com sucesso!')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar o atendimento: $e')),
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
