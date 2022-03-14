import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CollageScreen extends StatefulWidget {
  const CollageScreen({Key? key, required this.imagePaths}) : super(key: key);

  final List<String> imagePaths;

  @override
  _CollageScreenState createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen> {
  static const String leftBig = "Left Big";
  static const String centerBig = "Center Big";
  static const String rightBig = "Right Big";

  String collageOption = leftBig;

  double tileSpacing = 0;

  bool spacing = false;

  @override
  void initState() {
    super.initState();
  }

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Collage'),
          actions: [
            IconButton(onPressed: onSave, icon: const Icon(Icons.save))
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(5),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: leftBig,
                          groupValue: collageOption,
                          onChanged: (String? value) {
                            setState(() {
                              collageOption = value!;
                            });
                          }),
                      const Text(
                        leftBig,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: centerBig,
                          groupValue: collageOption,
                          onChanged: (String? value) {
                            setState(() {
                              collageOption = value!;
                            });
                          }),
                      const Text(
                        centerBig,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: rightBig,
                          groupValue: collageOption,
                          onChanged: (String? value) {
                            setState(() {
                              collageOption = value!;
                            });
                          }),
                      const Text(
                        rightBig,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: spacing,
                      onChanged: (val) {
                        setState(() {
                          spacing = val!;
                          tileSpacing = val ? 4 : 0;
                        });
                      }),
                  const Text(
                    "Add Spacing",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              Screenshot(
                controller: _screenshotController,
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  itemCount: widget.imagePaths.length,
                  crossAxisCount: getCrossAxisCount(),
                  itemBuilder: (BuildContext context, int index) => Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(
                      getCellCount(true, index),
                      getCellCount(false, index).toDouble()),
                  mainAxisSpacing: tileSpacing,
                  crossAxisSpacing: tileSpacing,
                ),
              )
            ])));
  }

  int getCrossAxisCount() {
    return 3;
  }

  int getCellCount(bool isCrossAxis, int index) {
    if (isCrossAxis) {
      return 1;
    } else {
      if (collageOption == leftBig) {
        return (index == 0) ? 2 : 1;
      } else if (collageOption == centerBig) {
        return (index == 1) ? 2 : 1;
      } else if (collageOption == rightBig) {
        return (index == 2) ? 2 : 1;
      }
    }
    return 1;
  }

  void onSave() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }

    if (isGranted) {
      String directory = (await getExternalStorageDirectory())!.path;
      String fileName =
          DateTime.now().microsecondsSinceEpoch.toString() + ".png";
      _screenshotController.captureAndSave(directory, fileName: fileName);
    }
  }
}
