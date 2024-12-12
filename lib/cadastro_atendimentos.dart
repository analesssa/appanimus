import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Atendimentos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Atendimento> atendimentos = [];

  void _addAtendimento(Atendimento atendimento) {
    setState(() => atendimentos.add(atendimento));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Atendimentos'), backgroundColor: Colors.blue),
      body: atendimentos.isEmpty
          ? const Center(child: Text('Nenhum atendimento cadastrado.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: atendimentos.length,
              itemBuilder: (context, index) {
                final atendimento = atendimentos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(atendimento.petNome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${atendimento.tipoAtendimento} - ${atendimento.dataAtendimento.toLocal().toString().split(' ')[0]}\n'
                        '${atendimento.descricao}\n'
                        'Espécie: ${atendimento.especie} | Sexo: ${atendimento.sexo}', 
                        style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.pets, color: Colors.blue),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAtendimento = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAtendimentoScreen()));
          if (newAtendimento != null) _addAtendimento(newAtendimento);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class Atendimento {
  String petNome, tipoAtendimento, descricao, especie, sexo;
  DateTime dataAtendimento;

  Atendimento({
    required this.petNome,
    required this.tipoAtendimento,
    required this.descricao,
    required this.dataAtendimento,
    required this.especie,
    required this.sexo,
  });
}

class AddAtendimentoScreen extends StatefulWidget {
  const AddAtendimentoScreen({Key? key}) : super(key: key);

  @override
  _AddAtendimentoScreenState createState() => _AddAtendimentoScreenState();
}

class _AddAtendimentoScreenState extends State<AddAtendimentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'petNome': TextEditingController(),
    'descricao': TextEditingController(),
    'dataAtendimento': TextEditingController(),
  };

  String _tipoAtendimento = 'Consulta';
  String _especie = 'Cão';  
  String _sexo = 'Macho';   
  DateTime? _dataAtendimento;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataAtendimento ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dataAtendimento = picked;
        _controllers['dataAtendimento']!.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Atendimento'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('petNome', 'Nome do Pet'),
                const SizedBox(height: 16),
                _buildDropdownTipoAtendimento(),
                const SizedBox(height: 16),
                _buildDropdownEspecie(),
                const SizedBox(height: 16),
                _buildDropdownSexo(),
                const SizedBox(height: 16),
                _buildTextField('descricao', 'Descrição'),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField('dataAtendimento', 'Data do Atendimento'),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Cadastrar Atendimento'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor, insira o $label';
        return null;
      },
    );
  }

  Widget _buildDropdownTipoAtendimento() {
    return DropdownButtonFormField<String>(
      value: _tipoAtendimento,
      onChanged: (newValue) {
        setState(() {
          _tipoAtendimento = newValue!;
        });
      },
      items: <String>[
        'Consulta',
        'Vacinação',
        'Exame',
        'Emergência',
        'Tosa',
        'Cirurgia',
        'Atendimento de Urgência',
        'Reabilitação',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Tipo de Atendimento',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor, selecione o tipo de atendimento';
        return null;
      },
    );
  }

  Widget _buildDropdownEspecie() {
    return DropdownButtonFormField<String>(
      value: _especie,
      onChanged: (newValue) {
        setState(() {
          _especie = newValue!;
        });
      },
      items: <String>[
        'Cão',
        'Gato',
        'Outro',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Espécie do Animal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownSexo() {
    return DropdownButtonFormField<String>(
      value: _sexo,
      onChanged: (newValue) {
        setState(() {
          _sexo = newValue!;
        });
      },
      items: <String>[
        'Macho',
        'Fêmea',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Sexo do Animal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final atendimento = Atendimento(
        petNome: _controllers['petNome']!.text,
        tipoAtendimento: _tipoAtendimento,
        descricao: _controllers['descricao']!.text,
        dataAtendimento: _dataAtendimento!,
        especie: _especie,
        sexo: _sexo,
      );
      Navigator.pop(context, atendimento);

      _controllers['petNome']!.clear();
      _controllers['descricao']!.clear();
      _controllers['dataAtendimento']!.clear();
      setState(() {
        _tipoAtendimento = 'Consulta';
        _especie = 'Cão';
        _sexo = 'Macho';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atendimento cadastrado com sucesso!')),
      );
    }
  }
}