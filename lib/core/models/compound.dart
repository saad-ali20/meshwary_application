import 'package:equatable/equatable.dart';

class Compound extends Equatable {
  const Compound({required this.id, required this.name});

  final String id;
  final String name;

  factory Compound.fromJson(Map<String, dynamic> json) {
    return Compound(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}

