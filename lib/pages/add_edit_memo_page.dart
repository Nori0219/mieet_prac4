import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_memmo_app/model/memo.dart';

//stl
class AddEditMemoPage extends StatefulWidget {
  final Memo? currentMemo; 
  const AddEditMemoPage({Key? key, this.currentMemo}) : super(key: key);

  @override
  State<AddEditMemoPage> createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  TextEditingController titleControleler = TextEditingController();
  TextEditingController detailControleler = TextEditingController();

  //メモを追加する
  //Future<void> createMemo() async{
  //だとエラーが出てしまった
  //Futureは時間の掛かる処理　await を書くことで次の処理が優先されなくなる
  Future createMemo() async{
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    await memoCollection.add({
      'title':titleControleler.text,
      'detail':detailControleler.text,//テキストフィールドのテキストを代入
      'createdDate':Timestamp.now(),
    });
  }

  Future updateMemo() async{
      final doc = FirebaseFirestore.instance.collection('memo').doc(widget.currentMemo!.id);
      await doc.update({
        'title':titleControleler.text,
        'detail':detailControleler.text,//テキストフィールドのテキストを代入
        'updatedDate':Timestamp.now(),
      });
    }
  //init state
  //編集押したときに既存の情報を表示させる

  
  @override
    void initState() {
      super.initState();
      if (widget.currentMemo != null ) {
        titleControleler.text = widget.currentMemo!.title;
        detailControleler.text = widget.currentMemo!.detail;
      }
    }

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.currentMemo == null ? 'メモ追加': 'メモ編集'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40,),
            const Text('タイトル'),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ) ,
              width: MediaQuery.of(context).size.width * 0.8,//幅を調整（画面幅の8割）
              child: TextField(
                controller: titleControleler,  
                decoration: const InputDecoration(
                  border: InputBorder.none,//入力の下線を消す
                  contentPadding: EdgeInsets.only(left: 10)//検索欄の余白
                ),
                
              )
            ),
            const SizedBox(height: 40,),
            const Text('詳細'),
            const SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ) ,
              width: MediaQuery.of(context).size.width * 0.8,//幅を調整（画面幅の8割）
              child: TextField(
                controller: detailControleler,
                decoration: const InputDecoration(
                  border: InputBorder.none,//入力の下線を消す
                  contentPadding: EdgeInsets.only(left: 10)//検索欄の余白
                ),
                
              )
            ),
            const SizedBox(height: 40,),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,//幅を調整（画面幅の8割）
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if ( widget.currentMemo == null) {
                    await createMemo();//createMemo()は時間の掛かる処理だからawaitを書く（メモが追加されてから次の処理を行う）　async が必要
                  }else {
                    await updateMemo();
                  }
                  Navigator.pop(context);//いちばん上のレイヤーを取り除くつまり
                  
                },
                child:  Text(widget.currentMemo == null ?'追加' : '更新'),
              ),
            )
          ],
        ),
      ),
    );
  }
}