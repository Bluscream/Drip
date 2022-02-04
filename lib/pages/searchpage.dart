import 'dart:core';


import 'package:drip/datasources/searchresults/albumsdataclass.dart';
import 'package:drip/datasources/searchresults/artistsdataclass.dart';
import 'package:drip/datasources/searchresults/communityplaylistdataclass.dart';
import 'package:drip/datasources/searchresults/searchresultstwo.dart';
import 'package:drip/datasources/searchresults/songsdataclass.dart';
import 'package:drip/pages/searchresultwidgets/albumsresultwidget.dart';
import 'package:drip/pages/searchresultwidgets/artistsresultwidget.dart';
import 'package:drip/pages/searchresultwidgets/communityplaylistresultwidget.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'common/musiclist.dart';

class SearchPage extends StatefulWidget {
  final String incomingquery;

  const SearchPage({
    Key? key,
    required this.incomingquery,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  final TextEditingController _searchcontroller = TextEditingController();

  String query = '';
  bool status = false;
  late Map listOfSearchResults = {};
  late List<Artists> artists = [];
  late List<Albums> albums = [];
  late List<Songs> songs = [];
  late List<CommunityPlaylist> communityplaylists = [];

  // late List listOfSearchResults = [];
  // late Topresults _topresults;
  // late List<Songs> _searchpageresults;
  bool fetched = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // SearchMusic().getArtists('new');
    _searchcontroller.text = query;
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Object? args = ModalRoute.of(context)?.settings.arguments as Map;
    // var incomingquery = args['searchkey'].toString();

    super.build(context);

    if (!status) {
      status = true;
      SearchMusic.getArtists(query == '' ? widget.incomingquery : query)
          .then((value) {
        if (this.mounted) {
          setState(() {
            listOfSearchResults = value;
            // artists = listOfSearchResults[0];
            // songs = listOfSearchResults[1];
            // communityplaylists = listOfSearchResults[2];
            // albums = listOfSearchResults[3];
            // _topresults = listOfSearchResults[4];
            artists = listOfSearchResults['artistsearch'];
            songs = listOfSearchResults['songsearch'];
            communityplaylists = listOfSearchResults['communityplaylistsearch'];
            albums = listOfSearchResults['albumsearch'];
            // _topresults = listOfSearchResults['topresults'];
            fetched = true;
          });
        }
      });
    }
    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,

            padding: const EdgeInsets.fromLTRB(10, 40, 20, 20),
            //width: 400,
            child: Row(
              children: [
                Navigator.of(context).canPop()
                    ? Row(
                        children: [
                          InkWell(
                              child: const Icon(
                                  fluent.FluentIcons.chevron_left_med),
                              hoverColor: Colors.red,
                              onTap: () {
                                Navigator.of(context).pop();
                              }),
                          const fluent.SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    : const SizedBox(),
                fluent.SizedBox(
                  width: 400,
                  child: CupertinoSearchTextField(
                    controller: _searchcontroller,

                    // onChanged: (value) {
                    //   url =
                    //       'http://127.0.0.1:5000/search?query=$value&filter=songs&limit=20';
                    // },
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (_value) async {
                       setState(() {
                        fetched = false;
                        query = _value;
                        status = false;
                        listOfSearchResults = {};
                      });
                    },

                    //backgroundColor: Colors.red.shade700.withOpacity(0.3),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            style: BorderStyle.solid,
                            width: 0.5),
                        // color: Colors.red.shade900.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: (!fetched)
                  ? Container(
                      alignment: Alignment.center,
                      width: 500,
                      height: 500,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.red, size: 300))
                  //const CircularProgressIndicator(color: Colors.red))
                  : SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    primary: false,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 5),
                    child: Column(
                      children: [

                        SingleChildScrollView(

                          padding: const fluent.EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [Text(

                              query == ''
                                  ? 'Results for \"${widget.incomingquery}\"'
                                  : 'Results for \"$query\"',
                              style: const TextStyle(

                                overflow: TextOverflow.ellipsis,
                                fontSize: 40.0,
                              ),
                            ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Text(
                                   'Songs',
                                   style: TextStyle(
                                     ///color: Theme.of(context).colorScheme.secondary,
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.normal,
                                   ),
                                 ),
                                 InkWell(
                                   onTap: () {
                                     Navigator.of(context).pushNamed('songslistpage', arguments:  query == '' ? widget.incomingquery : query);

                                   },
                                   child: const Text(
                                     'Show more     ',
                                     style: TextStyle(
                                       ///color: Theme.of(context).colorScheme.secondary,
                                       color: Colors.red,
                                       fontSize: 18,
                                       fontWeight: FontWeight.normal,
                                     ),
                                   ),
                                 ),

                               ],
                             ),
                              const SizedBox(
                                height: 10,
                              ),

                             Align(
                               alignment: Alignment.centerLeft,
                               child: Container(

                                 color: Colors.black12,
                                 padding: EdgeInsets.all(10),
                                // width: MediaQuery.of(context).size.width *3/4,
                                 height: MediaQuery.of(context).size.height *1/3,
                                   child: MusicList(isExpandedPage: false, incomingquery: 'home', songs: songs, toSongsList: query == '' ? widget.incomingquery : query)),
                             ),


                             // SongsSearch(songs: songs,toSongsList: query == '' ? widget.incomingquery : query),
                              const SizedBox(
                                height: 30,
                              ),
                              artists.isNotEmpty
                                  ? ArtistsSearch(artists: artists)
                                  : Text('No Artists available'),
                              const SizedBox(
                                height: 10,
                              ),
                              albums.isNotEmpty
                                  ? AlbumSearch(albums: albums)
                                  : Text('No Albums available'),
                              const SizedBox(
                                height: 40,
                              ),
                              communityplaylists.isNotEmpty
                                  ? CommunityPlaylistSearch(
                                      communityPlaylist: communityplaylists)
                                  : Text('No Playlists available'),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
        ],
      ),
    );
  }
}