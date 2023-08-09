import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

/// Widget for tracking wireframe
class SmartlookRecordingWidget extends StatelessWidget {
  const SmartlookRecordingWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: SmartlookHelperController.instance.containerKey,
      child: Container(child: child),
    );
  }
}

/// Used to identify [Widget] or mark as [sensitive]
class SmartlookTrackingWidget extends StatelessWidget {
  final Widget child;
  final bool isSensitive;

  ///with [doNotRecordWireframe] the wireframe for this element wont be rendered
  ///the element will be marked as sensitive by design because
  ///some sensitive data could be leaked without wireframe
  final bool doNotRecordWireframe;

  const SmartlookTrackingWidget({
    required this.child,
    this.isSensitive = false,
    this.doNotRecordWireframe = false,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
