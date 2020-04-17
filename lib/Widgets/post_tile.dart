import 'package:flutter/material.dart';

import 'Custom_image.dart';
import 'Post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => print('showing post'),
      child : cachedNetworkImage(post.mediaUrl),
    );
  }
}