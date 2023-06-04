import 'package:flutter/material.dart';
import 'package:my_project/player.dart';

import 'database_helper.dart';

// ignore: must_be_immutable
class ResultPage extends StatefulWidget {
  final int? group;

  const ResultPage({super.key, required this.group});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<Player>> _playerList;
  List data = [];
  late List<String> ismlar1 = [];
  late List<String> ismlar2 = [];
  late List<String> ismlar3 = [];
  late List<String> ismlar4 = [];

  late int x = 0;

  void buildItem() {
    int x = 0;
    ismlar1 = [];
    ismlar2 = [];
    ismlar3 = [];
    ismlar4 = [];
    data.shuffle();
    for (String player in data) {
      if (widget.group == 2) {
        if (x == 0) {
          ismlar1.add(player);
          x = 1;
        } else {
          ismlar2.add(player);
          x = 0;
        }
      } else if (widget.group == 3) {
        if (x == 0) {
          ismlar1.add(player);
          x = 1;
        } else if (x == 1) {
          ismlar2.add(player);
          x = 2;
        } else {
          ismlar3.add(player);
          x = 0;
        }
      } else {
        if (x == 0) {
          ismlar1.add(player);
          x = 1;
        } else if (x == 1) {
          ismlar2.add(player);
          x = 2;
        } else if (x == 2) {
          ismlar3.add(player);
          x = 3;
        } else {
          ismlar4.add(player);
          x = 0;
        }
      }
      setState(() {});
    }

    print("_____________________________ismlar1 + $data");
  }

  Widget _ListBuild(List listlar) {
    print(
        "__________+++++++++++++++++++++ _listBUild ishladiiiii__________ $listlar");
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listlar.length,
        itemBuilder: (context, index) => Container(
          child: Text(
            listlar[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  Future<void> getData() async {
    _playerList = DatabaseHelper.instance.getSelectedPlayerList();
    await Future.delayed(const Duration(seconds: 1));
    _playerList.then(
      (allPlayers) {
        for (Player eachPlayer in allPlayers) {
          data.add(eachPlayer.name.toString());
        }
        // data.shuffle();
        print(data);
        buildItem();
        const Duration(seconds: 1);

        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resoult Page")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => buildItem(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Refresh"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Group 1:",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(child: _ListBuild(ismlar1)),
                ],
              ),
              const Divider(thickness: 1, color: Colors.blueGrey),
              Row(
                children: [
                  const Text(
                    "Group 2:",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(child: _ListBuild(ismlar2)),
                ],
              ),
              const Divider(thickness: 1, color: Colors.blueGrey),
              Row(
                children: [
                  const Text(
                    "Group 3:",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(child: _ListBuild(ismlar3)),
                ],
              ),
              const Divider(thickness: 1, color: Colors.blueGrey),
              Row(
                children: [
                  widget.group != 4
                      ? const SizedBox(
                          width: 1,
                        )
                      : const Text(
                          "Group 4:",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                  const SizedBox(width: 10),
                  Container(child: _ListBuild(ismlar4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
