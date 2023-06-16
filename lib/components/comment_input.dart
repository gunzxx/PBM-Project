import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  final FocusNode _commentNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void _sendComment() {
    if (_formKey.currentState!.validate()) {
      print("OKE");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: _commentNode,
                decoration: InputDecoration(
                  hintText: 'Tambahkan komentar...',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Tidak boleh kosong";
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendComment,
            ),
          ],
        ),
      ),
    );
  }
}
