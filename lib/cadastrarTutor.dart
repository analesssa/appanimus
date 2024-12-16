import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listar_tutores.dart'; // Importa a página de listagem de tutores

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
        preferredSize: Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF9C4), // Amarelo bebê para o AppBar
            ),
            child: AppBar(
              title: const Text('Cadastrar Tutor 🧑‍⚕️'),
              backgroundColor: Color(0xFFFFF9C4), // Amarelo bebê para o AppBar
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundobase.png'), // Adicionando a imagem de fundo
            fit: BoxFit.cover, // Faz a imagem cobrir toda a tela
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campos de entrada com Row para dois campos lado a lado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_nomeTutorController, 'Nome do Tutor'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cpfTutorController, 'CPF do Tutor', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(_emailTutorController, 'Email'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_telefoneTutorController, 'Telefone', isNumber: true),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_cidadeController, 'Cidade'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_bairroController, 'Bairro'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(_ruaController, 'Rua'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildTextField(_numeroCasaController, 'Número da Casa', isNumber: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botões de cadastro e ver tutores com cores ajustadas e alinhamento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão de Cadastrar Tutor
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _cadastrarTutor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: const Text(
                            'Cadastrar Tutor 📝',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Botão de Ver Tutores Cadastrados
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ListarTutoresPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                          ),
                          child: const Text(
                            'Ver Tutores Cadastrados 📋',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8), // Fundo branco com transparência
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  void _cadastrarTutor() {
    final String nomeTutor = _nomeTutorController.text;
    final String cpfTutor = _cpfTutorController.text;
    final String emailTutor = _emailTutorController.text;

    if (CPFValidator.isValid(cpfTutor) && EmailValidator.validate(emailTutor)) {
      FirebaseFirestore.instance.collection('tutores').add({
        'nome': nomeTutor,
        'cpf': cpfTutor,
        'email': emailTutor,
        'telefone': _telefoneTutorController.text,
        'cidade': _cidadeController.text,
        'bairro': _bairroController.text,
        'rua': _ruaController.text,
        'numeroCasa': _numeroCasaController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutor cadastrado com sucesso!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListarTutoresPage()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar tutor.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CPF ou email inválido.')),
      );
    }
  }
}
