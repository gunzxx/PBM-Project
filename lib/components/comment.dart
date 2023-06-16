import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String username, comment, avatarUrl;
  final int index;

  const CommentWidget({
    Key? key,
    required this.username,
    required this.comment,
    required this.avatarUrl,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: index % 2 == 1 ? const Color(0xFFF6F6F6) : Colors.white,
      // constraints: BoxConstraints(minHeight: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 20.0,
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
