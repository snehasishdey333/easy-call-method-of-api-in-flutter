import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    // print('fetching...');
    var url = Uri.parse("https://randomuser.me/api/?results=50");
    //you can change the size of page like you can make it 100 or anything
    var response = await http.get(url);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['results'];

      //print(items);
      setState(() {
        users = items;
        isLoading = false;
      });
    } else {
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'API Practice',
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    // List items = [
    //   '1',
    //   '2',
    //   '3',
    // ];
    if (users.contains(null) || users.isEmpty || isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        //itemCount: items.length,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(index) {
    //or you can use 'item' in the place of index
    var fullName = index['name']['title'] +
        " " +
        index['name']['first'] +
        " " +
        index['name']['last'];
    var email = index['email'];
    var profileImageUrl = index['picture']['large'];
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            title: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        profileImageUrl.toString(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      email.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
