import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final bool isSuccess;
  final String? errorMesage;
  final int? statusCode;
  final dynamic data;

  const Failure({
    required this.isSuccess,
    this.errorMesage,
    this.statusCode,
    this.data,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [isSuccess, errorMesage, statusCode];
}

// external error
class ApiFailure extends Failure {
  const ApiFailure({
    super.isSuccess = false,
    super.errorMesage = "Something went wrong. Please try again later.",
    super.data,
  });
}

/*
{
	"membershipId": null,
	"rewardsBalance": 0,
	"statusPoints": 0,
	"firstName": null,
	"lastName": null,
	"validUntil": null,
	"mobileNumber": null,
	"emailAddress": null,
	"dateOfBirth": null,
	"error": true,
	"errorMessage": "No connection could be made because the target machine actively refused it. (10.40.21.32:42527)"
}

handler
 if (ressult.error && ressult.errorMessage != null) {
          if (ressult.errorMessage!.contains("10.") || ressult.errorMessage!.contains("/")) {
            return Left(ApiFailure(errorMesage: errorMesage2));
          }
        }
 */
