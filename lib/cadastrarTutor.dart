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
        preferredSize: Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF81D4FA),
                  Color(0xFF4FC3F7),
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
              Color(0xFFFFF9C4),
              Color(0xFFFFE082),
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
                children: [
                  // Campos de entrada
                  _buildTextField(_nomeTutorController, 'Nome do Tutor'),
                  _buildTextField(_cpfTutorController, 'CPF do Tutor', isNumber: true),
                  _buildTextField(_emailTutorController, 'Email'),
                  _buildTextField(_telefoneTutorController, 'Telefone', isNumber: true),
                  _buildTextField(_cidadeController, 'Cidade'),
                  _buildTextField(_bairroController, 'Bairro'),
                  _buildTextField(_ruaController, 'Rua'),
                  _buildTextField(_numeroCasaController, 'Número da Casa', isNumber: true),
                  
                  const SizedBox(height: 16),

                  // Botão de cadastro
                  ElevatedButton(
                    onPressed: _cadastrarTutor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text(
                      'Cadastrar Tutor 📝',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botão para navegar para a página de listagem
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListarTutoresPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text(
                      'Ver Tutores Cadastrados 📋',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
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
