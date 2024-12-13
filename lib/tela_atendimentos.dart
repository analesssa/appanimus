import 'package:flutter/material.dart';




class AtendimentosPage extends StatelessWidget {
  const AtendimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos'),
        backgroundColor: const Color.fromARGB(255, 76, 153, 230), // Azul padrão
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo Pet com tamanho reduzido
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Pet 🐾',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Serviço com tamanho reduzido
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Serviço 🛠️',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Observações com tamanho reduzido
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                  child: const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Observações 📝',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Botão Salvar com estilo igual aos campos
                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% da largura da tela
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação para salvar os dados
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Atendimento salvo com sucesso!')),
                      );
                    },
                    child: const Text('Salvar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0), backgroundColor: const Color.fromARGB(255, 10, 170, 233), // Cor azul para o botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}