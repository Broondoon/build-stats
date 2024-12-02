import 'package:flutter/material.dart';

class CatCommentCard extends StatelessWidget {
  const CatCommentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: TextFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Comment here...'
          ),
        )
      ),
    );
  }
}