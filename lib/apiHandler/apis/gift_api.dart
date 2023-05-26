import 'dart:ui';
import 'package:foap/apiHandler/api_wrapper.dart';
import '../../model/api_meta_data.dart';
import '../../model/category_model.dart';
import '../../model/gift_model.dart';
import '../../model/post_gift_model.dart';
import '../../model/post_timeline_gift_response.dart';

class GiftApi {
  static getReceivedStickerGifts(
      {required int page,
      required int sendOnType,
      required int? postId,
      required int? liveId,
      required Function(List<ReceivedGiftModel>, APIMetaData)
          resultCallback}) async {
    var url = NetworkConstantsUtil.giftsReceived;
    url = url.replaceAll('{{send_on_type}}', sendOnType.toString());
    url = url.replaceAll(
        '{{live_call_id}}', liveId == null ? '' : liveId.toString());
    url =
        url.replaceAll('{{post_id}}', postId == null ? '' : postId.toString());

    url = '$url&page=$page';

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['gift']['items'];

        resultCallback(
            List<ReceivedGiftModel>.from(
                items.map((x) => ReceivedGiftModel.fromJson(x))),
            APIMetaData.fromJson(result.data['gift']['_meta']));
      }
    });
  }

  static getStickerGiftCategories(
      {required Function(List<GiftCategoryModel>) resultCallback}) async {
    var url = NetworkConstantsUtil.giftsCategories;

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['category'];

        resultCallback(List<GiftCategoryModel>.from(
            items.map((x) => GiftCategoryModel.fromJson(x))));
      }
    });
  }

  static getStickerGiftsByCategory(int categoryId,
      {required Function(List<GiftModel>) resultCallback}) async {
    var url = '${NetworkConstantsUtil.giftsByCategory}$categoryId';

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['gift']['items'];

        resultCallback(
            List<GiftModel>.from(items.map((x) => GiftModel.fromJson(x))));
      }
    });
  }

  static getMostUsedStickerGifts(
      {required Function(List<GiftModel>) resultCallback}) async {
    var url = NetworkConstantsUtil.mostUsedGifts;

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        var items = result!.data['gift']['items'];

        resultCallback(
            List<GiftModel>.from(items.map((x) => GiftModel.fromJson(x))));
      }
    });
  }

  static sendStickerGift(
      {required GiftModel gift,
      required int? liveId,
      required int? postId,
      required int receiverId,
      required VoidCallback resultCallback}) async {
    var url = NetworkConstantsUtil.sendGift;

    dynamic param = await ApiParamModel().sendGiftParam(
        giftId: gift.id,
        receiverId: receiverId,
        liveId: liveId,
        postId: postId,
        source: liveId != null
            ? 1
            : postId != null
                ? 3
                : 2);

    ApiWrapper().postApi(url: url, param: param).then((result) {
      if (result?.success == true) {
        resultCallback();
      }
    });
  }

  static getTimelineReceivedTextGifts(
      {required int page,
      required int sendOnType,
      required int postId,
      required Function(List<TimelineGift>, APIMetaData)
          resultCallback}) async {
    var url = NetworkConstantsUtil.postGifts;

    url = url.replaceAll('{{send_on_type}}', sendOnType.toString());
    url = url.replaceAll('{{post_id}}', postId.toString());

    url = '$url&page=$page';

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        List items = result!.data['timeline_gift']['items'];

        resultCallback(items.map((e) => TimelineGift.fromJson(e)).toList(),
            APIMetaData.fromJson(result.data['timeline_gift']['_meta']));
      }
    });
  }

  static getTimelineTextGifts(
      {required int page,
      required Function(List<PostGiftModel>, APIMetaData)
          resultCallback}) async {
    var url = NetworkConstantsUtil.timelineGifts;
    url = '$url?page=$page';

    ApiWrapper().getApi(url: url).then((result) {
      if (result?.success == true) {
        final timelineGiftData = result!.data['timelineGift']['items'];
        resultCallback(List<PostGiftModel>.from(timelineGiftData.map((value) {
          final postGift = PostGiftModel.fromJson(value);
          return postGift;
        })), APIMetaData.fromJson(result.data['timelineGift']['_meta']));
      }
    });
  }

  static sendTimelineTextGift(
      {required PostGiftModel gift,
      required int? receiverId,
      required int? postId,
      required VoidCallback resultCallback}) async {
    var url = NetworkConstantsUtil.sendPostGifts;

    dynamic param = await ApiParamModel().sendPostGiftParam(
        giftId: gift.id!,
        receiverId: receiverId,
        sendOnType: 3,
        postType: 2,
        postId: postId);

    ApiWrapper().postApi(url: url, param: param).then((result) {
      if (result?.success == true) {
        resultCallback();
      }
    });
  }
}
