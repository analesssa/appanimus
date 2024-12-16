import 'package:animus_senai/editar_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ListarUsuariosPage extends StatelessWidget {
  const ListarUsuariosPage({super.key});
  
  BuildContext? get context => null;

  
  Future<void> _deletarUsuario( BuildContext context, String id) async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(id).delete();
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('Usuário deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Erro ao deletar o usuário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários Cadastrados'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários.'));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              final String userId = usuario.id; 
              final String nomeUsuario = usuario['nome_usuario'];
              final String tipoCargo = usuario['tipo_cargo'];

              return ListTile(
                title: Text(nomeUsuario),
                subtitle: Text('Cargo: $tipoCargo'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarUsuarioPage(usuarioId: userId),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletarUsuario(context, userId),
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
}
