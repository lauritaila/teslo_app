import 'package:formz/formz.dart';

// Define input validation errors
enum StockError { empty, value, format }

// Extend FormzInput and provide the input type and error type.
class Stock extends FormzInput<int, StockError> {

  // Call super.pure to represent an unmodified form input.
  const Stock.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Stock.dirty( int value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == StockError.empty ) return 'El campo es requerido';
    if ( displayError == StockError.value ) return 'El numero debe ser mayor o igual a 0';
    if ( displayError == StockError.format ) return 'El campo debe ser un número entero';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  StockError? validator(int value) {
    if ( value < 0 ) return StockError.value;
    if ( value.toString().isEmpty ) return StockError.empty;
    final isInteger = int.tryParse(value.toString()) ?? -1;
    if ( isInteger == -1 ) return StockError.format;
    return null;
  }
}