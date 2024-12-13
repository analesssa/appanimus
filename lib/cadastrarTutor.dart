import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CadastrarTutorPage extends StatefulWidget {
  const CadastrarTutorPage({super.key});

  @override
  State<CadastrarTutorPage> createState() => _CadastrarTutorPageState();
}

class _CadastrarTutorPageState extends State<CadastrarTutorPage> {
  final TextEditingController _nomeTutorController = TextEditingController();
  final TextEditingController _cpfTutorController = TextEditingController();
  final TextEditingController _emailTutorController = TextEditingController();
  final TextEditingController _telefoneTutorController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroCasaController = TextEditingController();

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
                  Color(0xFF81D4FA), // Azul bebê
                  Color(0xFF4FC3F7), // Azul mais forte
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Text('Cadastrar Tutor 🧑‍⚕️'),
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
                        child: _buildTextField(_nomeTutorController, 'Nome do Tutor'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_cpfTutorController, 'CPF do Tutor', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 2: Email e Telefone do Tutor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_emailTutorController, 'Email', isNumber: false),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_telefoneTutorController, 'Telefone', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 3: Cidade e Bairro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_cidadeController, 'Cidade'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_bairroController, 'Bairro'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Linha 4: Rua e Número da Casa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_ruaController, 'Rua'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(_numeroCasaController, 'Número da Casa', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botão de cadastro
                  ElevatedButton(
                    onPressed: _cadastrarTutor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Borda arredondada
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text(
                      'Cadastrar Tutor 📝',
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

  void _cadastrarTutor() {
    final String nomeTutor = _nomeTutorController.text;
    final String cpfTutor = _cpfTutorController.text;
    final String emailTutor = _emailTutorController.text;
    final String telefoneTutor = _telefoneTutorController.text;
    final String cidade = _cidadeController.text;
    final String bairro = _bairroController.text;
    final String rua = _ruaController.text;
    final String numeroCasa = _numeroCasaController.text;

    if (nomeTutor.isNotEmpty &&
        cpfTutor.isNotEmpty &&
        emailTutor.isNotEmpty &&
        telefoneTutor.isNotEmpty &&
        cidade.isNotEmpty &&
        bairro.isNotEmpty &&
        rua.isNotEmpty &&
        numeroCasa.isNotEmpty) {
      if (CPFValidator.isValid(cpfTutor)) {
        if (EmailValidator.validate(emailTutor)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tutor cadastrado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email inválido.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CPF inválido.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }
}
