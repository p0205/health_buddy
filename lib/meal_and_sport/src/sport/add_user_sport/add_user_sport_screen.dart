

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../user/blocs/user_bloc.dart';
import '../../user/blocs/user_state.dart';
import '../sport_main/blocs/sport_main_bloc.dart';
import '../sport_models/sport.dart';
import 'bloc/add_user_sport_bloc.dart';

class AddUserSportScreen extends StatelessWidget{
  final Sport sport;
  final String date;
  final int userId;

  const AddUserSportScreen({super.key,
    required this.sport,
    required this.date,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sport'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => AddUserSportBloc(sport: sport, userId: userId),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(sport.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Itim"
                          )
                      ),
                    ),
                    const SizedBox(height: 15), // Add top spacing
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoBox('Type', sport.type as String),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoBox('Calories burnt per kg/hour', '${sport.caloriesBurntPerHourPerKg} kcal'),

                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ToggleButton(
                      date: date,
                      sport: sport,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ToggleButton extends StatefulWidget{

  final Sport sport;
  final String date;

  const ToggleButton({
    super.key,
    required this.sport,
    required this.date
  });

  @override
  State<ToggleButton> createState() => _toggleButtonState();
}

class _toggleButtonState extends State<ToggleButton> {


  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double? userInputValue ;

    return BlocConsumer<AddUserSportBloc,AddUserSportState>(
      builder: (context, state) {

        if(state.status == AddUserSportStatus.loading){
          return const CircularProgressIndicator();
        }
        if(state.status == AddUserSportStatus.failure){
          return Text(state.message!);
        }
        if(state.status == AddUserSportStatus.initial){
          return Column(
            children: [
              ToggleButtons(
                isSelected: [
                  state.isDurationInHoursSelected,
                  !state.isDurationInHoursSelected
                ],
                onPressed: (int index){
                  final model = BlocProvider.of<AddUserSportBloc>(context);
                  if(index == 0 ){
                    model.add(DurationInHoursSelected());
                  }else{
                    model.add(DurationInMinutesSelected());
                  }
                },
                color: Colors.grey,
                selectedColor: Colors.blue,
                fillColor: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Duration in Hours"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("Duration in Minutes")
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Duration can't be empty");
                  }
                  try{
                    userInputValue = double.parse(value);
                    return null;
                  }catch(e){
                    return ("Enter number only");
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _controller, // Attach the controller to the TextField
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        final model = BlocProvider.of<AddUserSportBloc>(context);
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
                    hintText: state.isDurationInHoursSelected == true ? "hours" : "minutes",
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
                  final model = BlocProvider.of<AddUserSportBloc>(context);
                  model.add(UserInput(sport: widget.sport, userInput: userInputValue!));
                  model.add(CalculateBtnClicked());
                },
                    child: const Text("Calculate Calories Burnt")
                ),
              ),
              const SizedBox(height: 15),
              state.isCalculated ?
              Visibility(
                  visible: state.isCalculated,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${state.caloriesBurnt!.toStringAsFixed(2)} calories burnt",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.deepOrange,
                      size: 20,
                    ),
                  ],
                ),

              )
              : const SizedBox(height: 15),

              Visibility(
                visible: state.isCalculated,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () async
                  {
                    final model = BlocProvider.of<AddUserSportBloc>(context);
                    final userState = BlocProvider.of<UserBloc>(context).state;

                    if (userState is LoginSuccess) {
                      model.add(
                          AddSportBtnClicked(
                              durationInHours: state.durationInHours!,
                              caloriesBurnt: state.caloriesBurnt!
                          )
                      );
                    }
                  },
                      child: const Text("Add")
                  ),
                ),
              ),
            ],
          );
        }

        return Container();

      },
      listener: (context, state) {
        final sportMainBloc = context.read<SportMainBloc>();
        sportMainBloc.add(SportAdded());

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                  child: AlertDialog(
                    content: const Text(
                        "Sport is added."),

                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      ElevatedButton(
                        child: const Text("OK"),
                        onPressed: () {
                          sportMainBloc.add(LoadUserSportList());

                          Navigator.popUntil(context, (route) => route.settings.name == "/sportMain");

                        },
                      ),
                    ],
                  )
              ),
            );
      },

      listenWhen: (previous,current){
        return (current.status == AddUserSportStatus.userSportAdded);
      },
    );
  }
}
