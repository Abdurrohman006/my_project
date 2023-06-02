import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'player.dart';

class AddPlayers extends StatefulWidget {
  final Function? updatePlayerList;
  final Player? player;

  const AddPlayers({super.key, this.updatePlayerList, this.player});

  @override
  State<AddPlayers> createState() => _AddPlayersState();
}

class _AddPlayersState extends State<AddPlayers> {
  final _formKey = GlobalKey<FormState>();

  String? _name = "";

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Player player = Player(name: _name);

      if (widget.player == null) {
        // insert database
        player.status = 0;
        DatabaseHelper.instance.inserPlayer(player);
        Navigator.pop(context);
      } else {
        //update database
        player.id = widget.player!.id;
        player.status = widget.player!.status;
        player.name = _name;
        DatabaseHelper.instance.updatePlayer(player);
      }

      if (widget.updatePlayerList != null) widget.updatePlayerList!();
      if (widget.player != null) {
        Navigator.pop(context);
      }
    }
  }

  _delete() {
    DatabaseHelper.instance.deletePlayer(widget.player?.id);
    widget.updatePlayerList!();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.player != null) {
      _name = widget.player!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: Column(
              children: [
                Text(
                  widget.player == null ? "Create Player" : "Update player",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Name"),
                        onSaved: (input) => _name = input,
                        validator: (input) => input!.trim().isEmpty
                            ? "Please, Enter player Name"
                            : null,
                        initialValue: _name,
                      ),
                    ],
                  ),
                ),
                TextButton(onPressed: _submit, child: const Text("Save")),
                TextButton(onPressed: _delete, child: const Text("Delete"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
