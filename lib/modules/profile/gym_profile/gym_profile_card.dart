import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/components/cards/card.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/selectors/equipment_selector.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';

class GymProfileCard extends StatelessWidget {
  final GymProfile gymProfile;
  const GymProfileCard({Key? key, required this.gymProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          MyText(
            gymProfile.name,
            weight: FontWeight.bold,
            lineHeight: 1.5,
          ),
          if (gymProfile.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: MyText(
                gymProfile.description!,
                textAlign: TextAlign.center,
                maxLines: 3,
                lineHeight: 1.5,
                size: FONTSIZE.two,
              ),
            ),
          if (gymProfile.equipments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SizedBox(
                height: 70,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: gymProfile.equipments.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 70,
                            child: EquipmentTile(
                              equipment: gymProfile.equipments[index],
                              fontSize: FONTSIZE.one,
                              iconSize: 26,
                              withBorder: false,
                            ),
                          ),
                        )),
              ),
            ),
        ],
      ),
    );
  }
}
