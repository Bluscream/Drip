import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../artistspage.dart';

// class TopResults extends StatelessWidget {
//   const TopResults({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  FluentCard();
//   }
// }

class TopResultType {
  final String title;
  final String? description;
  final String? someId;
  final String? thumbs;
  final String type;

  TopResultType(
      {required this.title,
      this.description,
      this.someId,
      required this.thumbs,
      required this.type});
}

class TopResults extends StatelessWidget {
  const TopResults({super.key, required this.topResult});

  final TopResultType topResult;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: const Color(0x55000000),
      child: InkWell(
        onTap: () {
          if (topResult.someId != null) {
            print(topResult.someId);
            if (topResult.type == "Artist") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArtistsPage(channelId: topResult.someId.toString()),
                ),
              );
            }
          } else{
            if (kDebugMode) {
              print("No data");
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      topResult.thumbs ??
                          "https://upload.wikimedia.org/wikipedia/en/3/39/The_Weeknd_-_Starboy.png",
                      // width: MediaQuery.of(context).size.width /3,
                      height: MediaQuery.of(context).size.height / 3.5,

                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topResult.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            // color: Colors.blue,
                          ),
                        ),
                        Text(
                          topResult.description ?? "NA",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
