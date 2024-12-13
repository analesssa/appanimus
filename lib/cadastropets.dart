import 'package:flutter/material.dart';

class CadastrarPetPage extends StatefulWidget {
  const CadastrarPetPage({super.key});

  @override
  State<CadastrarPetPage> createState() => _CadastrarPetPageState();
}

class _CadastrarPetPageState extends State<CadastrarPetPage> {
  final TextEditingController _nomeDonoController = TextEditingController();
  final TextEditingController _cpfDonoController = TextEditingController();
  final TextEditingController _nomePetController = TextEditingController();
  final TextEditingController _especiePetController = TextEditingController();
  final TextEditingController _racaPetController = TextEditingController();
  final TextEditingController _dataNascimentoPetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Diminuir o tamanho da AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
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
            child: AppBar(
              title: const Text('Cadastrar Pet 🤖'),
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
              Color(0xFFFFF9C4), // Amarelo bebê
              Color(0xFFFFE082), // Amarelo mais forte
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
                  // Linha 1: Nome do Tutor e CPF do Tutor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_nomeDonoController, 'Nome do Tutor 🧑‍⚕️'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_cpfDonoController, 'CPF do Tutor 🆔', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 2: Nome do Pet e Raça do Pet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_nomePetController, 'Nome do Pet 🦾'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_racaPetController, 'Raça do Pet 🐕‍🦺'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 3: Espécie do Pet e Data de Nascimento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_especiePetController, 'Espécie do Pet 🦴'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_dataNascimentoPetController, 'Data de Nascimento 🗓️'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botão de cadastro
                  ElevatedButton(
                    onPressed: _cadastrarPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Borda arredondada
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text(
                      'Cadastrar 🐾',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return SizedBox(
      width: 150,  // Ajuste a largura para os campos ficarem proporcionais
      child: TextField(
        controller: controller,
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
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  void _cadastrarPet() {
    final String nomeDono = _nomeDonoController.text;
    final String cpfDono = _cpfDonoController.text;
    final String nomePet = _nomePetController.text;
    final String especiePet = _especiePetController.text;
    final String racaPet = _racaPetController.text;
    final String dataNascimentoPet = _dataNascimentoPetController.text;

    if (nomeDono.isNotEmpty &&
        cpfDono.isNotEmpty &&
        nomePet.isNotEmpty &&
        especiePet.isNotEmpty &&
        racaPet.isNotEmpty &&
        dataNascimentoPet.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet cadastrado com sucesso! 🐾')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos. 😞')),
      );
    }
  }
}
