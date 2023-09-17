import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Container(
                  height: 400.0,
                  width: double.infinity,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
         
    ],
      ),
    );
  }
}