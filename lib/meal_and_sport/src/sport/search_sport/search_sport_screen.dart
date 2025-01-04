
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/blocs/user_bloc.dart';
import '../../user/blocs/user_state.dart';
import '../add_sport/screen/add_sport_screen.dart';
import '../add_sport/blocs/add_sport_bloc.dart';
import '../add_user_sport/add_user_sport_screen.dart';
import 'bloc/search_sport_bloc.dart';


class SearchSportScreen extends StatelessWidget {

  final String date;

  const SearchSportScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sport'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: DebouncedSearchBar(date: date),
      ),
    );
  }
}

class DebouncedSearchBar extends StatefulWidget {

  final String date;

  const DebouncedSearchBar({super.key,required this.date});


  @override
  State<DebouncedSearchBar> createState() => _DebouncedSearchBarState();
}

class _DebouncedSearchBarState extends State<DebouncedSearchBar> {

  final SearchController _searchController = SearchController();

  @override
  Widget build(BuildContext context) {

    return SearchAnchor(
      searchController: _searchController,
      builder: (BuildContext context, SearchController controller) {

        return SearchBar(
          key: UniqueKey(),
          controller: controller,
          leading: const Icon(Icons.search),
          hintText: "Search for a sport",
          onTap: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        final model = BlocProvider.of<SearchSportBloc>(context);
        model.add(
          SearchQueryChanged(query: controller.text),);
        return [
          BlocConsumer<SearchSportBloc, SearchSportState>(
            builder: (context,state){
              if (state.status == SearchSportStatus.loading){
                return const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 20),
                  child:  Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if(state.status == SearchSportStatus.sportsLoaded && state.sports != null){
                if(state.sports!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No Results Found',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'We couldn\'t find what you\'re looking for. Would you like to add it?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Sport'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          final model = BlocProvider.of<SearchSportBloc>(context);
                          model.add(const AddNewSportBtnSelectedEvent());
                        },
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // Ensures the ListView takes only necessary space
                    children: state.sports!.map((result) {
                      return ListTile(
                        title: Text(result.name),
                        trailing: Text(
                          result.caloriesBurntPerHourPerKg != null
                              ? "${result.caloriesBurntPerHourPerKg?.toStringAsFixed(2)} kcal/h/kg"
                              : "",
                          style: const TextStyle(fontSize: 15),
                        ),
                        onTap: () async {
                          model.add(SportSelectedEvent(id: result.id!));
                        },
                      );
                    }).toList(),
                  ),
                );


              }

              if(state.status == SearchSportStatus.failure){
                return Text("Something went wrong...Please try again. \nError: ${state.message}");
              }
             return Container();
            }, listener: (context, state) {

            if(state.status == SearchSportStatus.selected && state.selectedSport!=null) {
              final userState = BlocProvider.of<UserBloc>(context).state;
              int userId;
              if(userState is LoginSuccess){
                userId = userState.userId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUserSportScreen(sport: state.selectedSport!, userId: userId, date: widget.date),
                  ),
                );
              }
            }
            else if(state.status == SearchSportStatus.addNewSportSelected){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => AddSportBloc(),
                      child: const AddSportScreen(),
                    );
                  },
                ),
              );
            }
          },
            listenWhen: (context,state){
              return (state.status == SearchSportStatus.selected || state.status == SearchSportStatus.addNewSportSelected );
            },
          )];
      },
    );

  }
}
