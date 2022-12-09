import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class TvStreamingController extends GetxController {
  RxInt currentPage = 0.obs;
  RxMap<String, List<ChatMessageModel>> messagesMap =
      <String, List<ChatMessageModel>>{}.obs;

  RxBool showChatMessages = false.obs;
  RxList<TvModel> banners = <TvModel>[].obs;
  RxList<TvModel> liveTvs = <TvModel>[].obs;
  RxList<TvCategoryModel> categories = <TvCategoryModel>[].obs;
  RxInt currentBannerIndex = 0.obs;

  clearCategories() {
    categories.clear();
    update();
  }

  clearTvs() {
    liveTvs.clear();
    update();
  }

  updateBannerSlider(int index) {
    currentBannerIndex.value = index;
  }

  getTvCategories() {
    ApiController().getTVCategories().then((response) {
      categories.value = response.tvCategories
          .where((element) => element.tvs.isNotEmpty)
          .toList();
      categories.refresh();
      update();
    });
  }

  getBannersTvs({int? categoryId, String? name}) {
    ApiController()
        .getLiveTvs(categoryId: categoryId, name: name)
        .then((response) {
      banners.value = response.liveTvs;
      update();
    });
  }

  getLiveTvs({int? categoryId, String? name}) {
    ApiController()
        .getLiveTvs(categoryId: categoryId, name: name)
        .then((response) {
      liveTvs.value = response.liveTvs;
      update();
    });
  }

  subscribeTv(TvModel tvModel, Function(bool) completionCallBack) {
    if (getIt<UserProfileManager>().user!.coins >=
        tvModel.coinsNeededToUnlock) {
      ApiController().subscribeTv(tvModel: tvModel).then((response) {
        completionCallBack(response.success);
      });
    } else {
      Get.to(() => const PackagesScreen());
    }
  }

  stopWatchingTv(TvModel tvModel, Function(bool) completionCallBack) {
    ApiController().stopWatchingTv(tvModel: tvModel).then((response) {
      completionCallBack(response.success);
    });
  }

  joinTv(int id) {
    var liveTvId = 'tv_$id';

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveTvId': liveTvId,
    };

    getIt<SocketManager>().emit(SocketConstants.joinLiveTv, message);
  }

  hideMessagesView() {
    showChatMessages.value = false;
    showChatMessages.refresh();
  }

  showMessagesView() {
    showChatMessages.value = true;
    showChatMessages.refresh();
  }

  currentPageChanged(int index) {
    currentPage.value = index;
    currentPage.refresh();
  }

  newMessageReceived(ChatMessageModel message) {
    addNewMessage(message, int.parse(message.liveTvId.split('_').last));
  }

  sendTextMessage(String messageText, int id) {
    String localMessageId = randomId();
    var liveTvId = 'tv_$id';

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveTvId': liveTvId,
      'local_message_id': localMessageId,
      'messageType': messageTypeId(MessageContentType.text),
      'message': messageText,
      'picture': getIt<UserProfileManager>().user!.picture,
      'username': getIt<UserProfileManager>().user!.userName,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    getIt<SocketManager>().emit(SocketConstants.sendMessageInLiveTv, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = id;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.text);
    localMessageModel.messageContent = messageText;

    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(localMessageModel, id);
  }

  addNewMessage(ChatMessageModel message, int tvId) {
    List<ChatMessageModel> messages = (messagesMap[tvId.toString()] ?? []);

    messages.add(message);
    messagesMap[tvId.toString()] = messages;
    messagesMap.refresh();
    update();
  }
}