
import 'package:dio/dio.dart';
import 'package:my_home_stair/dto/request/contract/contract_request.dart';
import 'package:my_home_stair/dto/request/contract/join_contract_request.dart';
import 'package:my_home_stair/dto/response/common/page_response.dart';
import 'package:retrofit/http.dart';

import '../dto/response/contract/contract_response.dart';

part 'contract_repository.g.dart';

@RestApi(baseUrl: '/v1/contract')
abstract class ContractRepository {
  factory ContractRepository(Dio dio, {String baseUrl}) = _ContractRepository;

  @GET('')
  Future<PageResponse<ContractResponse>> getContracts(@Header('Authorization') String authorization, @Query('page') int page, @Query('size') int size);

  @POST('')
  Future<void> createContract(@Header('Authorization') String authorization, @Body() ContractRequest contractRequest);

  @POST('join')
  Future<void> joinContract(@Header('Authorization') String authorization, @Body() JoinContractRequest joinContractRequest);
}