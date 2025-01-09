part of 'greeting_bloc.dart';


abstract class GreetingState{}

class GreetingVisibleState extends GreetingState {}

class GreetingHiddenState extends GreetingState {}


// class GreetingState extends Equatable{
//   final bool? showGreeting;
//
//   const GreetingState({
//     this.showGreeting
//   });
//   @override
//   // TODO: implement props
//   List<Object?> get props => [showGreeting];
//
//   GreetingState copyWith({
//     bool? showGreeting,
//   }){
//     return GreetingState(
//       showGreeting: showGreeting ?? this.showGreeting,
//     );
//   }
// }
