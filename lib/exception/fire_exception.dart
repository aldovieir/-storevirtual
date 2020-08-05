class FireException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'Email já Cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Tente mais tarde',
    'EMAIL_NOT_FOUND': 'Email não encontrado',
    'INVALID_PASSWORD': 'Senha errada',
    'USER_DISABLED': 'Usuário desabilitado',
  };
  final String key;
  FireException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Erro de autenticação';
    }
  }
}
