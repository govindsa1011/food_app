import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class FDSkeletonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: PKCardListSkeleton(
        isCircularImage: false,
        isBottomLinesActive: true,
        length: 10,
      ),
    );
  }
}

class FDDetailsSkeletonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PKCardProfileSkeleton(isCircularImage: false),
    );
  }
}
