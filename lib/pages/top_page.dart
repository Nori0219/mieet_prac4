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


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('flutter ~ firebase'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: memoCollection.snapshots(),//memoCollectionが更新されたら検知して builderを実行
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
                title: data['title'],
                detail: data['detail'],
                createdDate: data['createdDate'],
                updatedDate: data['updatedDate'],
              );
              return ListTile(
                title: Text(fetchMemo.title),
                trailing: IconButton(//編集ボタンの追加
                  onPressed: (){
                    //下から出てくる
                    showModalBottomSheet(context: context, builder: (context){
                      return SafeArea(//iPhone の画面下にスペースをつくる・誤タップ防止
                        child: Column(
                          mainAxisSize: MainAxisSize.min,//出てくる領域の高さを設定
                          children: [
                            ListTile(
                              onTap: () {
                                
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text('編集'),
                            ),
                            ListTile(
                              onTap: () {
                                
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