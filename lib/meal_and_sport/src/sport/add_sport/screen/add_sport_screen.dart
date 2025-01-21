import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/add_sport/screen/sport_type_screen.dart';

import '../blocs/add_sport_bloc.dart';
class AddSportScreen extends StatefulWidget {
  const AddSportScreen({super.key});

  @override
  State<AddSportScreen> createState() => _AddSportScreenState();
}

class _AddSportScreenState extends State<AddSportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesBurntController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF599BF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.popUntil(context, (route) => route.settings.name == "/sportMain")
        ),
        title: const Text('Add New Sport', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddSportBloc,AddSportState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCard(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                              fontSize: 15,
                            color: Colors.grey
                          ),
                          labelText: 'Sport Name',
                          border: OutlineInputBorder(),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a sport name';
                          }else if(value.length <= 3){
                            return 'Sport name must longer than 3 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final bloc = context.read<AddSportBloc>();
                        bloc.add(SportTypeListSelected());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              state.selectedSportType ?? 'Select Sport Type',
                              style: TextStyle(
                                color: state.selectedSportType != null ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                          const Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 16),
                              child:  Icon(Icons.arrow_forward_ios, size: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildInput(
                              'Calories Burnt Per kg/h (kcal)', _caloriesBurntController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      // onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ), onPressed: () {
                      if (_formKey.currentState!.validate() && _nameController.text.isNotEmpty && _caloriesBurntController.text.isNotEmpty) {
                        final bloc = context.read<AddSportBloc>();
                        bloc.add(AddSportBtnSelectedEvent(name: _nameController.text.toUpperCase(), caloriesBurnt: double.parse(_caloriesBurntController.text)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields')),
                        );
                      }
                    },
                      // onPressed: _submitForm,
                      child: const Text('Add New Sport'),
                    ),
                  ],
                ),
              );
            },
            listener: (context,state) {
              if(state.status == AddSportStatus.sportAdded){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: AlertDialog(
                        content: const Text(
                            "New Sport is added."),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          ElevatedButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.settings.name == "/sportMain");
                              // Close the dialog
                            },
                          ),
                        ],
                      )
                  ),
                );
              }else if(state.status == AddSportStatus.sportTypeListSelected && state.sportTypeList!=null){
                final bloc = BlocProvider.of<AddSportBloc>(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BlocProvider<AddSportBloc>.value(
                          value: bloc,
                          child: const SportTypeScreen(),
                        )
                  ),
                );
              }

            },
            listenWhen: (previous,current){
              return (current.status == AddSportStatus.sportAdded ||current.status == AddSportStatus.sportTypeListSelected  );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
            fontSize: 15,
            color: Colors.grey
        ),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
    );
  }

}
