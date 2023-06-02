import 'package:flutter/material.dart';
import 'package:my_project/player.dart';

import 'database_helper.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<List<Player>> _playerList;
  List data = [];

  Widget _buildItem(Player player) {
    return Container(
      child: Text(player.name!),
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
          data.add(eachPlayer);
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: data.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) => _buildItem(
                    data.elementAt(index),
                  ),
                ),
        ),
      ),
    );
  }
}
