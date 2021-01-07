import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HelloWorldPage extends StatefulWidget {
  @override
  _HelloWorldPagState createState() => _HelloWorldPagState();
}

class _HelloWorldPagState extends State<HelloWorldPage> {
  ARKitController arkitController;

  vector.Vector3 a1Position = vector.Vector3(-0.1, 0.6, -1.5);
  vector.Vector3 a2Position = vector.Vector3(-0.1, 0.6, -1.5);

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('ARKit in Flutter'),
      ),
      body: Container(
        child: ARKitSceneView(
            enableTapRecognizer: true, onARKitViewCreated: onARKitViewCreated),
      ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onNodeTap =
        (nodes) => onNodeTapHandler(nodes, arkitController);

    _createPlaneGrid(arkitController);
  }

  void _createPlaneGrid(ARKitController arkitController) {
    this.arkitController.add(_createPlane(vector.Vector3(0, 0, -1.5), 'a3'));
    this.arkitController.add(_createPlane(vector.Vector3(0.35, 0, -1.5), 'b3'));
    this.arkitController.add(_createPlane(vector.Vector3(0.7, 0, -1.5), 'c3'));

    this.arkitController.add(_createPlane(vector.Vector3(0, 0.35, -1.5), 'a2'));
    this
        .arkitController
        .add(_createPlane(vector.Vector3(0.35, 0.35, -1.5), 'b2'));
    this
        .arkitController
        .add(_createPlane(vector.Vector3(0.7, 0.35, -1.5), 'c2'));

    this.arkitController.add(_createPlane(vector.Vector3(0, 0.7, -1.5), 'a1'));
    this
        .arkitController
        .add(_createPlane(vector.Vector3(0.35, 0.7, -1.5), 'b1'));
    this
        .arkitController
        .add(_createPlane(vector.Vector3(0.7, 0.7, -1.5), 'c1'));
  }

  ARKitNode _createPlane(vector.Vector3 position, String id) {
    final plane = ARKitPlane(
      width: 0.3,
      height: 0.3,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty(color: Colors.white),
        )
      ],
    );
    return ARKitNode(
      name: id,
      geometry: plane,
      position: position, //vector.Vector3(0, 0, -1.5)
    );
  }

  ARKitNode _createText(String letter, vector.Vector3 position) {
    final text = ARKitText(
      text: letter,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty(color: Colors.blue),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: position,
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
  }

  void onNodeTapHandler(
      List<String> nodesList, ARKitController arkitController) {
    final name = nodesList.first;
    this.arkitController.add(_createText('X', a1Position)); //x, y, z

    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('You tapped on $name')),
    );
  }
}
