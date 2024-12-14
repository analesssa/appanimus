import 'package:animus_senai/tela_atendimentos.dart';
import 'package:flutter/material.dart';
import 'package:animus_senai/cadastrarTutor.dart';
import 'package:animus_senai/cadastrarusu.dart';
import 'package:animus_senai/cadastropets.dart';
import 'package:animus_senai/tela_inicial.dart';


class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF9C4), // Cor Amarelo Bebê
            ),
            child: AppBar(
              title: const Text('Bem-vindo ao Animus 🐶'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Ação de notificações
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFF9C4), // Cor Amarelo Bebê
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('lib/assets/animuslogo.jpg'),
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'MENU',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF81D4FA), // Azul bebê para o título
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                title: 'Pets',
                icon: Icons.pets,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastrarPetPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                title: 'Donos',
                icon: Icons.person,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastrarTutorPage()),
                  );
                },
              ),
              
              _buildDrawerItem(
                context,
                title: 'Atendimentos',
                icon: Icons.access_time,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AtendimentosPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                title: 'Admin',
                icon: Icons.admin_panel_settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CadastrarUsuarioPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                title: 'Sair',
                icon: Icons.exit_to_app,
                onTap: () {
                  _sair(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        // Imagem de fundo sem opacidade
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/bgtelabomba.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Conteúdo da tela principal
      ]),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF81D4FA), // Azul bebê como fundo
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white), // Ícone branco
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Texto branco para contraste
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

  void _sair(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar saída'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInicial()),
                );
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }
}

