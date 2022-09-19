class Currency {
  String? from;
  String? to;
  double? rate;

  Currency(this.from, this.to, this.rate);
}

abstract class Mapper {
  Currency convert();
}