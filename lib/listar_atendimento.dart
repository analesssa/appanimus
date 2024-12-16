import 'package:animus_senai/tela_principal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Substitua com a página de tela inicial
import 'tela_atendimentos.dart'; // Substitua com a página de cadastro de atendimento

class ListAtendimentosPage extends StatelessWidget {
  const ListAtendimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atendimentos 🐾',
          style: TextStyle(
            fontSize: 22, // Tamanho de fonte igual ao do Listar Tutores
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFFFE4B5), // Amarelo bebê igual ao do Listar Tutores
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundobase.png'), // Fundo conforme solicitado
            fit: BoxFit.cover, // Garante que a imagem ocupe toda a tela
          ),
        ),
        child: Column(
          children: [
            // Linha com botões fora da AppBar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão "Cadastrar Novo Atendimento" no canto esquerdo
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  AtendimentosPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                    label: const Text(
                      'Cadastrar Novo Atendimento',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4B5), // Cor de fundo
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                  ),
                  // Botão "Voltar para Tela Inicial" no canto direito
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaPrincipal(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.home, color: Colors.green),
                    label: const Text(
                      'Tela Inicial',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE4B5), // Cor de fundo
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Exibição dos atendimentos
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
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

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título com o nome do pet e emoji
                            Text(
                              '🐾 ${atendimentoData['pet'] ?? 'Sem Nome'}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Cor do texto
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Subtítulo com informações do serviço e observações
                            Text(
                              'Serviço: ${atendimentoData['servico'] ?? 'Sem Serviço'} | Observações: ${atendimentoData['observacoes'] ?? 'Sem Observações'}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54, // Cor do texto
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Botões de editar e excluir
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _editarAtendimento(
                                      context, atendimento.id, atendimentoData),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletarAtendimento(context, atendimento.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
          title: const Text('Editar Atendimento 📝'),
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
