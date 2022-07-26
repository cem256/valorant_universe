import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/enum/page_states.dart';
import '../../../core/extension/context_extension.dart';
import '../../../core/manager/language/locale_keys.g.dart';
import '../../../core/manager/route/app_router.gr.dart';
import '../../../product/constants/view_constants.dart';
import '../../../product/widgets/cached_network_image.dart';
import '../../../product/widgets/custom_error_widget.dart';
import '../view_model/weapons_view_model.dart';

class WeaponsView extends StatefulWidget {
  const WeaponsView({Key? key}) : super(key: key);

  @override
  State<WeaponsView> createState() => _WeaponsViewState();
}

class _WeaponsViewState extends State<WeaponsView> {
  late WeaponsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WeaponsViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.fetchAllWeapons(context.locale.toStringWithSeparator(separator: "-"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Observer(builder: (_) {
        if (_viewModel.pageState == PageStates.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (_viewModel.pageState == PageStates.loaded) {
          return Column(
            children: [
              Expanded(
                child: _weaponsGridView(context),
              )
            ],
          );
        } else {
          return const CustomErrorWidget();
        }
      }),
    );
  }

  AppBar _appbar() {
    return AppBar(
        title: Text(
      LocaleKeys.common_weapons.tr(),
      style: const TextStyle(fontFamily: "Valorant"),
    ));
  }

  GridView _weaponsGridView(BuildContext context) {
    return GridView.builder(
        padding: context.paddingHorizontalDefault,
        itemCount: _viewModel.model.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: context.mediumValue,
            crossAxisSpacing: context.mediumValue,
            childAspectRatio: 1,
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          return ClipRRect(
              borderRadius: ViewConstants.borderCircular,
              child: GestureDetector(
                onTap: () => context.router.push(WeaponDetailRoute(weapon: _viewModel.model[index])),
                child: _weaponsStackedCard(index, context),
              ));
        });
  }

  Stack _weaponsStackedCard(int index, BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.blueGrey,
        ),
        Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 2,
              child: Padding(
                padding: context.paddingHorizontalLow,
                child: CustomCachedNetworkImage(imageUrl: _viewModel.model[index]?.displayIcon),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _viewModel.model[index]?.displayName ?? "",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: "Valorant"),
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ],
    );
  }
}
