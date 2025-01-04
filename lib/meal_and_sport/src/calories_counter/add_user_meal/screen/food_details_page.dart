
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common_widgets/donut_chart.dart';
import '../../../user/blocs/user_bloc.dart';
import '../../../user/blocs/user_state.dart';
import '../../calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../models/meal.dart';
import '../blocs/add_meal_bloc.dart';

class FoodDetailsPage extends StatelessWidget{
  final Meal meal;
  final String mealType;
  final int userId;
  final CaloriesCounterMainBloc caloriesMainBloc;

  const FoodDetailsPage({super.key,
    required this.meal,
    required this.mealType,
    required this.userId,
    required this.caloriesMainBloc
  });

  @override
  Widget build(BuildContext context) {

    List<ChartData> nutritions = [];
    if(meal.carbsPer100g != null && meal.carbsPer100g != 0 ){
      nutritions.add(ChartData(name: "Carbs", value: meal.carbsPer100g!, color: const Color.fromARGB(156, 232, 0, 0)));
    }
    if(meal.proteinPer100g != null && meal.proteinPer100g != 0 ){
      nutritions.add(ChartData(name: "Protein", value: meal.proteinPer100g!, color: const Color.fromRGBO(18, 239, 239, 0.612)));
    }
    if(meal.fatPer100g != null && meal.fatPer100g != 0 ){
      nutritions.add(ChartData(name: "Fat", value: meal.fatPer100g!, color: const Color.fromRGBO(248, 233, 60, 0.612)));
    }

    return BlocProvider(
      create: (context) => AddUserMealBloc(meal: meal, mealType: mealType, userId: userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Food'),
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text(meal.name,
                      style: const TextStyle(
                          fontSize: 19,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Itim"
                      )
                  ),
                ),
                const SizedBox(height: 15), // Add top spacing

                 Center(
                  child: DonutChart(
                    dataList: nutritions,
                    donutSizePercentage: 0.7,
                    columnLabel: "Value per 100 g (g)",
                    containerHeight: 250,

                    centerText: meal.energyPer100g != null ? "${meal.energyPer100g?.toStringAsFixed(2)} kcal\n per 100 g" : null
                  ),
                ),
                const SizedBox(height: 30),
                 Text(
                   meal.unitWeight != null ? "Serving size: ${meal.unitWeight}g" : "No serving size",


                  style: const TextStyle(
                      fontSize: 15,
                    fontWeight: FontWeight.w800,

                  ),
                ),
                const SizedBox(height: 10), // Add top spacing

                ToggleButton(
                    meal: meal,
                    mealType: mealType,
                  caloriesMainBloc: caloriesMainBloc,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}

class ToggleButton extends StatefulWidget{

  final Meal meal;
  final String mealType;
  final CaloriesCounterMainBloc caloriesMainBloc;

  const ToggleButton({
    super.key,
    required this.meal,
    required this.mealType, required this.caloriesMainBloc
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double? userInputValue ;
    return BlocConsumer<AddUserMealBloc,AddUserMealState>(

      builder: (context, state) {
        return Column(
          children: [
            ToggleButtons(

              isSelected:
              widget.meal.unitWeight == null ?
              [
                true,
                false
              ]
                  :
              [
                !state.isNoOfServingSelected,
                state.isNoOfServingSelected
              ],
              onPressed: (int index){
                final model = BlocProvider.of<AddUserMealBloc>(context);
                if(index == 1 ){
                  if(widget.meal.unitWeight == null) {
                    return;
                  }else{
                    model.add(NoOfServingsSelected());
                  }

                }else{
                  model.add(AmountInGramsSelected());
                }
              },
              color: Colors.grey,
              selectedColor: Colors.blue,
              fillColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Amount in grams")
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Number of Servings"),
                )
              ],
            ),
            const SizedBox(height: 10),

            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Number of servings or Amount in grams can't be empty");
                }
                try{
                  userInputValue = double.parse(value);
                  return null;
                }catch(e){
                  return ("Enter number only");
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      final model = BlocProvider.of<AddUserMealBloc>(context);
                      setState(() {
                        _controller.clear();
                        model.add(DisposeCalculation());
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: const OutlineInputBorder().copyWith(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0),),
                  ),

                  errorMaxLines: 4,
                  hintText: state.isNoOfServingSelected == true ? "Number of servings" : "Amount in grams",
                  hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width  * 0.5,
                  )
              ),
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            Visibility(
              visible: !state.isCalculated,
              child: ElevatedButton(onPressed: ()
              {
                final model = BlocProvider.of<AddUserMealBloc>(context);

                model.add(UserInput(food: widget.meal, userInput: userInputValue!));

              },
                  child: const Text("Calculate Calories")
              ),
            ),

            Visibility(
                visible: state.isCalculated,
                child: const NutrientCardGroup()
            ),

            const SizedBox(height: 15),

            Visibility(
              visible: state.isCalculated,
              child: ElevatedButton(onPressed: () async
              {

                final model = BlocProvider.of<AddUserMealBloc>(context);

                // final userState = BlocProvider.of<UserBloc>(context).state;
                final userMealState = model.state;

                // if (userState is LoginSuccess) {
                  model.add(
                      AddMealBtnClicked(
                      mealType: widget.mealType.toUpperCase(),
                      amountInGrams: userMealState.amountIntakeInGrams!,
                      carbsInGrams: userMealState.carbsIntake,
                      proteinInGrams: userMealState.proteinIntake,
                      fatInGrams: userMealState.fatIntake,
                      calories: userMealState.energyIntake,
                    )
                  );
                // }

              },
                  child: const Text("Add")
              ),
            ),
          ],
        );
      },
      listener: (context, state) {

                widget.caloriesMainBloc.add(ReloadMealList());
                // Listen to CaloriesCounterMainBloc state changes
                   showDialog(
                     context: context,
                     barrierDismissible: false,
                     builder: (BuildContext dialogContext) => Center(
                       child: AlertDialog(
                         content: const Text(
                             "Meal is added."),
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
           },
      listenWhen: (previous,current){
        return current.status == AddUserMealStatus.mealAdded;
      },

    );
  }
}



class NutrientCardGroup extends StatefulWidget {

  const NutrientCardGroup({super.key});
  @override
  State<NutrientCardGroup> createState() => _NutrientCardGroupState();
}

class _NutrientCardGroupState extends State<NutrientCardGroup> {
  // Nutrient values

  // NutrientCard widget to display individual nutrient info
  Widget nutrientCard(String title, String value) {

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddUserMealBloc,AddUserMealState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    nutrientCard("Calories", "${state.energyIntake?.toStringAsFixed(2) ?? 0} kcal"),
                    nutrientCard("Carbs", "${state.carbsIntake?.toStringAsFixed(2) ?? 0} g"),
                    nutrientCard("Protein", "${state.proteinIntake?.toStringAsFixed(2) ?? 0} g"),
                    nutrientCard("Fat", "${state.fatIntake?.toStringAsFixed(2) ?? 0} g"),
                  ],
                ),
              ],
            ),
          ),
        );
      },

    );
  }
}

