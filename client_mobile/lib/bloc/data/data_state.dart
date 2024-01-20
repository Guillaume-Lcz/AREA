part of 'data_bloc.dart';

class DataState extends Equatable {
  const DataState({
    required this.userData,
    this.isLoading = false,
    this.isDisconnect = false,
    this.userDataList = const <UserData>[],
  });

  final UserData userData;
  final bool isLoading;
  final bool isDisconnect;
  final List<UserData> userDataList;

  DataState copyWith({
    UserData? userData,
    bool? isLoading,
    bool? isDisconnect,
    List<UserData>? userDataList,
  }) {
    return DataState(
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      isDisconnect: isDisconnect ?? this.isDisconnect,
      userDataList: userDataList ?? this.userDataList,
    );
  }

  @override
  List<Object> get props => [userData, isLoading, isDisconnect, userDataList];
}
