// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/routes/_routes.dart';
import 'package:cinequizz/src/core/shared/widgets/app_scaffold.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/presentation/cubits/series_cubit/series_cubit.dart';
import 'package:cinequizz/src/features/app/presentation/pages/home/widgets/series_card.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged() {
    _searchController.text.trim().isNotEmpty
        ? context
            .read<SeriesCubit>()
            .getFilteredSeries(query: _searchController.text)
        : null;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Discover Series'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search series...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<SeriesCubit, SeriesState>(
                builder: (context, state) {
                  if (state.status == SeriesStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == SeriesStatus.failed) {
                    return const Center(child: Text('Failed to load series'));
                  } else if (state.filteredSeries.isEmpty) {
                    return const Center(child: Text('No series found'));
                  } else {
                    return ListView.builder(
                      itemCount: state.filteredSeries.length,
                      itemBuilder: (context, index) {
                        final serie = state.filteredSeries[index];
                        return SeriesCard(
                          onTap: () => _onSeriesCardTap(context, serie),
                          imageUrl: serie.imgUrl,
                          title: serie.name,
                          trailing: serie.info,
                          rating: double.parse(serie.rating),
                          //TODO
                          completedRatio: 0, // Not applicable in discover
                          correctNo: 0, // Not applicable in discover
                          wrongNo: 0,
                          totalQuestionNo: 0, // Not applicable in discover
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSeriesCardTap(BuildContext context, SeriesEntity series) {
    Dialogs.materialDialog(
      msg: "Are you sure? You can't undo this",
      title: series.name,
      color: AppColors.background,
      context: context,
      actionsBuilder: (BuildContext context) {
        return [
          ShadButton.outline(
            backgroundColor: Colors.transparent,
            pressedBackgroundColor: Colors.transparent,
            onPressed: () => context.pop(),
            child:
                const Text('Cancel', style: TextStyle(color: AppColors.white)),
          ),
          ShadButton(
            pressedBackgroundColor: Colors.transparent,
            onPressed: () {
              context
                ..pushNamed(
                  AppRoutes.question.name,
                  pathParameters: {'series_id': series.seriesId},
                )
                ..pop();
            },
            child: const Text('Start'),
          ),
        ];
      },
    );
  }
}
