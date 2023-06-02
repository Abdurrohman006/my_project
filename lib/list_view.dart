import 'package:flutter/material.dart';

import 'add_players.dart';
import 'database_helper.dart';
import 'player.dart';

class ListViewPlayers extends StatefulWidget {
  const ListViewPlayers({Key? key}) : super(key: key);

  @override
  State<ListViewPlayers> createState() => _ListViewPlayersState();
}

class _ListViewPlayersState extends State<ListViewPlayers> {
  late Future<List<Player>> _playerList;

//////////////////////// WIDGET BUILDITEM ////////////////////////
  Widget _buildItem(Player player) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddPlayers(
            updatePlayerList: _updatePlayerList,
            player: player,
          ),
        ),
      ).then(
        (value) => _updatePlayerList(),
      ),
      title: Text(
        player.name!,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  void initState() {
    _updatePlayerList();
    super.initState();
  }

//////////////////////// UpdatePlayerList in Database Function ////////////////////////

  // ignore: no_leading_underscores_for_local_identifiers
  _updatePlayerList() {
    setState(() {
      _playerList = DatabaseHelper.instance.getPlayerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: _playerList,
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    child: const Row(
                      children: [
                        Text(
                          "All Players",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return _buildItem(snapshot.data[index - 1]);
                }
              });
        });
  }
}
