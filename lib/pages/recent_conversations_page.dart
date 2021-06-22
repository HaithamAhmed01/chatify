import 'package:chatify/models/conversation.dart';
import 'package:chatify/services/db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecentConversationsPage extends StatelessWidget {
  final double _height;
  final double _widht;

  const RecentConversationsPage(this._height, this._widht);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _widht,
      child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance, child: _conversationsListViewWidget()),
    );
  }

  Widget _conversationsListViewWidget() {
    return Builder(builder: (BuildContext _context) {
      var _auth = Provider.of<AuthProvider>(_context);
      return Container(
          height: _height,
          width: _widht,
          child: StreamBuilder<List<ConversationSnippet>>(
            stream: DBService.instance.getUserConversations(_auth.user.uid),
            builder: (_context, _snapshot) {
              var _data = _snapshot.data;
              return _snapshot.hasData
                  ? ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (_context, _index) {
                        return ListTile(
                          onTap: () {},
                          title: Text(_data[_index].name),
                          subtitle: Text(_data[_index].lastMessage),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_data[_index].image),
                                )),
                          ),
                          trailing: _listTileTrailingWidgets(
                              _data[_index].timestamp),
                        );
                      },
                    )
                  : SpinKitWanderingCubes(
                      color: Colors.blue,
                      size: 50.0,
                    );
            },
          ));
    });
  }

  Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            timeago.format(_lastMessageTimestamp.toDate()),
            style: TextStyle(fontSize: 15),
          ),
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(100)),
          )
        ]);
  }
}
