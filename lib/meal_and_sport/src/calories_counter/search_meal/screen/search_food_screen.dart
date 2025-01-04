
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/blocs/user_bloc.dart';
import '../../../user/blocs/user_state.dart';
import '../../add_meal/add_meal_screen.dart';
import '../../add_meal/blocs/add_meal_bloc.dart';
import '../../add_user_meal/screen/food_details_page.dart';
import '../blocs/search_meal_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.mealType});
  final String mealType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: DebouncedSearchBar(mealType: mealType),
      ),
    );
  }
}

class DebouncedSearchBar extends StatefulWidget {

  const DebouncedSearchBar({super.key, required this.mealType});
  final String mealType;

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
          hintText: "Search for a food",
          onTap: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        final model = BlocProvider.of<SearchFoodBloc>(context);
        model.add(SearchQueryChanged(query: controller.text));
        return [
          BlocConsumer<SearchFoodBloc, SearchFoodState>(
            builder: (context, state) {
              if (state.status == SearchFoodStatus.foodsLoaded && state.foods != null) {
                if (state.foods!.isEmpty) {
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
                        label: const Text('Add New Meal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          final model = BlocProvider.of<SearchFoodBloc>(context);
                          model.add(AddNewMealBtnSelected());

                        },
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true, // Ensures the ListView takes only necessary space
                    children: state.foods!.map((result) {
                      return ListTile(
                        title: Text(result.name),
                        trailing: Text(
                          result.energyPer100g != null
                              ? "${result.energyPer100g?.toStringAsFixed(2)} kcal"
                              : "",
                          style: const TextStyle(fontSize: 15),
                        ),
                        onTap: () async {
                          model.add(FoodSelected(id: result.id!));
                        },
                      );
                    }).toList(),
                  ),
                );
              } else if (state.status == SearchFoodStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container();
            },
            listener: (context, state) {
              if(state.status == SearchFoodStatus.selected && state.selectedFood != null){
                final userState = BlocProvider.of<UserBloc>(context).state;
                int userId;
                if (userState is LoginSuccess) {
                  userId = userState.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailsPage(
                        meal: state.selectedFood!,
                        mealType: widget.mealType,
                        userId: userId,
                      ),
                    ),
                  );
                }
              }
              else if(state.status == SearchFoodStatus.addNewMealSelected){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                          create: (context) => AddMealBloc(),
                          child: const AddMealScreen());
                    },
                  ),
                );
              }

            },
            listenWhen: (context, state) {
              return (state.status == SearchFoodStatus.selected || state.status == SearchFoodStatus.addNewMealSelected);
            },
          ),
        ];
      },
    );
  }
}
