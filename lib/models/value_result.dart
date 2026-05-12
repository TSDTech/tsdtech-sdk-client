/// A result type that represents either a success value or a failure error.
///
/// Use [ValueResult.success] to create a successful result containing a value.
/// Use [ValueResult.failure] to create a failed result containing an error message.
///
/// ## Example
/// ```dart
/// final result = await someAsyncOperation();
/// return result.fold(
///   (value) => handleSuccess(value),
///   (error) => handleError(error),
/// );
/// ```
///
/// ## Usage with Dart's pattern matching
/// ```dart
/// final result = await fetchUser();
/// if (result.isSuccess) {
///   print('User: ${result.value}');
/// } else {
///   print('Error: ${result.error}');
/// }
/// ```
///
/// Type parameter `T` is the type of the success value.
class ValueResult<T> {
  final T? _value;
  final String? _error;
  final String? _title;

  const ValueResult._(this._value, this._error, this._title);

  /// Creates a successful result containing the given [value].
  ///
  /// - [value]: The success value of type `T`
  /// - Returns: A [ValueResult] representing success
  factory ValueResult.success(T value) {
    return ValueResult._(value, null, null);
  }

  /// Creates a failed result containing an error message.
  ///
  /// - [error]: The error message describing what went wrong
  /// - [title]: Optional title for the error (e.g., for display purposes)
  /// - Returns: A [ValueResult] representing failure
  factory ValueResult.failure(String error, {String? title}) {
    return ValueResult._(null, error, title);
  }

  /// Returns the success value.
  ///
  /// - Throws [StateError] if this result is an error
  /// - Use [isSuccess] or [isError] to check the state before accessing
  T? get value {
    if (isError) {
      throw StateError(
          'Cannot access value when result is an error. Error: $_error');
    }
    return _value as T;
  }

  /// Returns the error message.
  ///
  /// - Throws [StateError] if this result is a success
  /// - Use [isSuccess] or [isError] to check the state before accessing
  String get error {
    if (isSuccess) {
      throw StateError('Cannot access error when result is a success.');
    }
    return _error!;
  }

  /// Returns the optional error title.
  ///
  /// May be null even in error states if no title was provided.
  String? get title => _title;

  /// Returns true if this result represents a success with a value.
  bool get isSuccess => _error == null;

  /// Returns true if this result represents a failure with an error.
  bool get isError => _error != null;

  /// Creates a failure result from a [DioException] or any exception object.
  ///
  /// Extracts error message from response body following TsdTech API conventions:
  /// - Checks `error.message` or `error.title`
  /// - Falls back to `data['message']` or `data['detail']`
  /// - Handles list responses by taking first element
  /// - Falls back to exception.toString() as last resort
  ///
  /// - [exceptionOrError]: The exception or error object to convert
  /// - Returns: A [ValueResult] with extracted error message
  static ValueResult<S> fromError<S>(dynamic exceptionOrError) {
    String? title;
    String errorMessage = 'Ocorreu um erro desconhecido.';

    try {
      final data = exceptionOrError?.response?.data;
      final error = data?['error'];
      if (error is Map) {
        final Map<String, dynamic> errorMap = error as Map<String, dynamic>;
        final Map<String, dynamic>? dataMap = data as Map<String, dynamic>?;
        final String? titleValue =
            errorMap['title'] as String? ?? dataMap?['title'] as String?;
        title = titleValue;
        final String errorMsg = (errorMap['message'] ??
            dataMap?['message'] ??
            errorMessage) as String;
        errorMessage = errorMsg;
      } else if (error is String) {
        errorMessage = error;
      } else if (data is Map) {
        if (data['message'] is String) {
          title = data['title'] as String?;
          errorMessage = data['message'] as String;
        } else if (data['detail'] is String) {
          errorMessage = data['detail'] as String;
        } else if (data['detail'] is List &&
            (data['detail'] as List).isNotEmpty) {
          final first = (data['detail'] as List).first;
          errorMessage = first is String ? first : first.toString();
        }
      }
      if (errorMessage == 'Ocorreu um erro desconhecido.' &&
          (exceptionOrError is Exception || exceptionOrError is Error)) {
        errorMessage = exceptionOrError.toString();
      } else if (errorMessage == 'Ocorreu um erro desconhecido.' &&
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

  /// Transforms the result based on its state using pattern matching.
  ///
  /// - [onSuccess]: Function to call with the value if this is a success
  /// - [onFailure]: Function to call with the error message if this is a failure
  /// - Returns: The result of whichever function was called
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
