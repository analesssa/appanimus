import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tela_principal.dart';
import 'telacadastro.dart'; 
import 'package:email_validator/email_validator.dart'; 

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

 
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
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) 
            .get();

        if (snapshot.exists) {
    
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login realizado com sucesso!')),
          );

         
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TelaPrincipal()),
          );
        } else {
         
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não encontrado. Realize o cadastro.')),
          );
        }
      }
    } catch (e) {
      
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
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/telalogin.png'),
                fit: BoxFit.cover, 
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.35), 
                  const Text(
                    'Bem-vindo ao Animus',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 15, 0, 0),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01), 
                  const Text(
                    'Sua plataforma de gestão de pets',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(179, 12, 1, 1),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), 

                  _buildInputField(context, 'Email', Icons.email, false),
                  SizedBox(height: screenHeight * 0.02), 
                  _buildInputField(context, 'Senha', Icons.lock, true),
                  SizedBox(height: screenHeight * 0.05), 

               
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
