import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/extension/context_extension.dart';
import '../../core/manager/language/locale_keys.g.dart';
import '../../product/constants/view_constants.dart';
import '../../product/widgets/cached_network_image.dart';
import '../../product/widgets/weapon_info.dart';
import '../weapons/model/weapons_response_model.dart';

class WeaponDetailView extends StatelessWidget {
  const WeaponDetailView({
    Key? key,
    required this.weapon,
  }) : super(key: key);

  final WeaponsResponseModel? weapon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        weapon?.displayName ?? "",
        style: const TextStyle(fontFamily: "Valorant"),
      )),
      body: Padding(
        padding: context.paddingHorizontalDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildWeaponCard(context),
            ),
            SizedBox(
              height: context.mediumValue,
            ),
            Expanded(
              flex: 3,
              child: _buildWeaponStats(context),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildWeaponCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: ViewConstants.borderCircular,
        color: Colors.blueGrey,
      ),
      child: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 2,
            child: Center(child: CustomCachedNetworkImage(imageUrl: weapon?.displayIcon)),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Column _buildWeaponStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "// ${LocaleKeys.weapon_details_weapon_stats.tr()}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: "Valorant"),
        ),
        SizedBox(
          height: context.mediumValue,
        ),
        WeaponInfo(
          left: LocaleKeys.weapon_details_magazine_size.tr(),
          right: weapon?.weaponStats?.magazineSize.toString() ?? "",
        ),
        const Divider(),
        WeaponInfo(
          left: LocaleKeys.weapon_details_reload_time.tr(),
          right:
              "${weapon?.weaponStats?.reloadTimeSeconds?.toStringAsFixed(2) ?? "0"} ${LocaleKeys.weapon_details_seconds.tr()}",
        ),
        const Divider(),
        WeaponInfo(
          left: LocaleKeys.weapon_details_fire_rate.tr(),
          right:
              "${weapon?.weaponStats?.fireRate?.toStringAsFixed(2) ?? "0"} / ${LocaleKeys.weapon_details_seconds.tr()}",
        ),
        const Divider(),
        SizedBox(
          height: context.mediumValue,
        ),
        (weapon?.weaponStats?.damageRanges?.length ?? 0) == 0
            ? const SizedBox.shrink()
            : Text(
                "// ${LocaleKeys.weapon_details_damage_ranges.tr()}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: "Valorant"),
              ),
        SizedBox(
          height: context.mediumValue,
        ),
        Expanded(
          child: _buildDamageRanges(),
        )
      ],
    );
  }

  ListView _buildDamageRanges() {
    return ListView.separated(
        itemBuilder: ((context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeaponInfo(
                left:
                    "${weapon?.weaponStats?.damageRanges?[index].rangeStartMeters?.toStringAsFixed(0) ?? ""} - ${weapon?.weaponStats?.damageRanges?[index].rangeEndMeters?.toStringAsFixed(0) ?? ""} ${LocaleKeys.weapon_details_meter.tr()}",
                right: "",
              ),
              const Divider(),
              WeaponInfo(
                left: LocaleKeys.weapon_details_head_damage.tr(),
                right: weapon?.weaponStats?.damageRanges?[index].headDamage?.toStringAsFixed(1) ?? "0",
              ),
              const Divider(),
              WeaponInfo(
                left: LocaleKeys.weapon_details_body_damage.tr(),
                right: weapon?.weaponStats?.damageRanges?[index].bodyDamage?.toStringAsFixed(1) ?? "0",
              ),
              const Divider(),
              WeaponInfo(
                left: LocaleKeys.weapon_details_leg_damage.tr(),
                right: weapon?.weaponStats?.damageRanges?[index].legDamage?.toStringAsFixed(1) ?? "0",
              ),
              const Divider(),
            ],
          );
        }),
        separatorBuilder: (context, index) {
          return SizedBox(height: context.mediumValue);
        },
        itemCount: weapon?.weaponStats?.damageRanges?.length ?? 0);
  }
}
