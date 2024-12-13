import 'package:flutter/material.dart';

class CadastrarUsuarioPage extends StatefulWidget {
  const CadastrarUsuarioPage({super.key});

  @override
  State<CadastrarUsuarioPage> createState() => _CadastrarUsuarioPageState();
}

class _CadastrarUsuarioPageState extends State<CadastrarUsuarioPage> {
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String _tipoCargo = 'Administrador';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Tamanho da AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFF9C4), // Amarelo bebê
                  Color(0xFFFFE082), // Amarelo mais forte
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Text('Cadastrar Usuário 🧑‍💻'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF81D4FA), // Azul bebê
              Color(0xFF4FC3F7), // Azul mais forte
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagem do logo
                  Image.asset(
                    'lib/assets/animuslogo.jpg',
                    height: 150,
                  ),
                  const SizedBox(height: 16),

                  // Linha 1: Nome de Usuário
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildTextField(_nomeUsuarioController, 'Nome de Usuário'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 2: Senha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildTextField(_senhaController, 'Senha', isPassword: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 3: Tipo de Cargo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250, // Tamanho fixo para o campo de Cargo
                        child: DropdownButtonFormField<String>(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão de Cadastro
                  ElevatedButton(
                    onPressed: _cadastrarUsuario,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Cadastrar Usuário'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return SizedBox(
      width: 250, // Ajuste a largura para os campos ficarem proporcionais
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Cor da label
          ),
          filled: true,
          fillColor: Colors.white, // Fundo branco para contrastar
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Borda arredondada
            borderSide: BorderSide(
              color: Color(0xFF81D4FA), // Azul bebê para a borda
              width: 2, // Largura da borda
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        style: const TextStyle(color: Colors.black87), // Texto mais escuro
      ),
    );
  }

  void _cadastrarUsuario() {
    final String nomeUsuario = _nomeUsuarioController.text;
    final String senha = _senhaController.text;

    if (nomeUsuario.isNotEmpty && senha.isNotEmpty && senha.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos corretamente.')),
      );
    }
  }
}
