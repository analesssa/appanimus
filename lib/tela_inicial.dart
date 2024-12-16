import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_principal.dart';
import 'telacadastro.dart'; // Importe o arquivo de cadastro
import 'package:email_validator/email_validator.dart'; // Para validação de email

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para o login
  void _login() async {
    final String email = _emailController.text;
    final String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido')),
      );
      return;
    }

    try {
      // Tentando fazer o login com o email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Verificando se o email está presente na coleção 'users' no Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Utilizando o UID do usuário autenticado
            .get();

        if (snapshot.exists) {
          // Usuário autenticado com sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login realizado com sucesso!')),
          );

          // Redireciona para a tela principal após o login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TelaPrincipal()),
          );
        } else {
          // Caso o email não tenha sido encontrado na coleção 'users' do Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não encontrado. Realize o cadastro.')),
          );
        }
      }
    } catch (e) {
      // Caso o email ou senha estejam incorretos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login. Usuário inválido. Cadastra-se ou tente novamente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Pets - Animus'),
        backgroundColor: const Color(0xFF3F51B5),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula o tamanho da tela para responsividade
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.35), // Aumentei o valor para descer ainda mais os textos
                  const Text(
                    'Bem-vindo ao Animus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 15, 0, 0),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01), // Menor espaçamento entre o texto e o próximo texto
                  const Text(
                    'Sua plataforma de gestão de pets',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(179, 12, 1, 1),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Mais espaço abaixo do texto para separar do campo de email

                  // Campos de Email e Senha
                  _buildInputField(context, 'Email', Icons.email, false),
                  SizedBox(height: screenHeight * 0.02), // Menor espaçamento entre o campo de email e senha
                  _buildInputField(context, 'Senha', Icons.lock, true),
                  SizedBox(height: screenHeight * 0.05), // Aumentei o espaçamento entre os campos e os botões

                  // Botões "Entrar" e "Cadastrar"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInteractiveButton(context, 'Entrar', Colors.blueAccent, _login),
                      SizedBox(width: screenWidth * 0.05),
                      _buildInteractiveButton(context, 'Cadastrar', Colors.greenAccent, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TelaCadastro()),
                        );
                      }),
                    ],
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
  Widget _buildInputField(BuildContext context, String label, IconData icon, bool obscureText) {
    return Container(
      width: 300,
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
        controller: label == "Email" ? _emailController : _senhaController,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color.fromARGB(255, 230, 5, 5), width: 2),
          ),
        ),
      ),
    );
  }

  // Função para criar os botões interativos
  Widget _buildInteractiveButton(BuildContext context, String label, Color color, VoidCallback onPressed) {
    return Container(
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
