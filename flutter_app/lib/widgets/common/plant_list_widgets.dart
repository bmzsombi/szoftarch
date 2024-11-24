import 'package:flutter/material.dart';
import 'package:flutter_app/utils/plant.dart';
import 'package:flutter_app/widgets/common/plant_details.dart';

class PlantListView extends StatelessWidget {
  const PlantListView({
    super.key,
    required this.plants,
    required this.padding,
    required this.fontSize,
    this.crossAxisCount = 4, // Default to 2 columns
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.borderRadius = 8.0, // Default border radius for rounded squares
    this.backgroundColor = Colors.lightGreen, // Default background color for buttons
  });

  final List<Plant> plants;
  final double padding;
  final double fontSize;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double borderRadius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return PlantButton(
            plantScName: plants[index].scname,
            fontSize: fontSize,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}

class PlantButton extends StatelessWidget {
  const PlantButton({
    super.key,
    required this.plantScName,
    required this.fontSize,
    this.backgroundColor = Colors.blueAccent, // Default background color
    this.borderRadius = 8.0, // Default border radius for rounded squares
  });

  final String plantScName;
  final double fontSize;
  final Color backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        padding: EdgeInsets.zero, // Remove default padding for custom sizing
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetails(plantScName: plantScName),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: PlantButtonText(
          text: plantScName,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class PlantButtonText extends StatelessWidget {
  const PlantButtonText({
    super.key,
    required this.text,
    required this.fontSize
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }
}

List<Plant> searchPlants(String term, List<Plant> allPlants) {

  if (term.isEmpty) {
    return allPlants;
  } 

  List<Plant> searchedPlants = [];
  for (Plant d in allPlants) {
    if (d.cname.contains(term)) {
      searchedPlants.add(d);
    }
  }
  return searchedPlants;
}