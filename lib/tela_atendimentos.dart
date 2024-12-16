import 'package:animus_senai/listar_atendimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AtendimentosPage extends StatefulWidget {
  AtendimentosPage({super.key});

  @override
  _AtendimentosPageState createState() => _AtendimentosPageState();
}

class _AtendimentosPageState extends State<AtendimentosPage> {
  final TextEditingController petController = TextEditingController();
  final TextEditingController servicoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  String? selectedPet;
  String? selectedServico;

  
  List<String> servicosList = [
    'Tosa baby',
    'Tosa baixa',
    'Tosa verão',
    'Consulta médica',
    'Tosa higiênica',
    'Vacinação',
    'Exame clínico',
    'Consulta de emergência',
    'Castração',
    'Banho antipulgas',
    'Outro'
  ];

  List<String> petsList = [];
  
  @override
  void initState() {
    super.initState();
    fetchPets(); 
  }

  Future<void> fetchPets() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pets').get();
      List<String> fetchedPets = snapshot.docs
          .map((doc) => doc['nomePet'] as String)
          .toList();

      setState(() {
        petsList = fetchedPets;
      });
    } catch (e) {
      print('Erro ao buscar pets: $e');
    }
  }

  Future<void> saveAtendimento(BuildContext context) async {
    try {
      final pet = selectedPet;
      final servico = selectedServico;
      final observacoes = observacoesController.text;

      if (pet == null || servico == null || observacoes.isEmpty) {
        return;
      }

      await FirebaseFirestore.instance.collection('atendimentos').add({
        'pet': pet,
        'servico': servico,
        'observacoes': observacoes,
        'data': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atendimento salvo com sucesso!')),

      );
      petController.clear();
      servicoController.clear();
      observacoesController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar atendimento: $e')),

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atendimentos'),
        backgroundColor: const Color.fromARGB(255, 247, 223, 173),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundobase.png'),
            fit: BoxFit.cover, 
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDropdown(
                    label: 'Pet 🐾',
                    value: selectedPet,
                    hint: 'Selecione um pet',
                    items: petsList,
                    onChanged: (newValue) {
                      setState(() {
                        selectedPet = newValue;
                        petController.text = newValue ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Serviço 🛠️',
                    value: selectedServico,
                    hint: 'Selecione um serviço',
                    items: servicosList,
                    onChanged: (newValue) {
                      setState(() {
                        selectedServico = newValue;
                        servicoController.text = newValue ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: observacoesController,
                    label: 'Observações 📝',
                    maxLines: 4,
                  ),

                  const SizedBox(height: 32),

              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão Salvar
                      Expanded(
                        child: _buildButton(
                          label: 'Salvar',
                          onPressed: () => saveAtendimento(context),
                          color: const Color.fromARGB(255, 106, 245, 233), 
                        ),
                      ),
                      const SizedBox(width: 16),
                  
                      Expanded(
                        child: _buildButton(
                          label: 'Listar Atendimentos',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListAtendimentosPage(),
                              ),
                            );
                          },
                          color: const Color.fromARGB(255, 240, 214, 65),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0), 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white, 
              border: Border.all(color: Colors.blue), 
            ),
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint),
              onChanged: onChanged,
              isExpanded: true,
              style: TextStyle(fontSize: 18, color: Colors.black),
              iconSize: 30,
              underline: SizedBox(), 
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int maxLines,
  }) {
    return Container(
      width: double.infinity,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18),
          filled: true, 
          fillColor: Colors.white, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }


  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(fontSize: 20)), 
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: TextStyle(fontSize: 20), 
        ),
      ),
    );
  }
}
