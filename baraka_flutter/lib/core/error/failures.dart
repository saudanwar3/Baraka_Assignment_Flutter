
import 'package:equatable/equatable.dart';

// --- Base Failure Class ---
// This is the abstract class that all specific failure types will extend.
// It uses Equatable to ensure that two failures of the same type and properties are equal.
abstract class Failure extends Equatable {
  // Optional property to carry specific error data (e.g., error codes, messages)
  const Failure([this.properties = const <dynamic>[]]);
  final List<dynamic> properties;

  @override
  List<Object?> get props => [properties];
}

// --- Specific Failure Types (Data Layer Errors) ---

// Server Failure: Used when communicating with a remote data source (API/dummyjson).
// This is typically thrown by the Remote Data Source when it receives an error
// (e.g., 404, 500, network connection loss, or JSON parsing error).
class ServerFailure extends Failure {
  const ServerFailure([super.properties]);
}

// Cache Failure: Used when reading from or writing to a local cache/database fails.
class CacheFailure extends Failure {
  const CacheFailure([super.properties]);
}

// --- Specific Failure Types (Optional/Domain Errors) ---

// Invalid Input Failure: Used for business logic errors where input data is invalid.
class InvalidInputFailure extends Failure {
  const InvalidInputFailure([super.properties]);
}