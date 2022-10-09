import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_memmo_app/model/memo.dart';
import 'package:flutter_memmo_app/pages/add_edit_memo_page.dart';
import 'package:flutter_memmo_app/pages/memo_detail_page.dart';


class TopPage extends StatefulWidget {
  const TopPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  //メモを削除
  Future deleteMemo( String id) async{
    final doc =FirebaseFirestore.instance.collection('memo').doc(id);
    await doc.delete();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ'),
        centerTitle: true,
        actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {

            }),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {
              
            }),
          ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.orderBy('createdDate', descending: true).snapshots(),//memoCollectionが更新されたら検知して builderを実行
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData ) {//メモコレクションに情報が無かったら
            return const Center(child: Text('データがありません'),);
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
              final Memo fetchMemo = Memo(
                id: docs[index].id,
                title: data['title'],
                detail: data['detail'],
                createdDate: data['createdDate'],
                updatedDate: data['updatedDate'],
              );
              return Card(
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text(fetchMemo.title), 
                  subtitle:  Text(''),
                  trailing:IconButton(//編集ボタンの追加
                    onPressed: (){
                      //下から出てくる
                      showModalBottomSheet(context: context, builder: (context){
                        return SafeArea(//iPhone の画面下にスペースをつくる・誤タップ防止
                          child: Column(
                            mainAxisSize: MainAxisSize.min,//出てくる領域の高さを設定
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.pop(context);//ボトムシートを消す
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddEditMemoPage(currentMemo: fetchMemo ,)));
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('編集'),
                              ),
                              ListTile(
                                onTap: () async{
                                  await deleteMemo(fetchMemo.id);
                                  Navigator.pop(context);
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('削除'),
                              ),
                            ],
                          ),
                        );
                      });
                    } ,
                    icon: const Icon(Icons.edit ),
                    ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MemoDetailPage(fetchMemo)));//画面遷移
                  },
                ),
              );
            }
            
      
            );
        }
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const AddEditMemoPage()));//画面遷移

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}