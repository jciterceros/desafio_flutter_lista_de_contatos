class Contato {
  final String? objectId;
  final String nome;
  final String? telefone;
  final int? diaNascimento;
  final int? mesNascimento;
  final String? fotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Contato({
    this.objectId,
    required this.nome,
    this.telefone,
    this.diaNascimento,
    this.mesNascimento,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      objectId: json['objectId'],
      nome: json['nome'] ?? '',
      telefone: json['telefone'],
      diaNascimento: json['diaNascimento'],
      mesNascimento: json['mesNascimento'],
      fotoUrl: json['fotoUrl'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'nome': nome,
      'telefone': telefone,
      'diaNascimento': diaNascimento,
      'mesNascimento': mesNascimento,
      'fotoUrl': fotoUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Contato copyWith({
    String? objectId,
    String? nome,
    String? telefone,
    int? diaNascimento,
    int? mesNascimento,
    String? fotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contato(
      objectId: objectId ?? this.objectId,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      diaNascimento: diaNascimento ?? this.diaNascimento,
      mesNascimento: mesNascimento ?? this.mesNascimento,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get fazAniversarioHoje {
    final now = DateTime.now();
    return diaNascimento == now.day && mesNascimento == now.month;
  }

  @override
  String toString() {
    return 'Contato(objectId: $objectId, nome: $nome, telefone: $telefone, diaNascimento: $diaNascimento, mesNascimento: $mesNascimento, fotoUrl: $fotoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contato && other.objectId == objectId;
  }

  @override
  int get hashCode => objectId.hashCode;
}
