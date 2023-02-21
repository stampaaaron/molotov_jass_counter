String? Function(String? value) notEmptyValidator = (value) =>
    value == null || value.isEmpty ? 'Feld darf nicht leer sein.' : null;
