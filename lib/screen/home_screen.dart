import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_crunk_studios/model/channel_info.dart';
import 'package:youtube_crunk_studios/model/videos_list.dart';
import 'package:youtube_crunk_studios/screen/video_player_screen.dart';
import 'package:youtube_crunk_studios/utils/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ChannelInfo _channelInfo;
  Item _item;
  VideosList _videosList;
  bool _loading;
  String _playlistId;
  String _nextPageToken;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _nextPageToken = '';
    _videosList = VideosList();
    _videosList.videos = List();
    _getChannelInfo();
  }

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    setState(() async {
      _item = _channelInfo.items[0];
      _playlistId = _item.contentDetails.relatedPlaylists.uploads;
      await _loadVideos();
      print('playlistId $_playlistId');

      _loading = false;
    });
  }

  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playlistId,
      pageToken: _nextPageToken,
    );
    // _nextPageToken = tempVideosList
    _videosList.videos.addAll(tempVideosList.videos);
    print('videos length ${_videosList.videos.length}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crunk Studios',
        ),
        centerTitle: true,
      ),
      body: _loading
          ? CircularProgressIndicator()
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildInfoView(),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _videosList.videos.length,
                          itemBuilder: (context, index) {
                            VideoItem videoItem = _videosList.videos[index];
                            return InkWell(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VideoPlayerScreen(videoItem: videoItem,);
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: videoItem.video.thumbnails
                                            .thumbnailsDefault.url),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                        child: Text(
                                      videoItem.video.title,
                                      style: TextStyle(fontSize: 15),
                                    )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
    );
  }

  _buildInfoView() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
              _item.snippet.thumbnails.medium.url,
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                _item.snippet.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            Text(_item.statistics.videoCount),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      )),
    );
  }
}
