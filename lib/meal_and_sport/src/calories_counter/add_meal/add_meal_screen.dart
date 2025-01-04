import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/calories_counter/add_meal/review_nutrition_screen.dart';

import '../../common_widgets/loading_overlay.dart';
import 'blocs/add_meal_bloc.dart';

class AddMealScreen extends StatefulWidget {

  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameDialogController = TextEditingController();
  final TextEditingController _unitWeightController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddMealBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: const Text('Add New Meal', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddMealBloc,AddMealState>(
            builder: (context, state) {
              return Column(
                children: [
                  // if(state.status == AddMealStatus.initial|| state.status == AddMealStatus.fileUploaded)
                  _buildUploadNutritionTable(),
                  const SizedBox(width: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCard(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Meal Name',
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a meal name';
                              }else if(value.length <= 3){
                                return 'Meal name must longer than 3 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildMeasurementTypeToggle(),
                              if (bloc.state.isUnitWeightSelected) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _unitWeightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Unit Weight (g)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (bloc.state.isUnitWeightSelected &&
                                        (value == null || value.isEmpty)) {
                                      return 'Please enter the unit weight';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Energy (kcal)', _energyController),
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Carbohydrates (g)', _carbsController),
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Protein (g)', _proteinController),
                              const SizedBox(height: 16),
                              _buildNutritionInput('Fat (g)', _fatController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          // onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ), onPressed: () {
                          if (_formKey.currentState!.validate() && _nameController.text.isNotEmpty) {
                            final bloc = context.read<AddMealBloc>();
                            bloc.add(AddMealBtnSelectedEvent(
                                mealNameInputString: _nameController.text.toUpperCase(),
                                unitWeightInputString: _unitWeightController.text,
                                energyInputString: _energyController.text,
                                carbsInputString: _carbsController.text,
                                proteinInputString: _proteinController.text,
                                fatInputString: _fatController.text));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all required fields')),
                            );
                          }
                        },
                          // onPressed: _submitForm,
                          child: const Text('Add New Meal'),
                        ),
                      ],
                    ),
                  ),
              ],
              );
            },
            buildWhen: (context,state){
              return (state.status!=AddMealStatus.nutriExtracted && state.status != AddMealStatus.loading);
            },
            listener: (context, state) {
              if(state.status == AddMealStatus.loading){
                LoadingOverlay.show(context);
              }else if (state.status != AddMealStatus.loading) {
                // Dismiss the loading overlay when the status changes from loading
                Navigator.of(context, rootNavigator: true).pop();
              }


              if(state.status == AddMealStatus.mealAdded){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                      child: AlertDialog(
                        content: const Text(
                            "New Meal is added."),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          ElevatedButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.settings.name == "/mealMain");
                            },
                          ),
                        ],
                      )
                  ),
                );
              }


              if(state.status == AddMealStatus.nutriExtracted){

                final route = ModalRoute.of(context);
                final isCurrentRoute = route?.isCurrent ?? false;
                if (isCurrentRoute) {
                  final bloc = BlocProvider.of<AddMealBloc>(context);
                  if(bloc.state.meal?.unitWeight == null){
                    bloc.add(Per100SelectedEvent());
                  }else{
                    bloc.add(UnitWeightSelectedEvent());
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        BlocProvider<AddMealBloc>.value(
                          value: bloc,
                          child: ReviewNutritionScreen(meal:bloc.state.meal!),
                        )
                    ),
                  );
                }

              }

            },
            listenWhen: (previous,current){
              return (current.status == AddMealStatus.mealAdded || current.status == AddMealStatus.nutriExtracted || current.status == AddMealStatus.loading);
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

  Widget _buildMeasurementTypeToggle() {
    final bloc = context.read<AddMealBloc>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                bloc.add(Per100SelectedEvent());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !bloc.state.isUnitWeightSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Per 100g',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !bloc.state.isUnitWeightSelected ? Colors.blue : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: ()  {
                bloc.add(UnitWeightSelectedEvent());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: bloc.state.isUnitWeightSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Per Unit Weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bloc.state.isUnitWeightSelected ? Colors.blue : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUploadNutritionTable(){
    final bloc = context.read<AddMealBloc>();
    return Column(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [10,10],
            color: Colors.grey,
            strokeWidth: 2,
            child:

            (bloc.state.status == AddMealStatus.fileUploaded || bloc.state.status == AddMealStatus.nutriExtracted) ?
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 48, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                      'File Uploaded Successfully',
                      style: TextStyle(
                        color: Colors.green,
                      )
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(

                          title: const Text('Enter Meal Name'),
                          content: TextField(
                            controller: _nameDialogController,

                            decoration: const InputDecoration(
                              labelText: 'Enter Meal Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog without action
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final mealName = _nameDialogController.text.toUpperCase().trim();
                                if (mealName.isNotEmpty || mealName.length > 3) {
                                  Navigator.of(context).pop(); // Close dialog
                                  bloc.add(ExtractNutriEvent(file: bloc.state.file!, name: mealName));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please enter a meal name which consists of more than 3 characters.')),
                                  );
                                }
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    child: const Text('Extract Nutrition'),
                  ),
              ],
                        ),
            ) :

            InkWell(
              onTap: (){
                context.read<AddMealBloc>().add(UploadFileEvent());
              },
              child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20), // Circular edges
                      ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.blue, size: 32),
                     SizedBox(height: 8),
                     Text(
                      'Upload Nutrition Table',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                     SizedBox(height: 4),
                     Text(
                      'Quick fill meal details',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  ),),
            )
        ),
        TextButton(
          onPressed: _showImageUploadInfo,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 16),
              SizedBox(width: 2),
              Text('How it works', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
    );
  }

  void _showImageUploadInfo() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to Use Image Upload', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                    '1. Tap the "Upload Nutrition Table" button.\n'
                    '2. Upload a clear photo of the nutrition table.\n'
                    '3. Our system will automatically extract and fill in the nutritional information for you.\n'
                    '4. Review and adjust the information if needed.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

}
