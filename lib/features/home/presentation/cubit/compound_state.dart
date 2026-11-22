part of 'compound_cubit.dart';

enum CompoundStatus { initial, loading, selected, needsSelection, error }

class CompoundState extends Equatable {
  const CompoundState({
    required this.status,
    this.compound,
    this.errorMessage,
  });

  const CompoundState.initial()
      : status = CompoundStatus.initial,
        compound = null,
        errorMessage = null;

  const CompoundState.loading()
      : status = CompoundStatus.loading,
        compound = null,
        errorMessage = null;

  const CompoundState.selected(this.compound)
      : status = CompoundStatus.selected,
        errorMessage = null;

  const CompoundState.needsSelection({Compound? current})
      : status = CompoundStatus.needsSelection,
        compound = current,
        errorMessage = null;

  const CompoundState.error(String message)
      : status = CompoundStatus.error,
        compound = null,
        errorMessage = message;

  final CompoundStatus status;
  final Compound? compound;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, compound, errorMessage];
}
