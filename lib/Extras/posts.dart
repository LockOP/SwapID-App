import 'package:flutter/foundation.dart';

class AllPost {
  final int count;
  final String text,
      image,
      postId,
      memberName,
      memberPhone,
      realUserId;

  const AllPost({
    @required this.count,
    @required this.text, this.image, this.postId, this.realUserId,
              this.memberName, this.memberPhone,
  });
}