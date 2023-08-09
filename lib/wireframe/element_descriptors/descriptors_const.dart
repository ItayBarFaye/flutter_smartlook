import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/default_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_opacity_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_padding_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_android_view_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_colored_box_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_custom_paint_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_decorated_box_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_decoration_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_image_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_magnifier_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_paragraph_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_physical_model_descriptor.dart';

//todo maybe try default and log it ? if none found
class DescriptorsConst {
  static Map<String, DefaultElementDescriptor> get descriptorsMap => {
        "_RenderColoredBox": const RenderColoredBoxDescriptor(),
        "_RenderDecoration": const RenderDecorationDescriptor(),
        "_RenderMagnification": const RenderMagnifierDescriptor(),
        "RenderDecoratedBox": const RenderDecoratedBoxDescriptor(),
        "RenderImage": RenderImageDescriptor(),
        "RenderParagraph": RenderParagraphDescriptor(),
        "RenderPhysicalModel": const RenderPhysicalModelDescriptor(),
        "RenderPhysicalShape": const RenderPhysicalModelDescriptor(),
        "RenderEditable": RenderParagraphDescriptor(),
        "RenderCustomPaint": RenderCustomPaintDescriptor(),
        "RenderPadding": const RenderPaddingDescriptor(),
        "RenderOpacity": const RenderOpacityDescriptor(),
        "RenderAndroidView": const RenderAndroidViewDescriptor(),
      };
}
