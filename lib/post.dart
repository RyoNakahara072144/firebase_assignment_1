import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  TextEditingController postEditingController = TextEditingController();

  void addPost()async{

    await FirebaseFirestore.instance.collection('posts').add({
      'text': postEditingController.text,
      'id': widget.userId,
      'date': DateTime.now().millisecondsSinceEpoch,
    });
    postEditingController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //問２
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').orderBy('date').limit(10).snapshots(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<DocumentSnapshot> postsData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: postsData.length,
                        itemBuilder: (context, index){
                          Map<String, dynamic> postData = postsData[index].data() as Map<String, dynamic>;
                          return postCard(postData);
                        }
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      controller: postEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: (){addPost();},
                      icon: const Icon(Icons.send)
                  ),
                ),
                const SizedBox(width: 5,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postCard(Map<String, dynamic> postData){
    return Card(
      color: postData['id']==widget.userId?Colors.lightGreenAccent:Colors.white,
      child: ListTile(
        title: Text(postData['text']),
      ),
    );
  }
}