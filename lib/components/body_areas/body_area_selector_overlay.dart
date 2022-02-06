import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:sofie_ui/components/indicators.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/constants.dart';
import 'package:sofie_ui/generated/api/graphql_api.dart';
import 'package:sofie_ui/services/utils.dart';
import 'package:xml/xml.dart';

/// Overlay of clickable click paths to sit on top of a graphical UI of the selected areas.
/// This widget is invisible and is for creating clickable areas based on the body area SVG paths.
class BodyAreaSelectorOverlay extends StatelessWidget {
  final BodyAreaFrontBack frontBack;
  final List<BodyArea> allBodyAreas;
  final Function(BodyArea bodyArea) onTapBodyArea;
  final double height;

  const BodyAreaSelectorOverlay(
      {Key? key,
      required this.frontBack,
      required this.onTapBodyArea,
      required this.allBodyAreas,
      required this.height})
      : super(key: key);

  Future<String> readFile(String filePath) async {
    return rootBundle.loadString(filePath);
  }

  Future<XmlDocument> readSvg(String filePath) async {
    final String _fileContent = await readFile(filePath);
    final XmlDocument _xmlRoot = XmlDocument.parse(_fileContent);
    return _xmlRoot;
  }

  List<XmlElement> _getXmlElementPoints(XmlDocument root) {
    return root.descendants
        .whereType<XmlElement>()
        .where((p) => p.getAttribute('points') != null)
        .toList();
  }

  String? _getPathStringFromPoints(XmlElement elem, bool close) {
    final String? points = elem.getAttribute('points');
    return Utils.textNotNull(points) ? 'M$points${close ? 'z' : ''}' : null;
  }

  Future<List<PathBodyAreaMap>> _parsePathsFromSvgAsset(
      BodyArea bodyArea, String assetUrl) async {
    final XmlDocument _xmlDocument = await readSvg(assetUrl);
    final List<XmlElement> _xmlElements = _getXmlElementPoints(_xmlDocument);
    final List<String?> _pathStrings =
        _xmlElements.map((e) => _getPathStringFromPoints(e, true)).toList();

    return _pathStrings
        .map((s) => PathBodyAreaMap(bodyArea, parseSvgPathData(s ?? '')))
        .toList();
  }

  Future<List<PathBodyAreaMap>> _getAllSelectablePaths(
      List<BodyArea> bodyAreas) async {
    // Each SVG will return a list of paths - one for each clickable section.
    // For example, there will be two bicep paths (right and left)
    final List<List<PathBodyAreaMap>> _pathsNested = await Future.wait(
        bodyAreas.map((bodyArea) => _parsePathsFromSvgAsset(bodyArea,
            'assets/body_areas/${frontBack == BodyAreaFrontBack.front ? "front" : "back"}/selection/select_${Utils.getSvgAssetUriFromBodyAreaName(bodyArea.name)}.svg')));

    return _pathsNested.expand((x) => x).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<BodyArea> bodyAreasToDraw = allBodyAreas
        .where((ba) =>
            ba.frontBack == frontBack || ba.frontBack == BodyAreaFrontBack.both)
        .toList();

    return FutureBuilder(
      future: _getAllSelectablePaths(bodyAreasToDraw),
      builder: (BuildContext context,
          AsyncSnapshot<List<PathBodyAreaMap>> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: height,
            width: height *
                (kBodyAreaSelectorSvgWidth / kBodyAreaSelectorSvgHeight),
            child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.topCenter,
                children: snapshot.data!
                    .map(
                      (pathBodyAreaMap) => ClipPath(
                        clipper: PathClipper(pathBodyAreaMap.path),
                        child: GestureDetector(
                          onTap: () => onTapBodyArea(pathBodyAreaMap.bodyArea),
                        ),
                      ),
                    )
                    .toList()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyText('Sorry, there was an error: ${snapshot.error}'),
          );
        } else {
          return const Center(child: LoadingIndicator());
        }
      },
    );
  }
}

class PathClipper extends CustomClipper<Path> {
  final Path path;
  PathClipper(this.path);

  @override
  Path getClip(Size size) {
    final Matrix4 _matrix4 = Matrix4.identity();
    _matrix4.scale(size.width / kBodyAreaSelectorSvgWidth,
        size.height / kBodyAreaSelectorSvgHeight);
    return path.transform(_matrix4.storage);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Simple mapping of paths to corresponding bodyAreas
/// Allowing a gesture detector to act on the correct body area when the clipped path is tapped.
class PathBodyAreaMap {
  BodyArea bodyArea;
  Path path;
  PathBodyAreaMap(this.bodyArea, this.path);
}
