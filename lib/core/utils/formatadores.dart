String formatarPreco(double valor) {
  return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
}

double converterDouble(Object? valor) {
  if (valor is num) return valor.toDouble();
  return double.tryParse(valor?.toString().replaceAll(',', '.') ?? '') ?? 0.0;
}

int converterInt(Object? valor) {
  if (valor is num) return valor.toInt();
  return int.tryParse(valor?.toString() ?? '') ?? 0;
}