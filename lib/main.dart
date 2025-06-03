
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/routing/routing.dart' as app_routing;
import 'package:gradprj/core/services/api_service.dart';
import 'package:gradprj/cubit/transcription_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TranscriptionCubit>(
            create: (_) => TranscriptionCubit(AudioService())),
        // أضف Cubits أخرى إن وجدت
      ],
      child: GraduationProject(
        routing: app_routing.Routing(),
      ),
    ),
  );
}

class GraduationProject extends StatelessWidget {
  final app_routing.Routing routing;
  const GraduationProject({super.key, required this.routing});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.home,
          onGenerateRoute: routing.generateRoute,
        );
      },
    );
  }
}
