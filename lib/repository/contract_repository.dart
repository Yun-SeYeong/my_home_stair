import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_home_stair/dto/request/contract/contract_history_input_text_request.dart';
import 'package:my_home_stair/dto/request/contract/contract_request.dart';
import 'package:my_home_stair/dto/request/contract/create_file_upload_history_request.dart';
import 'package:my_home_stair/dto/request/contract/create_special_contract_request.dart';
import 'package:my_home_stair/dto/request/contract/join_contract_request.dart';
import 'package:my_home_stair/dto/response/common/page_response.dart';
import 'package:my_home_stair/dto/response/contract/contract_detail_response.dart';
import 'package:my_home_stair/presentation/contract/contract_detail/contract_detail_page_bloc.dart';
import 'package:retrofit/http.dart';

import '../dto/response/contract/contract_response.dart';

part 'contract_repository.g.dart';

@RestApi(baseUrl: '/v1/contract')
abstract class ContractRepository {
  factory ContractRepository(Dio dio, {String baseUrl}) = _ContractRepository;

  @GET('')
  Future<PageResponse<ContractResponse>> getContracts(
    @Header('Authorization') String authorization,
    @Query('page') int page,
    @Query('size') int size,
  );

  @GET('/{id}')
  Future<ContractDetailResponse> getContract(
    @Header('Authorization') String authorization,
    @Path('id') String id,
  );

  @POST('')
  Future<void> createContract(
    @Header('Authorization') String authorization,
    @Body() ContractRequest contractRequest,
  );

  @POST('/join')
  Future<void> joinContract(
    @Header('Authorization') String authorization,
    @Body() JoinContractRequest joinContractRequest,
  );

  @POST('/{contractId}/history/{historyId}/check')
  Future<void> contractHistoryCheck(
    @Header('Authorization') String authorization,
    @Path('contractId') String contractId,
    @Path('historyId') String historyId,
  );

  @POST('/{contractId}/history/{historyId}/inputText')
  Future<void> contractHistoryInputText(
    @Header('Authorization') String authorization,
    @Path('contractId') String contractId,
    @Path('historyId') String historyId,
    @Body() ContractHistoryInputTextRequest contractHistoryInputTextRequest,
  );

  @POST('/{contractId}/history/{historyId}/uploadFile')
  Future<void> contractHistoryUploadFile(
    @Header('Authorization') String authorization,
    @Path('contractId') String contractId,
    @Path('historyId') String historyId,
    @MultiPart() @Part() File file,
  );

  @POST('/createFileUploadHistory')
  Future<void> createFileUploadHistory(
    @Header('Authorization') String authorization,
    @Body() CreateFileUploadHistoryRequest createFileUploadHistoryRequest,
  );

  @POST('/createSpecialContract')
  Future<void> createSpecialContract(
    @Header('Authorization') String authorization,
    @Body() CreateSpecialContractRequest createSpecialContractRequest,
  );
}
