import 'package:flutter/material.dart';
import 'tela_principal.dart'; // Aqui você pode manter a navegação para TelaPrincipal
import 'telacadastro.dart'; // Aqui é para a tela de cadastro
import 'package:email_validator/email_validator.dart'; // Para validar o email

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _senhaFocusNode = FocusNode();

  void _login() {
    final String email = _emailController.text;
    final String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    } else if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido')),
      );
    } else if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres')),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaPrincipal()),
      );
    }
  }

  void _cadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaCadastro()),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _senhaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Pets - Animus'),
        backgroundColor: const Color(0xFF3F51B5), // Azul moderno
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Ação de notificações
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/telalogin.png'), // Caminho correto da imagem
            fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagem logo maior, mas controlada
              Image.asset(
                'lib/assets/animus.png',
                width: 220,  // Logo um pouco maior
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Títulos menores
              const Text(
                'Bem-vindo ao Animus',
                style: TextStyle(
                  fontSize: 20,  // Tamanho menor
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sua plataforma de gestão de pets',
                style: TextStyle(
                  fontSize: 14,  // Tamanho menor
                  color: Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),

              // Campos de Email e Senha
              _buildInputField(context, 'Email', Icons.email, false, _emailFocusNode),
              const SizedBox(height: 15),
              _buildInputField(context, 'Senha', Icons.lock, true, _senhaFocusNode),
              const SizedBox(height: 25),

              // Botões "Entrar" e "Cadastrar" lado a lado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInteractiveButton(context, 'Entrar', Colors.blueAccent, _login, small: true),
                  const SizedBox(width: 15),
                  _buildInteractiveButton(context, 'Cadastrar', Colors.greenAccent, _cadastro, small: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String label, IconData icon, bool obscureText, FocusNode focusNode) {
    return Container(
      width: 300,  // Tamanho fixo para os campos de texto
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
        focusNode: focusNode,
        style: const TextStyle(color: Colors.black, fontSize: 14),  // Tamanho da fonte reduzido
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),  // Tamanho da fonte reduzido
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),  // Padding ajustado
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: const Color.fromARGB(255, 230, 5, 5), width: 2),  // Borda verde neon quando em foco
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveButton(BuildContext context, String label, Color color, VoidCallback onPressed, {bool small = false}) {
    return Container(
      width: small ? 120 : 300,  // Botão com tamanho menor para 'small'
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Aqui substituímos 'primary' por 'backgroundColor'
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding ajustado
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,  // Fonte reduzida
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
