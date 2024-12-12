import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/_hom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinequizz/src/core/shared/widgets/_widgets.dart';
import 'package:cinequizz/src/core/connection_management/connectivity_cubit.dart';
import 'package:cinequizz/src/di.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/widgets/app_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    sl<SeriesCubit>()
      ..fetchAllSeries()
      ..fetchUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, connectivityState) {
        return BlocBuilder<SeriesCubit, SeriesState>(
          builder: (context, seriesState) {
            if (seriesState.series.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return AppScaffold(
              appBar: AppAppbar(
                seriesState: seriesState,
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadData();
                  },
                  child: ListView.builder(
                    cacheExtent: context.screenHeight,
                    itemCount: seriesState.series.length,
                    itemBuilder: (context, index) {
                      final series = seriesState.series[index];

                      return SeriesCardItem(
                        series: series,
                        seriesState: seriesState,
                        index: index,
                        onTap: _onSeriesCardTap,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSeriesCardTap(BuildContext context, SeriesEntity series) {
    context.showScrollableModal(
      pageBuilder: (ScrollController scrollController,
          DraggableScrollableController draggableScrollController) {
        return RulesModal(
          series: series,
        );
      },
    );
  }
}
