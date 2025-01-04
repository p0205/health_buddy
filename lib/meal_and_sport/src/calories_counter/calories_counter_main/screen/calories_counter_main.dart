
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_bloc.dart';
import '../../../../../commom_widgets/side_bar.dart';
import '../../../common_widgets/donut_chart.dart';
import '../../models/meal_summary.dart';
import '../../models/user_meal.dart';
import '../../search_meal/blocs/search_meal_bloc.dart';
import '../../search_meal/screen/search_food_screen.dart';
import '../blocs/calories_counter_main_bloc.dart';

class CaloriesCounterMainScreen extends StatefulWidget{
   final CaloriesCounterMainBloc bloc;
   final SportMainBloc? sportBloc;
   const CaloriesCounterMainScreen({super.key, required this.bloc,  this.sportBloc});

  @override
  State<CaloriesCounterMainScreen> createState() => _CaloriesCounterMainScreenState();
}

class _CaloriesCounterMainScreenState extends State<CaloriesCounterMainScreen> {

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final userId = userBloc.state.userId!;
    final name = userBloc.state.name;
    final email = userBloc.state.email;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
             value: context.read<CaloriesCounterMainBloc>()
            ),
              ],
            child: Scaffold(

                appBar: AppBar(
                  title: const Text("Calories Counter",textAlign: TextAlign.center),
                  backgroundColor: Colors.blueAccent,
                  titleTextStyle: const TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
                drawer: SideBar(userId: userId, userEmail: email!,userName: name!),
                body: SingleChildScrollView(
                  child: BlocBuilder<CaloriesCounterMainBloc,CaloriesCounterMainState>(
                    builder: (BuildContext context, CaloriesCounterMainState state) {
                    if(widget.bloc.state.status == CaloriesCounterMainStatus.loading){
                      return Center(child: CircularProgressIndicator());
                    }else{
                      final Map<String, List<UserMeal>?>? mealList = widget.bloc.state.mealList;
                      final MealSummary summary = widget.bloc.state.summary!;
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
                                    bloc: widget.bloc,
                                  );
                                }),
                          ],
                        ),
                      );
                    }

                    },
                  )
                )
            ),
          );
  }
}


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
  final CaloriesCounterMainBloc bloc;

  const FoodIntakeCard({
    super.key,
    required this.section,
    this.meals, required this.bloc,
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
                      MaterialPageRoute(builder: (context) => SearchPage(mealType: mealType,caloriesMainBloc: widget.bloc,)),
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
                                              widget.bloc.add(DeleteMealBtnClicked(userMealId: meal.id!));
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



