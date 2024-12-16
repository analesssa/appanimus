import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarUsuarioPage extends StatefulWidget {
  final String usuarioId;
  const EditarUsuarioPage({super.key, required this.usuarioId});

  @override
  State<EditarUsuarioPage> createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  String _tipoCargo = 'Administrador';

  @override
  void initState() {
    super.initState();
    _loadUsuarioData();
  }

  Future<void> _loadUsuarioData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('usuarios').doc(widget.usuarioId).get();
      if (doc.exists) {
        setState(() {
          _nomeUsuarioController.text = doc['nome_usuario'];
          _tipoCargo = doc['tipo_cargo'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados: $e')),
      );
    }
  }

  Future<void> _editarUsuario() async {
    final String nomeUsuario = _nomeUsuarioController.text;

    if (nomeUsuario.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('usuarios').doc(widget.usuarioId).update({
          'nome_usuario': nomeUsuario,
          'tipo_cargo': _tipoCargo,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário editado com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao editar usuário: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome do usuário.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeUsuarioController,
              decoration: const InputDecoration(
                labelText: 'Nome de Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoCargo,
              items: ['Administrador', 'Funcionario', 'Médico Veterinário']
                  .map((cargo) => DropdownMenuItem(
                        value: cargo,
                        child: Text(cargo),
                      ))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  _tipoCargo = valor!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Cargo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _editarUsuario,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
