
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateContractPageBloc extends Bloc<CreateContractPageEvent, CreateContractPageState> {
  final BuildContext context;
  CreateContractPageBloc(this.context) : super(CreateContractPageState()) {
    on<CreateContractEvent>(onCreateContract);
    on<JoinContractEvent>(onJoinContract);
  }

  Future<void> onCreateContract(CreateContractEvent event, Emitter<CreateContractPageState> emit) async {
  }

  Future<void> onJoinContract(JoinContractEvent event, Emitter<CreateContractPageState> emit) async {
  }

}

sealed class CreateContractPageEvent {}

class CreateContractEvent extends CreateContractPageEvent {}

class JoinContractEvent extends CreateContractPageEvent {}

class CreateContractPageState extends Equatable {
  @override
  List<Object?> get props => [];
}