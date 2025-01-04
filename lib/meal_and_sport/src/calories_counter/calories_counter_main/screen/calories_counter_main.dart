
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widgets/donut_chart.dart';
import '../../models/meal_summary.dart';
import '../../models/user_meal.dart';
import '../../search_meal/screen/search_food_screen.dart';
import '../blocs/calories_counter_main_bloc.dart';

class CaloriesCounterMainScreen extends StatefulWidget{

   const CaloriesCounterMainScreen({super.key});

  @override
  State<CaloriesCounterMainScreen> createState() => _CaloriesCounterMainScreenState();
}

class _CaloriesCounterMainScreenState extends State<CaloriesCounterMainScreen> {

  @override
  Widget build(BuildContext context) {

          return Scaffold(
              appBar: AppBar(
                title: const Text("Calories Counter",textAlign: TextAlign.center),
                backgroundColor: Colors.blueAccent,
                titleTextStyle: const TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),

                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30.0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: BlocBuilder<CaloriesCounterMainBloc,CaloriesCounterMainState>(
                  builder: (BuildContext context, CaloriesCounterMainState state) {


                  final Map<String, List<UserMeal>?>? mealList = context.read<CaloriesCounterMainBloc>().state.mealList;
                  final MealSummary summary = context.read<CaloriesCounterMainBloc>().state.summary!;


                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          summary.date,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Itim',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        CaloriesChart(summary: summary),
                        const SizedBox(height: 30),
                        const Text(
                          "Daily Meals",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context,index){
                              final List<String> sectionOrder = ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'];
                              final String mealType = sectionOrder[index];  // Access the section name from predefined order
                              List<UserMeal>? meals = mealList?[mealType];  // Get the meals for this section
                              return FoodIntakeCard(
                                section: mealType, // For each mealType, has one FoodIntake card
                                meals: meals,
                              );
                            }),
                      ],
                    ),
                  );
                  },
                )
              )
          );
  }
}


// class CaloriesCounterPage extends StatefulWidget{
//   late final Map<String, List<UserMeal>?>? mealList;
//   late final double? caloriesLeft;
//   @override
//   State<CaloriesCounterPage> createState() => _CaloriesCounterPageState();
// }
//
// class _CaloriesCounterPageState extends State<CaloriesCounterPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Calories Counter"),
//         backgroundColor: Colors.blueAccent,
//         titleTextStyle: const TextStyle(
//             fontFamily: 'Itim',
//             fontSize: 25,
//             fontWeight: FontWeight.bold
//         ),
//       ),
//       body: BlocConsumer<CaloriesCounterMainBloc,CaloriesCounterMainState>(
//         builder: (context,state){
//           if(state.isLoading) {
//             return const CircularProgressIndicator();
//           }
//           if(state.isMealListLoaded){
//             widget.caloriesLeft = state.caloriesLeft;
//             widget.mealList = state.mealList;
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     CaloriesChart(calories: 500),
//                     const SizedBox(height: 10),
//                     ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: widget.mealList?.keys.length ?? 0,
//                         itemBuilder: (context,index){
//                           final String mealType = widget.mealList?.keys.elementAt(index) ?? "";
//                           List<UserMeal>? meals = widget.mealList?[mealType];// key at this index
//                           return FoodIntakeCard(
//                             section: mealType, // For each mealType, has one FoodIntake card
//                             meals: meals!,
//                           );
//
//                         }),
//                   ],
//                 ),
//               ),
//             );
//           }
//           print(state.status);
//         return const Center(
//           child: Text("No Record Today"),
//         );
//       }, listener: (BuildContext context, CaloriesCounterMainState state) {  } ,
//
//       ),
//     );
//   }
// }
//



class CaloriesChart extends StatelessWidget {

  const CaloriesChart({
    super.key,
    required this.summary
  });

  final MealSummary summary;


  @override
  Widget build(BuildContext context) {
    bool isExceed = summary.caloriesLeft.isNegative;
    List<ChartData> nutritions = [];
    nutritions.add(ChartData(name: "Carbs", value: summary.carbsIntake, color: const Color.fromARGB(156, 232, 0, 0)));

    nutritions.add(ChartData(name: "Protein", value: summary.proteinIntake, color: const Color.fromRGBO(18, 239, 239, 0.612)));

    nutritions.add(ChartData(name: "Fat", value:summary.fatIntake, color: const Color.fromRGBO(248, 233, 60, 0.612)));


    return Center(
      child: DonutChart(
        dataList: nutritions,
        donutSizePercentage: 0.7,
        columnLabel: "Intake amount (g)",
        containerHeight: 240,

        centerText:  isExceed? "${summary.caloriesLeft.toStringAsFixed(2)} kcal\nexceed": "${summary.caloriesLeft.toStringAsFixed(2)} kcal\nremaining",

        centerTextColor: isExceed? Colors.redAccent : null,
      ),
    );
  }
}

class FoodIntakeCard extends StatefulWidget {

  final String section;
  final List<UserMeal>? meals;

  const FoodIntakeCard({
    super.key,
    required this.section,
    this.meals,
  });

  @override
  State<FoodIntakeCard> createState() => _FoodIntakeCardState();
}

class _FoodIntakeCardState extends State<FoodIntakeCard> {


  @override
  Widget build(BuildContext context) {
    double totalCalories = 0;
    if(widget.meals!=null){
      for(var meal in widget.meals!){
        totalCalories = totalCalories + meal.calories! ;
      }
    }
    String totalCaloriesString = totalCalories.toStringAsFixed(2);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 6 ,
                  child: Text(
                    widget.section,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(

                    "$totalCaloriesString kcal",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final String mealType = widget.section;

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage(mealType: mealType)),
                    );
                  },
                  child: const Icon(Icons.add), // )
                ),

              ],
            ),
            const SizedBox(height: 10),
            widget.meals == null ?
              const Text(

                  "No record",
                  style: TextStyle(color: Colors.grey ,fontSize: 13, fontWeight: FontWeight.normal),
              )
                :
              Column(
                children: widget.meals!.map((meal) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      meal.mealName!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    subtitle: Text("${meal.amountInGrams.toString()} g"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // To keep the row compact
                      children: [

                        Text("${meal.calories!.toStringAsFixed(2)} kcal"),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {

                            showDialog(
                              context: context,

                              barrierDismissible: false,
                              builder: (context) => Center(
                                  child: AlertDialog(
                                    content: const Text(
                                        "Confirm to delete This Meal? ",
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              final caloriesCounterBloc = context.read<CaloriesCounterMainBloc>();

                                              caloriesCounterBloc.add(DeleteMealBtnClicked(userMealId: meal.id!));
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            child: const Text("CANCEL"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
          ],

        ),

      ),
    );
  }
}



