class ValueResult<T> {
  final T? _value;
  final String? _error;
  final String? _title;

  const ValueResult._(this._value, this._error, this._title);

  factory ValueResult.success(T value) {
    return ValueResult._(value, null, null);
  }

  factory ValueResult.failure(String error, {String? title}) {
    return ValueResult._(null, error, title);
  }

  T? get value {
    if (isError) {
      throw StateError(
          'Cannot access value when result is an error. Error: $_error');
    }
    return _value as T;
  }

  String get error {
    if (isSuccess) {
      throw StateError('Cannot access error when result is a success.');
    }
    return _error!;
  }

  String? get title => _title;

  bool get isSuccess => _error == null;
  bool get isError => _error != null;

  static ValueResult<S> fromError<S>(dynamic exceptionOrError) {
    String? title;
    String errorMessage = "Ocorreu um erro desconhecido.";

    try {
      final data = exceptionOrError?.response?.data;
      final error = data?['error'];
      if (error is Map) {
        title = error['title'] ?? data?['title'];
        errorMessage = error['message'] ?? data?['message'] ?? errorMessage;
      } else if (error is String) {
        errorMessage = error;
      } else if (data is Map) {
        if (data['message'] is String) {
          title = data['title'] as String?;
          errorMessage = data['message'] as String;
        } else if (data['detail'] is String) {
          errorMessage = data['detail'] as String;
        } else if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
          final first = (data['detail'] as List).first;
          errorMessage = first is String ? first : first.toString();
        }
      }
      if (errorMessage == "Ocorreu um erro desconhecido." &&
          (exceptionOrError is Exception || exceptionOrError is Error)) {
        errorMessage = exceptionOrError.toString();
      } else if (errorMessage == "Ocorreu um erro desconhecido." &&
          exceptionOrError?.message != null) {
        errorMessage = exceptionOrError.message.toString();
      }
    } catch (_) {
      if (exceptionOrError != null) {
        errorMessage = exceptionOrError.toString();
      }
    }

    return ValueResult<S>.failure(errorMessage, title: title);
  }

  R fold<R>(
    R Function(T value) onSuccess,
    R Function(String error) onFailure,
  ) {
    if (isSuccess) {
      return onSuccess(_value as T);
    } else {
      return onFailure(_error!);
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'ValueResult.success(value: $_value)';
    } else {
      return 'ValueResult.failure(title: $_title, error: $_error)';
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ValueResult<T> &&
            other._value == _value &&
            other._error == _error &&
            other._title == _title;
  }

  @override
  int get hashCode => _value.hashCode ^ _error.hashCode ^ _title.hashCode;
}
