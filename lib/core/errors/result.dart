import 'package:juniorflutterroadmap/core/services/network/failure.dart';

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Error<T> extends Result<T> {
  final Failure error;
  const Error(this.error);
}

Future<Result<T>> runCatching<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } on Failure catch (customFailure) {
    return Error(customFailure);
  } catch (unexpectedError) {
    return Error(
      Failure("A system error occurred: ${unexpectedError.toString()}"),
    );
  }
}

extension FutureResult<T> on Future<T> {
  Future<Result<T>> toResult() => runCatching(() => this);
}
