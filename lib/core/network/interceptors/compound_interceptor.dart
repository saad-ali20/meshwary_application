import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../features/home/presentation/cubit/compound_cubit.dart';

/// Interceptor that appends the currently selected compoundId to every request
/// (except the profile endpoint). This guarantees that all APIs receive the
/// same compound context.
class CompoundInterceptor extends Interceptor {
  CompoundInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Do not add compoundId for the profile request (it returns the default).
    if (options.path.contains('/api/mobile/account/profile')) {
      return handler.next(options);
    }

    // Retrieve the currently selected compound from the global Cubit.
    final cubit = GetIt.instance<CompoundCubit>();
    final compound = cubit.state.compound;
    if (compound != null) {
      // Ensure we do not overwrite an explicit compoundId already provided.
      options.queryParameters = Map<String, dynamic>.from(options.queryParameters);
      options.queryParameters['compoundId'] = compound.id;
    }
    handler.next(options);
  }
}

