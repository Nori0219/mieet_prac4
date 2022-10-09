import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_memmo_app/model/memo.dart';

class MemoDetailPage extends StatelessWidget {
  
  final Memo memo;
  const MemoDetailPage(this.memo,{Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text(memo.title) ,
      ),
      body: Center(//横軸のセンター
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,//縦軸の中央
          children: [
            Text('メモ詳細', style: TextStyle(fontSize: 20, fontWeight:  FontWeight.bold),),
            Text(memo.detail, style: TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }
}