import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_state.dart';

import '../model/user.dart';
import '../repo/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository = UserRepository();

  UserBloc() : super(const UserState()) {
    on<LoginSuccessEvent>(_setUserInfo);
    on<UpdateProfileEvent>(_updateProfile);
    on<UploadProfileImageEvent>(_updateProfileImage);
    on<LoadUserProfileEvent>(_loadUserProfile);
    on<UploadFileEvent>(_uploadFile);
  }
  Future<void> _setUserInfo(
      LoginSuccessEvent event,
      Emitter<UserState> emit,
      ) async {
    User user = await userRepository.fetchUser(event.userId);
    emit(state.copyWith(userId : event.userId, name: user.name,token: event.token, isFirstLogin: event.isFirstLogin,status: UserStatus.userInfoLoaded, user: user));

  }

  Future<void> _updateProfileImage (
      UploadProfileImageEvent event,
      Emitter<UserState> emit
      )async{
      await userRepository.uploadProfileImage(event.file,event.userId);
      add(LoadUserProfileEvent(event.userId));
  }


  Future<void> _loadUserProfile(
      LoadUserProfileEvent event,
      Emitter<UserState> emit,
      ) async {
    User user = await userRepository.fetchUser(event.userId);
    emit(state.copyWith(
      status: UserStatus.userInfoLoaded,
       user: user
    ));
  }

  Future<void> _updateProfile(
      UpdateProfileEvent event,
      Emitter<UserState> emit,
      ) async {
    await userRepository.updateProfile(event.userId,event.updatedData);
    add(LoadUserProfileEvent(event.userId));
    // emit(state.copyWith(status: UserStatus.loading));
  }

  Future<void> _uploadFile (
      UploadFileEvent event,
      Emitter<UserState> emit
      )async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        // allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        emit(state.copyWith(status: UserStatus.fileUploaded, file: file));
      } else {
        emit(state.copyWith(status: UserStatus.failure));
      }
    }catch(e){
      emit(state.copyWith(status: UserStatus.failure));
    }
  }



  // Future<void> _onLoginSubmitted(
  //     LoginSubmitted event,
  //     Emitter<UserState> emit,
  //     ) async {
  //   int id = 1;
  //   emit(LoginSuccess(userId: 1));
    // emit(LoginLoading());
    // try {
      // final isSuccess = await userRepository.login(
      //   email: event.email,
      //   password: event.password,
      // );
    //
    //   if (isSuccess) {
    //     emit(LoginSuccess());
    //   } else {
    //     emit(LoginFailure(error: "Invalid email or password"));
    //   }
    // } catch (e) {
    //   emit(LoginFailure(error: e.toString()));
    // }
  // }

  // void _onLoginReset(LoginReset event, Emitter<UserState> emit) {
  //   emit(LoginInitial());
  // }

}
