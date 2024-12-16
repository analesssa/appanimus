import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cadastropets.dart';
import 'tela_principal.dart';

class ListarPetsPage extends StatelessWidget {
  const ListarPetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Cadastrados 🐾'),
        backgroundColor: Color(0xFFFFE4B5),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundobase.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CadastrarPetPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Cadastrar Novo Pet ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 250, 222, 169),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaPrincipal(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Tela Inicial ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 250, 222, 169),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('pets').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Erro ao carregar os dados.'));
                    }

                    final pets = snapshot.data?.docs ?? [];

                    if (pets.isEmpty) {
                      return const Center(child: Text('Nenhum pet cadastrado ainda.'));
                    }

                    return ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final petDoc = pets[index];
                        final pet = petDoc.data() as Map<String, dynamic>;
                        final nomePet = pet['nomePet'] ?? 'Sem Nome';
                        final tutorId = pet['tutorId'];
                        final racaPet = pet['racaPet'] ?? 'Raça desconhecida';

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('tutores').doc(tutorId).get(),
                          builder: (context, tutorSnapshot) {
                            if (tutorSnapshot.connectionState == ConnectionState.waiting) {
                              return const ListTile(
                                title: Text('🐾 Carregando pet...'),
                              );
                            }

                            if (tutorSnapshot.hasError) {
                              return const ListTile(
                                title: Text('🐾 Erro ao carregar tutor.'),
                              );
                            }

                            final tutor = tutorSnapshot.data?.data() as Map<String, dynamic>?;
                            final nomeDono = tutor?['nome'] ?? 'Sem Tutor';

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                                  Text(
                                    '🐾 $nomePet',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tutor: $nomeDono | Raça: $racaPet',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.orange),
                                        onPressed: () => _editarPet(context, petDoc.id, pet),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _confirmarDelecao(context, petDoc.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarDelecao(BuildContext context, String petId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Pet'),
          content: const Text('Você tem certeza que deseja excluir este pet? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deletarPet(context, petId);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletarPet(BuildContext context, String petId) async {
    if (petId.isEmpty) {
      print('O ID do pet está vazio! Verifique o valor passado.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('pets').doc(petId).delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet deletado com sucesso!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar o pet: $e')),
        );
      }
    }
  }

  Future<void> _editarPet(BuildContext context, String petId, Map<String, dynamic> pet) async {
    final nomeController = TextEditingController(text: pet['nomePet']);
    final donoController = TextEditingController(text: pet['nomeDono']);
    final racaController = TextEditingController(text: pet['racaPet']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Pet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do Pet'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: donoController,
                  decoration: const InputDecoration(labelText: 'Nome do Tutor'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: racaController,
                  decoration: const InputDecoration(labelText: 'Raça do Pet'),
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
                  await FirebaseFirestore.instance.collection('pets').doc(petId).update({
                    'nomePet': nomeController.text,
                    'nomeDono': donoController.text,
                    'racaPet': racaController.text,
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
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
