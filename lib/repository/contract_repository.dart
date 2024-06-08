
import 'package:dio/dio.dart';
import 'package:my_home_stair/dto/response/common/page_response.dart';
import 'package:retrofit/http.dart';

import '../dto/response/contract/contract_response.dart';

part 'contract_repository.g.dart';

@RestApi(baseUrl: '/v1/contract')
abstract class ContractRepository {
  factory ContractRepository(Dio dio, {String baseUrl}) = _ContractRepository;

  @GET('')
  Future<PageResponse<ContractResponse>> getContracts(@Query('page') int page, @Query('size') int size);
}