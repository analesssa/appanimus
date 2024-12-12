import 'package:flutter/material.dart';
import 'tela_principal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final TextEditingController _nomeUsuarioController = TextEditingController(); // Campo de nome de usuário
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSenhaVisivel = false;
  bool _isConfirmarSenhaVisivel = false;

  // Função para registrar o usuário no Firebase
  Future<void> _cadastrar() async {
    final String email = _emailController.text;
    final String senha = _senhaController.text;
    final String confirmarSenha = _confirmarSenhaController.text;
    final String nomeUsuario = _nomeUsuarioController.text; // Nome de usuário

    if (email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty || nomeUsuario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido')),
      );
    } else if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('A senha deve ter pelo menos 6 caracteres')),
      );
    } else if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não correspondem')),
      );
    } else {
      try {
        // Tenta criar o usuário com email e senha no Firebase
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: senha,
        );

        // Verifica se o usuário foi criado corretamente
        User? user = userCredential.user;

        if (user != null) {
          // Salvar dados no Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'nomeUsuario': nomeUsuario,
            'email': email,
            'dataRegistro': Timestamp.now(),
            'nomeCompleto': null,
            'dataNascimento': null,
            'genero': null,
            'bio': null,
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
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Certifique-se de que o caminho da imagem está correto
              Image.asset(
                'lib/assets/animuslogo.jpg',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 24),
              // Campo para o nome de usuário
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _nomeUsuarioController, // Controle de nome de usuário
                  decoration: const InputDecoration(
                    labelText: 'Nome de Usuário',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo para o email
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 16),
              // Campo para a senha
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _senhaController,
                  obscureText: !_isSenhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isSenhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSenhaVisivel = !_isSenhaVisivel;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Campo para confirmar senha
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _confirmarSenhaController,
                  obscureText: !_isConfirmarSenhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Borda preta ao focar
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmarSenhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmarSenhaVisivel = !_isConfirmarSenhaVisivel;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botão de cadastro
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
