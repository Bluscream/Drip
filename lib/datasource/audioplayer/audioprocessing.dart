// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:harmonoid/interface/changenotifiers.dart';
// import 'package:harmonoid/interface/harmonoid.dart';
// import 'package:harmonoid/utils/widgets.dart';
// import 'package:harmonoid/core/collection.dart';
//
// const String kRequestAuthority = 'music.youtube.com';
// const String kRequestKey = 'AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30';
// const Map<String, String> kRequestHeaders = {
//   'accept': '*/*',
//   'accept-language': 'en-GB,en;q=0.9,en-US;q=0.8',
//   'content-type': 'application/json',
//   'dpr': '2',
//   'sec-ch-ua-arch': '',
//   'sec-fetch-dest': 'empty',
//   'sec-fetch-mode': 'same-origin',
//   'sec-fetch-site': 'same-origin',
//   'x-origin': 'https://music.youtube.com',
//   'x-youtube-client-name': '67',
//   'x-youtube-client-version': '1.20210823.00.00',
// };
// const Map<String, dynamic> kRequestPayload = {
//   'context': {
//     'client': {
//       'clientName': 'WEB_REMIX',
//       'clientVersion': '0.1',
//       'newVisitorCookie': true,
//     },
//     'user': {'lockedSafetyMode': false,}
//   }
// };
//
// abstract class Client {
//   static Future<Response> request(String path,
//       Map<String, String> properties) async {
//     var response = await post(Uri.https(
//         kRequestAuthority, '/youtubei/v1/$path', {'key': kRequestKey,}),
//         headers: kRequestHeaders,
//         body: jsonEncode({...kRequestPayload, ...properties,}));
//     return response;
//   }
// }
//
// abstract class Exceptions {
//   static Future<void> failure() async {
//     showDialog(
//       context: key.currentState!.overlay!.context,
//       builder: (context) =>
//           FractionallyScaledWidget(child: AlertDialog(
//             title: Text(
//               'Could not fetch the YouTube audio stream.', style: Theme
//                 .of(context)
//                 .textTheme
//                 .headline1,),
//             content: Text(
//               'Please report the issue on the repository. Possibly something changed on YouTube\'s website.\nLet\'s play your local music till then.',
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .headline3,),
//             actions: [MaterialButton(
//               textColor: Theme
//                   .of(context)
//                   .primaryColor, onPressed: Navigator
//                 .of(context)
//                 .pop, child: Text('OK'),),
//             ],),),);
//     nowPlaying.isBuffering = false;
//   }
//
//   static Future<void> invalidLink() async {
//     showDialog(
//       context: key.currentState!.overlay!.context,
//       builder: (context) =>
//           FractionallyScaledWidget(child: AlertDialog(
//             title: Text('Invalid link.', style: Theme
//                 .of(context)
//                 .textTheme
//                 .headline1,),
//             content: Text(
//               'Please give us correct link to the media.\nIf you think this is a false result, please report at the repository.',
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .headline3,),
//             actions: [MaterialButton(
//               textColor: Theme
//                   .of(context)
//                   .primaryColor, onPressed: Navigator
//                 .of(context)
//                 .pop, child: Text('OK'),),
//             ],),),);
//   }
// }
//
// abstract class YTM {
//   static Future<List<Track>> search(String query) async {
//     var result = [];
//     var response = await Client.request(
//         'search', {'query': query, 'params': 'EgWKAQIIAWoMEAMQBBAOEAoQBRAJ',});
//     var body = jsonDecode(response.body)['contents'];
//     if (body.containsKey('tabbedSearchResultsRenderer')) {
//       body = body['tabbedSearchResultsRenderer']['tabs']
//           .first['tabRenderer']['content'];
//     } else {
//       body = body['contents'];
//     }
//     try {
//       body = body['sectionListRenderer']['contents']
//           .first['musicShelfRenderer']['contents'];
//     } catch (exception) {
//       return [];
//     }
//     for (var object in body) {
//       object = object['musicResponsiveListItemRenderer'];
//       try {
//         var metas = object['flexColumns'][1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs']
//             .map((meta) => meta['text']).toList()
//             .join(' ');
//         var duration = metas.split('\u2022')[2].trim();
//         duration = int.parse(duration
//             .split(':')
//             .first) * 60 + int.parse(duration.split(':')[1]);
//         var track = Track(trackId: object['flexColumns']
//             .first['musicResponsiveListItemFlexColumnRenderer']['text']['runs']
//             .first['navigationEndpoint']['watchEndpoint']['videoId'],
//             trackName: object['flexColumns']
//                 .first['musicResponsiveListItemFlexColumnRenderer']['text']['runs']
//                 .first['text'],
//             trackArtistNames: metas
//                 .split('\u2022')
//                 .first
//                 .split(RegExp(',|&'))
//                 .map((meta) => meta.trim())
//                 .toList()
//                 .cast<String>(),
//             albumArtistName: metas
//                 .split('\u2022')
//                 .first
//                 .split(RegExp(',|&'))
//                 .map((meta) => meta.trim())
//                 .toList()
//                 .cast<String>()
//                 .first,
//             trackDuration: duration * 1000,
//             networkAlbumArt: object['thumbnail']['musicThumbnailRenderer']['thumbnail']['thumbnails']
//                 .last['url'].replaceAll(
//                 RegExp('w...-h...-l90'), 'w480-h480-l90'),
//             albumId: object['menu']['menuRenderer']['items'][object['menu']['menuRenderer']['items']
//                 .length -
//                 3]['menuNavigationItemRenderer']['navigationEndpoint']['browseEndpoint']['browseId'],
//             albumName: metas.split('\u2022')[1].trim());
//         result.add(track);
//       } catch (exception, stacktrace) {
//         print(exception);
//         print(stacktrace);
//       }
//     }
//     return result.cast();
//   }
//
//   static Future<Track?> identify(String query) async {
//     String? id;
//     if (query.contains('youtu') && query.contains('/')) {
//       if (query.contains('/watch?v=')) {
//         id = query.substring(query.indexOf('=') + 1);
//       } else {
//         id = query.substring(query.indexOf('/') + 1);
//       }
//     }
//     id = id
//         ?.split('&')
//         .first
//         .split('/')
//         .first;
//     if (id == null) return null;
//     try {
//       var video = await get(Uri.https('www.youtube.com', '/watch', {'v': id,}));
//       var body = video.body.split(';</script>');
//       var response = jsonDecode(body[body.length - 3]
//           .split('var ytInitialData = ')
//           .last)['contents']['twoColumnWatchNextResults']['results']['results']['contents'];
//       var description = response[1]['videoSecondaryInfoRenderer']['description']['runs'][0]['text'];
//       var trackArtistNames;
//       var albumName;
//       try {
//         trackArtistNames =
//             description[1].split(" · ").sublist(1).map((meta) => meta.trim())
//                 .toList()
//                 .cast<String>();
//         albumName = description[2].trim();
//       } catch (exception) {
//         trackArtistNames = [
//           response[1]['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['text'],
//         ].cast<String>();
//       }
//       return Track(trackId: id,
//           trackName: response[0]['videoPrimaryInfoRenderer']['title']['runs'][0]['text'],
//           trackArtistNames: trackArtistNames,
//           albumArtistName: trackArtistNames.isNotEmpty
//               ? trackArtistNames.first
//               : null,
//           albumName: albumName ?? 'Unknown Album',
//           networkAlbumArt: 'https://img.youtube.com/vi/$id/0.jpg');
//     } catch (exception, stacktrace) {
//       print(exception);
//       print(stacktrace);
//       throw Exception();
//     }
//   }
//
//   static Future<List<String>> suggestions(String query) async {
//     var response = await Client.request(
//         'music/get_search_suggestions', {'input': query,});
//     var body = jsonDecode(response
//         .body)['contents'][0]['searchSuggestionsSectionRenderer']['contents'];
//     var result = <String>[];
//     for (var object in body) {
//       if (object.containsKey('searchSuggestionRenderer')) {
//         result.add(
//             object['searchSuggestionRenderer']['suggestion']['runs'].map((
//                 text) => text['text']).toList().join(''));
//       }
//     }
//     return result;
//   }
// }
// extension TrackExtension on Track {
//   Future<void> attachAudioStream({void Function()? onDone}) async {
//     if (filePath != null) return;
//     try {
//       var response = await post(Uri.https(
//         kRequestAuthority, 'youtubei/v1/player', {'key': kRequestKey,},),
//         body: jsonEncode({
//           'context': {
//             'client': {
//               'clientName': 'ANDROID',
//               'clientScreen': 'EMBED',
//               'clientVersion': '16.43.34',
//             },
//             'thirdParty': {'embedUrl': 'https://www.youtube.com',},
//           },
//           'videoId': this.trackId,
//         },), headers: kRequestHeaders,);
//       var body = jsonDecode(response.body)['streamingData'];
//       var opus;
//       var mp4;
//       var aac;
//       for (var format in body['adaptiveFormats']) {
//         print(format['itag']);
//         if (format['itag'] == 251) opus = format['url'];
//         if (format['itag'] == 18) mp4 = format['url'];
//         if (format['itag'] == 140) aac = format['url'];
//       }
//       print(opus ?? mp4 ?? aac);
//       if (response.statusCode != 200) {
//         Exceptions.failure();
//         return;
//       }
//       filePath = opus ?? mp4 ?? aac;
//       onDone?.call();
//           () async {
//         var video = await get(
//             Uri.https('www.youtube.com', '/watch', {'v': trackId,}));
//         var body = video.body.split(';</script>');
//         var response = jsonDecode(body[body.length - 5]
//             .split('var ytInitialPlayerResponse = ')
//             .last);
//         this.extras = response['videoDetails']['shortDescription'];
//         var year = extras.split('\n\n')[extras
//             .split('\n\n')
//             .length - 3];
//         if (year.startsWith('Released on: ')) {
//           this.year = int.tryParse(year
//               .split('Released on: ')
//               .last
//               .split('-')
//               .first);
//         }
//         onDone?.call();
//       }();
//     } catch (exception, stacktrace) {
//       print(exception);
//       print(stacktrace);
//     }
//   }
//
//   Future<List<Track>> get recommendations async {
//     var result = [];
//     var response = await Client.request('next', {
//       'enablePersistentPlaylistPanel': 'true',
//       'isAudioOnly': 'true',
//       'params': 'wAEB',
//       'tunerSettingValue': 'AUTOMIX_SETTING_NORMAL',
//       'videoId': trackId!,
//     });
//     var body = jsonDecode(response
//         .body)['contents']['singleColumnMusicWatchNextResultsRenderer']['tabbedRenderer']['watchNextTabbedResultsRenderer']['tabs'][0]['tabRenderer']['content']['musicQueueRenderer']['content']['playlistPanelRenderer']['contents'];
//     for (var object in body) {
//       object = object['playlistPanelVideoRenderer'];
//       try {
//         var metas = object['longBylineText']['runs']
//             .map((meta) => meta['text'])
//             .toList()
//             .join(' ');
//         var duration = object['lengthText']['runs'][0]['text'];
//         duration = int.parse(duration
//             .split(':')
//             .first) * 60 + int.parse(duration.split(':')[1]);
//         var track = Track(trackId: object['videoId'],
//             trackName: object['title']['runs'][0]['text'],
//             trackArtistNames: metas
//                 .split('\u2022')
//                 .first
//                 .split(RegExp(',|&'))
//                 .map((meta) => meta.trim())
//                 .toList()
//                 .cast<String>(),
//             albumArtistName: metas
//                 .split('\u2022')
//                 .first
//                 .split(RegExp(',|&'))
//                 .map((meta) => meta.trim())
//                 .toList()
//                 .cast<String>()
//                 .first,
//             trackDuration: duration * 1000,
//             networkAlbumArt: object['thumbnail']['thumbnails'][object['thumbnail']['thumbnails']
//                 .length - 2]['url'],
//             albumId: object['menu']['menuRenderer']['items'][object['menu']['menuRenderer']['items']
//                 .length -
//                 2]['menuNavigationItemRenderer']['navigationEndpoint']['browseEndpoint']['browseId'],
//             albumName: metas.split('\u2022')[1].trim());
//         result.add(track);
//       } catch (exception, stacktrace) {
//         print(exception);
//         print(stacktrace);
//       }
//     }
//     return result.cast();
//   }
// }