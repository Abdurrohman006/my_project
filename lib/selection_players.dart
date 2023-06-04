import 'package:flutter/material.dart';
import 'package:my_project/result_page.dart';

import 'database_helper.dart';
import 'player.dart';

class SelectionPlayers extends StatefulWidget {
  const SelectionPlayers({Key? key}) : super(key: key);

  @override
  State<SelectionPlayers> createState() => _SelectionPlayersState();
}

class _SelectionPlayersState extends State<SelectionPlayers> {
  int? group = 3;
  final _formKey = GlobalKey<FormState>();
  late Future<List<Player>> _playerList;

  /////////////////////////////////////////////////////////////////
  Widget _buildItem(Player player) {
    return ListTile(
      title: Text(
        player.name!,
        style: TextStyle(
            fontSize: 18,
            decoration: player.status != 0
                ? TextDecoration.none
                : TextDecoration.lineThrough),
      ),
      trailing: Checkbox(
        value: player.status == 0 ? false : true,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (bool? value) {
          if (value != null) {
            player.status = value ? 1 : 0;
          }
          DatabaseHelper.instance.updatePlayer(player);
          _updatePlayerList();
        },
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////

  Widget _selectGroup() {
    return SafeArea(
      child: Column(
        children: [
          const Text(
            "Slected of group",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                const Text(
                  "2:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Radio(
                  value: 2,
                  groupValue: group,
                  onChanged: (value) {
                    setState(() {
                      group = value?.toInt();
                    });
                  },
                ),
                const Text(
                  "3:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Radio(
                  value: 3,
                  groupValue: group,
                  onChanged: (value) {
                    setState(() {
                      group = value?.toInt();
                    });
                  },
                ),
                const Text(
                  "4:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Radio(
                  value: 4,
                  groupValue: group,
                  onChanged: (value) {
                    setState(() {
                      group = value?.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////

  // _submit() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //   }
  // }

///////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////

  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        children: [
          _selectGroup(),
          FutureBuilder(
              future: _playerList,
              builder: (context, AsyncSnapshot snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        snapshot.data != null ? snapshot.data.length + 1 : 0,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return const Row(
                          children: [
                            Center(
                              child: Text(
                                " Player selection",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      } else {
                        return _buildItem(snapshot.data[index - 1]);
                      }
                    });
              }),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(group: group!),
                ),
              );
            },
            child: Text('Natijani ko\'rsatish'),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(33.0),
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: ListView(
  //             children: [
  //               Text(
  //                 "Komanda 1",
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //               const Divider(thickness: 1),
  //               category("So'ngi yangiliklar"),
  //               category("Mahalliy"),
  //               category("Dunyo"),
  //               category("Texnalogiyalar"),
  //               Text(
  //                 "Komanda 2",
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //               const Divider(thickness: 1),
  //               category("Tanlangan xabarlar", Colors.black),
  //               category("Madaniyat"),
  //               category("Avto"),
  //               category("Sport"),
  //               Text(
  //                 "Komanda 3",
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //               const Divider(thickness: 1),
  //               category("Foto"),
  //               category("Lifestyle"),
  //               category("Kolumnistlar"),
  //               category("Afisha"),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget category(String title, [Color givenColor = Colors.black]) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         height: 40,
  //         margin: const EdgeInsets.only(left: 18),
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //               color: givenColor, fontSize: 18, fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //       Checkbox(
  //         value: true,
  //         activeColor: Theme.of(context).primaryColor,
  //         onChanged: (bool? value) {},
  //       ),
  //     ],
  //   );
  // }
}
