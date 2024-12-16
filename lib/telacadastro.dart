import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_principal.dart';
import 'package:email_validator/email_validator.dart'; // Para validação de email

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSenhaVisivel = false;
  bool _isConfirmarSenhaVisivel = false;

  // Função para registrar o usuário no Firebase
  Future<void> _cadastrar() async {
    final String email = _emailController.text;
    final String senha = _senhaController.text;
    final String confirmarSenha = _confirmarSenhaController.text;

    if (email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido')),
      );
    } else if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres')),
      );
    } else if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não correspondem')),
      );
    } else {
      try {
        // Verifica se o email já está em uso
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        // Verifica se o usuário foi criado corretamente
        User? user = userCredential.user;

        if (user != null) {
          // Salvar dados no Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': email,
            'dataRegistro': Timestamp.now(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário registrado com sucesso!')),
          );

          // Navegar para a tela principal após o cadastro
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TelaPrincipal()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Color(0xFFFFF9C4), // Amarelo bebê
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/telalogin.png'),
                fit: BoxFit.cover, // Garantindo que a imagem cubra a tela de forma responsiva
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.25), // Ajustando padding para descer os campos
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 24), // Espaço acima dos campos
                  SizedBox(
                    width: 300,
                    child: _buildInputField(context, 'Email', Icons.email, false, _emailController),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: _buildInputField(context, 'Senha', Icons.lock, _isSenhaVisivel, _senhaController, true),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: _buildInputField(context, 'Confirmar Senha', Icons.lock, _isConfirmarSenhaVisivel, _confirmarSenhaController, true),
                  ),
                  const SizedBox(height: 40), // Aumentei o espaçamento entre os campos e o botão
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFB8C00), // Cor de fundo do botão
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Função para construir os campos de input
  Widget _buildInputField(BuildContext context, String label, IconData icon, bool obscureText, TextEditingController controller, [bool isPassword = false]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFFFA000), width: 2), // Cor que acende ao digitar
          ),
        ),
      ),
    );
  }
}
