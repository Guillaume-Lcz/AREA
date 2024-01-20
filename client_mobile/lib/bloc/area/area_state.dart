part of 'area_bloc.dart';

class AreaState extends Equatable {
  const AreaState({
    required this.areaList,
    this.area = const [],
  });

  final List<List<AreaModel>>? areaList;
  final List<AreaModel>? area;

  AreaState copyWith({
    List<List<AreaModel>>? areaList,
    List<AreaModel>? area,
  }) {
    return AreaState(
      areaList: areaList ?? this.areaList,
      area: area ?? this.area,
    );
  }

  @override
  List<Object?> get props => [areaList, area];
}
