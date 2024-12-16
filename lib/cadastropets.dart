import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listar_pet.dart';

class CadastrarPetPage extends StatefulWidget {
  const CadastrarPetPage({super.key});

  @override
  State<CadastrarPetPage> createState() => _CadastrarPetPageState();
}

class _CadastrarPetPageState extends State<CadastrarPetPage> {
  final TextEditingController _nomePetController = TextEditingController();
  final TextEditingController _dataNascimentoPetController = TextEditingController();

  String? _selectedEspecie;
  String? _selectedRaca;
  String? _selectedTutorId;  // Armazena o ID do tutor selecionado

  // Lista de opções para o Dropdown de Espécie
  List<String> _especies = [
    'Cachorro',
    'Gato',
    'Peixe',
    'Pássaro',
    'Hamster',
    'Coelho',
    'Réptéis',
    'Cobaias',
    'Furão',
    'Serpentes',
    'Cagado',
    'Outros'
  ];

  // Lista de raças para Cachorro e Gato
  List<String> _racasCachorro = [
    'Labrador Retriever', 'Pastor Alemão', 'Bulldog Francês', 'Poodle', 
    'Golden Retriever', 'Chihuahua', 'Beagle', 'Shih Tzu', 'Rottweiler', 
    'Boxer', 'Cocker Spaniel', 'Dachshund (Teckel)', 'Yorkshire Terrier', 
    'Doberman', 'Pug', 'Border Collie', 'Schnauzer', 'Cavalier King Charles Spaniel', 
    'Maltês', 'Husky Siberiano', 'Akita', 'Dálmata', 'Buldogue Inglês', 'Pomerânia', 
    'Lhasa Apso', 'Basset Hound'
  ];

  List<String> _racasGato = [
    'Persa', 'Siamês', 'Maine Coon', 'Ragdoll', 'Bengal', 'Scottish Fold', 
    'Sphynx (Gato Pelado)', 'Abissínio', 'Munchkin', 'British Shorthair'
  ];

  List<String> _racasOutros = ['Outro'];

  @override
  Widget build(BuildContext context) {
    // Obtendo as dimensões da tela
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              title: const Text('Cadastrar Pet 🤖'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundobase.png'), // Ajuste o caminho conforme necessário
            fit: BoxFit.cover, // Garantindo que a imagem cubra a tela de forma responsiva
          ),
        ),
        child: SafeArea( // Garante que o conteúdo não sobreponha a área de status
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Campo de dropdown para o tutor
                  _buildDropdownTutor(),

                  // Outros campos
                  _buildTextField(_nomePetController, 'Nome do Pet 🦾'),
                  _buildDropdownEspecie(),
                  _buildDropdownRaca(),
                  _buildTextField(_dataNascimentoPetController, 'Data de Nascimento 🗓️'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cadastrarPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text('Cadastrar 🐾', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListarPetsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text('Pets Listados 📋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Função para criar o estilo uniforme para todos os campos
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  // Função para construir o Dropdown de Tutor com nome e CPF
  Widget _buildDropdownTutor() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tutores').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Erro ao carregar tutores: ${snapshot.error}');
          }

          final tutors = snapshot.data?.docs ?? [];

          return DropdownButtonFormField<String>(
            value: _selectedTutorId,
            hint: const Text('Selecione o Tutor'),
            isExpanded: true,
            decoration: _inputDecoration('Nome do Tutor'),
            onChanged: (value) {
              setState(() {
                _selectedTutorId = value;
              });
            },
            items: tutors.map((doc) {
              final tutor = doc.data() as Map<String, dynamic>;
              final tutorName = tutor['nome'] ?? 'Nome não disponível';
              final tutorCpf = tutor['cpf'] ?? 'CPF não disponível';
              final displayText = '$tutorName - CPF: $tutorCpf'; // Exibindo nome e CPF
              return DropdownMenuItem<String>(
                value: doc.id,
                child: Text(displayText),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // Função para construir o Dropdown de Espécie com estilo uniforme
  Widget _buildDropdownEspecie() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedEspecie,
        hint: const Text('Selecione a espécie do Pet'),
        isExpanded: true,
        decoration: _inputDecoration('Espécie do Pet'),
        onChanged: (value) {
          setState(() {
            _selectedEspecie = value;
            _selectedRaca = null; // Reseta a raça quando a espécie é alterada
          });
        },
        items: _especies.map((String especie) {
          return DropdownMenuItem<String>(
            value: especie,
            child: Text(especie),
          );
        }).toList(),
      ),
    );
  }

  // Função para construir o Dropdown de Raça com estilo uniforme
  Widget _buildDropdownRaca() {
    List<String> racas = _racasOutros; // Default para "Outro"

    if (_selectedEspecie == 'Cachorro') {
      racas = _racasCachorro;
    } else if (_selectedEspecie == 'Gato') {
      racas = _racasGato;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedRaca,
        hint: const Text('Selecione a raça do Pet'),
        isExpanded: true,
        decoration: _inputDecoration('Raça do Pet'),
        onChanged: (value) {
          setState(() {
            _selectedRaca = value;
          });
        },
        items: racas.map((String raca) {
          return DropdownMenuItem<String>(
            value: raca,
            child: Text(raca),
          );
        }).toList(),
      ),
    );
  }

  // Função para criar o campo de texto com estilo uniforme
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(label),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  // Função para cadastrar o pet no Firestore
  void _cadastrarPet() {
    if (_selectedTutorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um tutor.')),
      );
      return;
    }

    FirebaseFirestore.instance.collection('pets').add({
      'tutorId': _selectedTutorId,  // Salvando o ID do tutor
      'nomePet': _nomePetController.text,
      'especiePet': _selectedEspecie,
      'racaPet': _selectedRaca,
      'dataNascimentoPet': _dataNascimentoPetController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet cadastrado com sucesso! 🐾')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ListarPetsPage()));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar pet. 😞')),
      );
    });
  }
}
