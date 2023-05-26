import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foap/components/custom_texts.dart';
import 'package:foap/components/media_card.dart';
import 'package:foap/components/top_navigation_bar.dart';
import 'package:foap/controllers/podcast_streaming_controller.dart';
import 'package:foap/helper/common_components.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/helper/localization_strings.dart';
import 'package:foap/screens/add_on/ui/podcast/podcast_show_detail.dart';
import 'package:foap/util/app_config_constants.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart' as read_more;
import '../../model/podcast_model.dart';

class PodcastHostDetail extends StatefulWidget {
  final PodcastModel? podcastModel;

  const PodcastHostDetail({Key? key, this.podcastModel}) : super(key: key);

  @override
  State<PodcastHostDetail> createState() => _PodcastHostDetailState();
}

class _PodcastHostDetailState extends State<PodcastHostDetail> {
  final PodcastStreamingController _podcastStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _podcastStreamingController.getPodcastShows(
          podcastId: widget.podcastModel?.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backNavigationBar(
                     title: widget.podcastModel?.name ?? "")
                ,
            divider().tP8,
            Expanded(
              child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: widget.podcastModel?.image ?? "",
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                              )),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.podcastModel?.name ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                    .bP4,
                                read_more.ReadMoreText(
                                  widget.podcastModel?.description ?? "",
                                  trimLines: 2,
                                  trimMode: read_more.TrimMode.Line,
                                  colorClickableText: Colors.white,
                                  trimCollapsedText:
                                      showMoreString.tr,
                                  trimExpandedText:
                                      '    ${showLessString.tr}',
                                  moreStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Heading6Text(
                                  albumsString.tr,
                                  color: AppColorConstants.themeColor,
                                  weight: TextWeight.bold,
                                ).setPadding(top: 15)
                              ]).setPadding(left: 15, right: 15, top: 15),
                        ]),
                    GetBuilder<PodcastStreamingController>(
                        init: _podcastStreamingController,
                        builder: (ctx) {
                          return GridView.builder(
                              itemCount: _podcastStreamingController
                                  .podcastShows.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      mainAxisExtent: 180),
                              itemBuilder: (context, index) {
                                MediaModel model = MediaModel(
                                    _podcastStreamingController
                                        .podcastShows[index].name,
                                    _podcastStreamingController
                                        .podcastShows[index].image,
                                    _podcastStreamingController
                                        .podcastShows[index].showTime);
                                return MediaCard(model: model).ripple(() {
                                  Get.to(() => PodcastShowDetail(
                                        podcastShowModel:
                                            _podcastStreamingController
                                                .podcastShows[index],
                                      ));
                                });
                              }).setPadding(left: 15, right: 15, bottom: 50);
                        })
                  ]),
            ),
          ],
        ));
  }
}
