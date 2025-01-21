import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/add_sport_bloc.dart';

class SportTypeScreen extends StatelessWidget {
  const SportTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: fetch sport type
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF599BF9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Sport Type', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: const AlphabetListScrollView(),
      // items:[])
    );
  }
}

class AlphabetListScrollView extends StatefulWidget{

  const AlphabetListScrollView({super.key});

  @override
  State<AlphabetListScrollView> createState() => _AlphabetListScrollViewState();
}

class _AlphabetListScrollViewState extends State<AlphabetListScrollView> {
  @override
  Widget build(BuildContext context) {

    List<ISuspensionBean> items = context.read<AddSportBloc>().state.sportTypeList!;

    return AzListView(
        data:items,
        indexBarMargin: const EdgeInsets.all(10),
        indexHintBuilder: (context,tag){
          return Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            color: Colors.blue,
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
          );
        },
        itemCount: items.length,
        itemBuilder: (context,index){
          final ISuspensionBean item = items[index];
          final sportItem = item as SportTypeList;

          return ListTile(
            title: Text(sportItem.title),
            onTap: () {
              context.read<AddSportBloc>().add(SportTypeSelected( sportType: sportItem.title));
              Navigator.of(context).pop();
            },
          );
        },
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          indexHintAlignment: Alignment.centerRight,
          selectTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          selectItemDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue
          )
        ),

    );

  }

}

// Widget _buildListItem(ISuspensionBean item, BuildContext context) {
//   // Cast item to SportTypeList
//   final sportItem = item as SportTypeList;
//
//   return GestureDetector(
//     onTap: () {
//       final model = context.read<AddSportBloc>();
//       model.add(SportTypeSelected(sportType: sportItem.title));
//
//     },
//     child: ListTile(
//       title: Text(sportItem.title),
//     ),
//   );
// }
