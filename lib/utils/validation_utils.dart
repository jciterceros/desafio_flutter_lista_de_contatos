class ValidationUtils {
  // Validar nome
  static String? validateNome(String? nome) {
    if (nome == null || nome.trim().isEmpty) {
      return 'Digite um nome antes de continuar!';
    }

    if (nome.trim().length < 2) {
      return 'Digite um nome válido antes de continuar!';
    }

    // Verificar se contém apenas letras, espaços e acentos
    final nomeRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!nomeRegex.hasMatch(nome.trim())) {
      return 'Digite um nome válido (apenas letras)';
    }

    return null;
  }

  // Validar telefone
  static String? validateTelefone(String? telefone) {
    if (telefone == null || telefone.trim().isEmpty) {
      return null; // Telefone é opcional
    }

    // Remover caracteres especiais
    final cleanTelefone = telefone.replaceAll(RegExp(r'[^\d]'), '');

    // Verificar se tem pelo menos 10 dígitos (DDD + número)
    if (cleanTelefone.length < 10) {
      return 'Digite um telefone válido';
    }

    // Verificar se tem no máximo 11 dígitos (com 9)
    if (cleanTelefone.length > 11) {
      return 'Digite um telefone válido';
    }

    return null;
  }

  // Validar dia de nascimento
  static String? validateDiaNascimento(String? dia) {
    if (dia == null || dia.trim().isEmpty) {
      return null; // Dia é opcional
    }

    final diaInt = int.tryParse(dia);
    if (diaInt == null) {
      return 'Digite um número válido para o dia';
    }

    if (diaInt < 1 || diaInt > 31) {
      return 'Digite um dia válido (1-31)';
    }

    return null;
  }

  // Validar mês de nascimento
  static String? validateMesNascimento(String? mes) {
    if (mes == null || mes.trim().isEmpty) {
      return null; // Mês é opcional
    }

    final mesInt = int.tryParse(mes);
    if (mesInt == null) {
      return 'Digite um número válido para o mês';
    }

    if (mesInt < 1 || mesInt > 12) {
      return 'Digite um mês válido (1-12)';
    }

    return null;
  }

  // Validar data de nascimento completa
  static String? validateDataNascimento(int? dia, int? mes) {
    if (dia == null || mes == null) {
      return null; // Data é opcional
    }

    // Verificar se a data é válida
    try {
      DateTime(DateTime.now().year, mes, dia);
    } catch (e) {
      return 'Data de nascimento inválida';
    }

    return null;
  }

  // Formatar telefone para exibição
  static String formatTelefone(String telefone) {
    final cleanTelefone = telefone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanTelefone.length == 11) {
      // (11) 99999-9999
      return '(${cleanTelefone.substring(0, 2)}) ${cleanTelefone.substring(2, 7)}-${cleanTelefone.substring(7)}';
    } else if (cleanTelefone.length == 10) {
      // (11) 9999-9999
      return '(${cleanTelefone.substring(0, 2)}) ${cleanTelefone.substring(2, 6)}-${cleanTelefone.substring(6)}';
    }

    return telefone;
  }

  // Formatar telefone para WhatsApp
  static String formatTelefoneWhatsApp(String telefone) {
    final cleanTelefone = telefone.replaceAll(RegExp(r'[^\d]'), '');

    // Adicionar código do país se não tiver
    if (cleanTelefone.startsWith('0')) {
      return '55${cleanTelefone.substring(1)}';
    }

    return cleanTelefone;
  }

  // Obter nome do mês
  static String getNomeMes(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    if (mes >= 1 && mes <= 12) {
      return meses[mes - 1];
    }

    return '';
  }

  // Verificar se é aniversário hoje
  static bool isAniversarioHoje(int? dia, int? mes) {
    if (dia == null || mes == null) return false;

    final now = DateTime.now();
    return dia == now.day && mes == now.month;
  }

  // Calcular idade
  static int calcularIdade(int? dia, int? mes, int? ano) {
    if (dia == null || mes == null || ano == null) return 0;

    final now = DateTime.now();
    final nascimento = DateTime(ano, mes, dia);

    int idade = now.year - nascimento.year;

    // Ajustar se ainda não fez aniversário este ano
    if (now.month < nascimento.month ||
        (now.month == nascimento.month && now.day < nascimento.day)) {
      idade--;
    }

    return idade;
  }
}
