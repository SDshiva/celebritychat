import 'dart:developer';
import 'package:foap/helper/common_import.dart';
import 'package:foap/model/podcast_banner_model.dart';
import 'package:get/get.dart';
import '../model/club_invitation.dart';
import '../model/club_join_request.dart';
import '../model/faq_model.dart';
import '../model/get_relationship_model.dart';
import '../model/myRelations/my_invitation_model.dart';
import '../model/myRelations/my_relations_model.dart';
import '../model/podcast_model.dart';
import '../model/tv_banner_model.dart';
import '../model/tv_show_model.dart';
import '../model/polls_model.dart';

class ApiResponseModel {
  bool success = true;
  String message = "";
  bool isInvalidLogin = true;
  String? authKey;
  String? postedMediaFileName;
  String? postedMediaCompletePath;
  String? token;

  UserModel? user;
  CompetitionModel? competition;
  int highlightId = 0;
  int createdPostId = 0;

  List<CompetitionModel> competitions = [];
  List<PostModel> posts = [];
  List<PollsQuestionModel> polls = [];
  List<StoryModel> stories = [];
  List<StoryMediaModel> myActiveStories = [];
  List<StoryMediaModel> myStories = [];
  List<CommentModel> comments = [];
  List<PackageModel> packages = [];
  List<CountryModel> countries = [];
  List<PaymentModel> payments = [];
  List<UserModel> topUsers = [];
  List<UserModel> users = [];
  List<UserModel> randomLives = [];
  List<UserModel> randomOnlineUsers = [];

  List<UserModel> blockedUsers = [];
  List<CallHistoryModel> callHistory = [];
  List<UserModel> liveUsers = [];
  List<GiftCategoryModel> giftCategories = [];
  List<GiftModel> gifts = [];
  List<ReceivedGiftModel> giftReceived = [];

  List<NotificationModel> notifications = [];
  List<SupportRequestModel> supportMessages = [];
  List<Hashtag> hashtags = [];
  List<HighlightsModel> highlights = [];

  List<ClubModel> clubs = [];
  List<ClubInvitation> clubInvitations = [];
  List<ClubJoinRequest> clubJoinRequests = [];

  List<CategoryModel> categories = [];
  List<ClubMemberModel> clubMembers = [];
  int? clubId;

  List<EventModel> events = [];
  List<EventMemberModel> eventMembers = [];
  List<EventCategoryModel> eventCategories = [];
  List<EventCoupon> eventCoupons = [];
  List<EventBookingModel> eventBookings = [];
  int? bookingId;

  List<TvCategoryModel> tvCategories = [];
  List<TvModel> liveTvs = [];
  List<TVShowModel> tvShows = [];
  List<TVBannersModel> tvBanners = [];
  List<TVShowEpisodeModel> tvEpisodes = [];
  List<LiveModel> lives = [];

  List<PodcastBannerModel> podcastBanners = [];
  List<PodcastCategoryModel> podcastCategories = [];
  List<PodcastModel> podcasts = [];
  List<PodcastShowModel> podcastShows = [];
  List<PodcastShowSongModel> podcastShowSongs = [];
  List<ReelMusicModel> audios = [];

  List<GetRelationshipModel> relationships = [];
  List<MyRelationsModel> myRelationships = [];
  List<MyInvitationsModel> myInvitations = [];
  List<MyRelationsModel>relationshipsById= [];

  List<VerificationRequest> verificationRequests = [];

  //FAQ
  List<FAQModel> faqs = [];

  // chat
  List<ChatRoomModel> chatRooms = [];
  List<ChatMessageModel> messages = [];

  ChatRoomModel? room;

  APIMetaData? metaData;
  SettingModel? settings;
  PostModel? post;
  EventModel? event;

  int roomId = 0;
  String? stripePaymentIntentClientSecret;
  String? paypalClientToken;
  String? transactionId;

  ApiResponseModel();

  factory ApiResponseModel.fromJson(dynamic json, String url) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];
    model.isInvalidLogin = json['isInvalidLogin'] == null ? false : true;

    log(json.toString());
    // log(url);

    if (model.success) {
      model.message = json['message'];
      if (data != null && data.length > 0) {
        if (data['user'] != null) {
          if (url == NetworkConstantsUtil.getMyProfile ||
              url == NetworkConstantsUtil.otherUser) {
            model.user = UserModel.fromJson(data['user']);
          }
          if (url == NetworkConstantsUtil.randomLives) {
            var items = data['user']['items'];

            model.randomLives =
                List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            model.metaData = APIMetaData.fromJson(data['user']['_meta']);
          }
          if (url == NetworkConstantsUtil.randomOnlineUser) {
            var items = data['user'];

            model.randomOnlineUsers =
                List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            // model.metaData = APIMetaData.fromJson(data['user']['_meta']);
          }
          if (data['auth_key'] != null) {
            model.authKey = data['auth_key'];
            //AppConfigConstants.userId = model.user!.id;
          }
        } else if (data['competition'] != null) {
          if (url == NetworkConstantsUtil.getCompetitions) {
            var items = data['competition']['items'];

            if (items != null && items.length > 0) {
              model.competitions = List<CompetitionModel>.from(
                  items.map((x) => CompetitionModel.fromJson(x)));
              model.metaData =
                  APIMetaData.fromJson(data['competition']['_meta']);
            }
          } else if (data['competition'] != null) {
            model.competition = CompetitionModel.fromJson(data['competition']);
          }
        } else if (data['verification'] != null) {
          var items = data['verification']['items'];

          model.verificationRequests = List<VerificationRequest>.from(
              items.map((x) => VerificationRequest.fromJson(x)));
        } else if (data['results'] != null) {
          var items = data['results'];
          if (items != null && items.length > 0) {
            model.hashtags =
                List<Hashtag>.from(items.map((x) => Hashtag.fromJson(x)));
          }
        } else if (data['id'] != null) {
          if (url == NetworkConstantsUtil.buyTicket) {
            model.bookingId = data['id'];
          }
        } else if (data['client_secret'] != null) {
          model.stripePaymentIntentClientSecret = data['client_secret'];
        } else if (data['client_token'] != null) {
          model.paypalClientToken = data['client_token'];
        } else if (data['payment_id'] != null) {
          model.transactionId = data['payment_id'];
        } else if (data['club'] != null) {
          var items = data['club']['items'];
          if (items != null && items.length > 0) {
            model.clubs =
                List<ClubModel>.from(items.map((x) => ClubModel.fromJson(x)));
            model.metaData = APIMetaData.fromJson(data['club']['_meta']);
          }
        } else if (data['invitation'] != null && url == NetworkConstantsUtil.clubJoinInvites) {
          var items = data['invitation']['items'];
          if (items != null && items.length > 0) {
            model.clubInvitations = List<ClubInvitation>.from(
                items.map((x) => ClubInvitation.fromJson(x)));
            model.metaData = APIMetaData.fromJson(data['invitation']['_meta']);
          }
        } else if (data['join_request'] != null) {
          var items = data['join_request']['items'];
          if (items != null && items.length > 0) {
            model.clubJoinRequests = List<ClubJoinRequest>.from(
                items.map((x) => ClubJoinRequest.fromJson(x)));
            model.metaData =
                APIMetaData.fromJson(data['join_request']['_meta']);
          }
        } else if (data['club_id'] != null) {
          model.clubId = data['club_id'];
        } else if (data['audio'] != null) {
          var items = data['audio']['items'];
          if (items != null && items.length > 0) {
            model.audios = List<ReelMusicModel>.from(
                items.map((x) => ReelMusicModel.fromJson(x)));
            model.metaData = APIMetaData.fromJson(data['audio']['_meta']);
          }
        } else if (data['userList'] != null) {
          var items = data['userList']['items'];
          if (items != null && items.length > 0) {
            model.clubMembers = List<ClubMemberModel>.from(
                items.map((x) => ClubMemberModel.fromJson(x)));
            model.metaData = APIMetaData.fromJson(data['userList']['_meta']);
          }
        } else if (data['live_tv'] != null) {
          var items = data['live_tv']['items'];
          if (items != null && items.length > 0) {
            model.liveTvs =
                List<TvModel>.from(items.map((x) => TvModel.fromJson(x)));
          }
        } else if (data['live_history'] != null) {
          var items = data['live_history']['items'];
          if (items != null && items.length > 0) {
            model.lives =
                List<LiveModel>.from(items.map((x) => LiveModel.fromJson(x)));
          }
        } else if (data['notification'] != null) {
          var items = data['notification']['items'];
          if (items != null && items.length > 0) {
            model.notifications = List<NotificationModel>.from(
                items.map((x) => NotificationModel.fromJson(x)));
          }
          model.metaData = APIMetaData.fromJson(data['notification']['_meta']);
        } else if (data['highlight'] != null) {
          var items = data['highlight'];
          if (items != null && items.length > 0) {
            model.highlights = List<HighlightsModel>.from(
                items.map((x) => HighlightsModel.fromJson(x)));
          }
        } else if (data['event'] != null) {
          if (url == NetworkConstantsUtil.eventDetails) {
            model.event = EventModel.fromJson(data['event']);
          } else {
            var items = data['event']['items'];
            if (items != null && items.length > 0) {
              model.events = List<EventModel>.from(
                  items.map((x) => EventModel.fromJson(x)));
            }
          }
        } else if (data['eventBooking'] != null) {
          var items = data['eventBooking']['items'];
          if (items != null && items.length > 0) {
            model.eventBookings = List<EventBookingModel>.from(
                items.map((x) => EventBookingModel.fromJson(x)));
            model.metaData =
                APIMetaData.fromJson(data['eventBooking']['_meta']);
          }
        } else if (data['category'] != null) {
          var items = data['category'];

          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getTVCategories) {
              model.tvCategories = List<TvCategoryModel>.from(
                  items.map((x) => TvCategoryModel.fromJson(x)));
            } else if (url == NetworkConstantsUtil.getPodcastCategories) {
              model.podcastCategories = List<PodcastCategoryModel>.from(
                  items.map((x) => PodcastCategoryModel.fromJson(x)));
            } else if (url == NetworkConstantsUtil.giftsCategories) {
              model.giftCategories = List<GiftCategoryModel>.from(
                  items.map((x) => GiftCategoryModel.fromJson(x)));
            }
            if (url == NetworkConstantsUtil.eventsCategories) {
              model.eventCategories = List<EventCategoryModel>.from(
                  items.map((x) => EventCategoryModel.fromJson(x)));
            } else {
              model.categories = List<CategoryModel>.from(
                  items.map((x) => CategoryModel.fromJson(x)));
            }
          }
        } else if (data['tv_show'] != null) {
          var tvShows = data['tv_show'];
          var items = tvShows['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getTVShows) {
              model.tvShows = List<TVShowModel>.from(
                  items.map((x) => TVShowModel.fromJson(x)));
            }
          }
        } else if (data['tv_banner'] != null) {
          var tvBanners = data['tv_banner'];
          var items = tvBanners['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.tvBanners) {
              model.tvBanners = List<TVBannersModel>.from(
                  items.map((x) => TVBannersModel.fromJson(x)));
            }
          }
        } else if (data['tvShowEpisode'] != null) {
          var tvShowEpisode = data['tvShowEpisode'];
          var items = tvShowEpisode['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getTVShowEpisodes) {
              model.tvEpisodes = List<TVShowEpisodeModel>.from(
                  items.map((x) => TVShowEpisodeModel.fromJson(x)));
            }
          }
        } else if (data['podcast_banner'] != null) {
          var podcastBanners = data['podcast_banner'];
          var items = podcastBanners['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.podcastBanners) {
              model.podcastBanners = List<PodcastBannerModel>.from(
                  items.map((x) => PodcastBannerModel.fromJson(x)));
            }
          }
        } else if (data['podcast'] != null) {
          var podcasts = data['podcast'];
          var items = podcasts['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getHosts) {
              model.podcasts = List<PodcastModel>.from(
                  items.map((x) => PodcastModel.fromJson(x)));
            }
          }
        } else if (data['podcast_show'] != null) {
          var podcasts = data['podcast_show'];
          var items = podcasts['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getPodcastShows) {
              model.podcastShows = List<PodcastShowModel>.from(
                  items.map((x) => PodcastShowModel.fromJson(x)));
            }
          }
        } else if (data['podcastShowEpisode'] != null) {
          var showEpisodes = data['podcastShowEpisode'];
          var items = showEpisodes['items'];
          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getPodcastShowsEpisode) {
              model.podcastShowSongs = List<PodcastShowSongModel>.from(
                  items.map((x) => PodcastShowSongModel.fromJson(x)));
            }
          }
        } else if (data['coupon'] != null) {
          var items = data['coupon'];

          if (items != null && items.length > 0) {
            model.eventCoupons = List<EventCoupon>.from(
                items.map((x) => EventCoupon.fromJson(x)));
          }
        } else if (data['gift'] != null) {
          var items = data['gift']['items'];

          if (url == NetworkConstantsUtil.giftsReceived) {
            if (items != null && items.length > 0) {
              model.giftReceived = List<ReceivedGiftModel>.from(
                  items.map((x) => ReceivedGiftModel.fromJson(x)));
            }
          } else {
            if (items != null && items.length > 0) {
              model.gifts =
                  List<GiftModel>.from(items.map((x) => GiftModel.fromJson(x)));
            }
          }
        } else if (data['supportRequest'] != null) {
          var items = data['supportRequest']['items'];
          if (items != null && items.length > 0) {
            model.supportMessages = List<SupportRequestModel>.from(
                items.map((x) => SupportRequestModel.fromJson(x)));
          }
        } else if (data['follower'] != null) {
          if (url == NetworkConstantsUtil.followers) {
            var items = (data['follower']['items'] as List<dynamic>)
                .map((e) => e['followerUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.users =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
          }
        } else if (data['following'] != null) {
          if (url == NetworkConstantsUtil.following) {
            var items = (data['following']['items'] as List<dynamic>)
                .where((element) => element['followingUserDetail'] != null)
                .map((e) => e['followingUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.users =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
            if (data['following']['_meta'] != null) {
              model.metaData = APIMetaData.fromJson(data['following']['_meta']);
            }
          } else {
            var items = (data['following'] as List<dynamic>)
                .map((e) => e['followingUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.liveUsers =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
          }
        } else if (data['topUser'] != null || data['topWinner'] != null) {
          var topUsers = data['topUser'];

          if (topUsers != null && topUsers.length > 0) {
            model.topUsers = List<UserModel>.from(
                topUsers.map((x) => UserModel.fromJson(x)));
          }

          // if (topWinners != null && topWinners.length > 0) {
          //   model.topWinners = List<UserModel>.from(
          //       topWinners.map((x) => UserModel.fromJson(x)));
          // }
        } else if (data['blockedUser'] != null) {
          var blockedUser = data['blockedUser'];

          if (blockedUser != null && blockedUser.length > 0) {
            var items = (data['blockedUser'] as List<dynamic>)
                .where((element) => element['blockedUserDetail'] != null)
                .map((e) => e['blockedUserDetail'])
                .toList();

            model.blockedUsers =
                List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            // model.metaData = APIMetaData.fromJson(data['blockedUser']['_meta']);
          }
        } else if (data['token'] != null) {
          model.token = data['token'] as String;
        } else if (data['verify_token'] != null) {
          model.token = data['verify_token'] as String;
        } else if (data['filename'] != null) {
          model.postedMediaFileName = data['filename'] as String;
        } else if (data['files'] != null) {
          var items = data['files'] as List<dynamic>;

          model.postedMediaFileName = items.first['file'];
          model.postedMediaCompletePath = items.first['fileUrl'];
        } else if (data['story'] != null) {
          if (url == NetworkConstantsUtil.myStories) {
            model.myStories = [];
            var items = data['story']['items'];
            if (items != null && items.length > 0) {
              model.myStories = List<StoryMediaModel>.from(
                  items.map((x) => StoryMediaModel.fromJson(x)));
            }
          } else if (url == NetworkConstantsUtil.myCurrentActiveStories) {
            model.myActiveStories = [];
            var items = data['story']['items'];
            if (items != null && items.length > 0) {
              model.myActiveStories = List<StoryMediaModel>.from(
                  items.map((x) => StoryMediaModel.fromJson(x)));
            }
          } else if (url == NetworkConstantsUtil.stories) {
            model.stories = [];
            var items = data['story'];
            if (items != null && items.length > 0) {
              model.stories = List<StoryModel>.from(
                  items.map((x) => StoryModel.fromJson(x)));
            }
          }
        } else if (data['post_id'] != null) {
          model.createdPostId = data['post_id'] as int;
        } else if (data['post'] != null) {
          if (url == NetworkConstantsUtil.postDetail) {
            var post = data['post'];

            if (post != null) {
              model.post = PostModel.fromJson(post);
            }
          } else {
            model.posts = [];
            var items = data['post']['items'];
            if (items != null && items.length > 0) {
              model.posts =
                  List<PostModel>.from(items.map((x) => PostModel.fromJson(x)))
                      .where((element) => element.gallery.isNotEmpty)
                      .toList();
            }

            model.metaData = APIMetaData.fromJson(data['post']['_meta']);
          }
        } else if (url == NetworkConstantsUtil.getPolls) {
          model.polls = [];
          var items = data['pollQuestion']['items'];
          if (items != null && items.length > 0) {
            model.polls = List<PollsQuestionModel>.from(
                items.map((x) => PollsQuestionModel.fromJson(x)));
          }
        } else if (data['comment'] != null) {
          model.comments = [];
          var items = data['comment']['items'];
          if (items != null && items.length > 0) {
            model.comments = List<CommentModel>.from(
                items.map((x) => CommentModel.fromJson(x)));
          }
          model.metaData = APIMetaData.fromJson(data['comment']['_meta']);
        } else if (data['package'] != null) {
          model.packages = [];
          var packagesArr = data['package'];
          if (packagesArr != null && packagesArr.length > 0) {
            model.packages = List<PackageModel>.from(
                packagesArr.map((x) => PackageModel.fromJson(x)));
          }
        } else if (data['country'] != null && data['country'].length > 0) {
          model.countries = List<CountryModel>.from(
              data['country'].map((x) => CountryModel.fromJson(x)));
        } else if (data['payment'] != null && data['payment'].length > 0) {
          model.payments = List<PaymentModel>.from(
              data['payment'].map((x) => PaymentModel.fromJson(x)));
        } else if (data['setting'] != null) {
          var setting = data['setting'];
          model.settings = SettingModel.fromJson(setting);
        } else if (data['callHistory'] != null) {
          var callHistory = data['callHistory'];
          var items = callHistory['items'];

          model.callHistory = List<CallHistoryModel>.from(
              items.map((x) => CallHistoryModel.fromJson(x)));
          model.metaData = APIMetaData.fromJson(data['callHistory']['_meta']);
        } else if (data['room_id'] != null) {
          model.roomId = data['room_id'];
        } else if (data['room'] != null) {
          if (url == NetworkConstantsUtil.getChatRooms) {
            model.chatRooms = [];
            var room = data['room'] as List<dynamic>?;
            if (room != null && room.isNotEmpty) {
              room = room
                  .where((element) =>
                      (element['chatRoomUser'] as List<dynamic>).length > 1)
                  .toList();
              model.chatRooms = List<ChatRoomModel>.from(
                  room.map((x) => ChatRoomModel.fromJson(x)));
            }
          } else if (url == NetworkConstantsUtil.getChatRoomDetail) {
            var room = data['room'] as Map<String, dynamic>?;
            if (room != null) {
              var roomData = data['room'];
              model.room = ChatRoomModel.fromJson(roomData);
            }
          }
        } else if (data['chatMessage'] != null) {
          var items = data['chatMessage']['items'];
          if (items != null && items.length > 0) {
            model.messages = List<ChatMessageModel>.from(
                items.map((x) => ChatMessageModel.fromJson(x)));
          }
        } else if (data['faq'] != null) {
          var items = data['faq']['items'];

          if (url == NetworkConstantsUtil.getFAQs) {
            if (items != null && items.length > 0) {
              model.faqs =
                  List<FAQModel>.from(items.map((x) => FAQModel.fromJson(x)));
            }
          }
        }
        else if (data['relations'] != null) {
          var items = data['relations'];

          if (items != null && items.length > 0) {
            if (url == NetworkConstantsUtil.getRelationship) {
              model.relationships = List<GetRelationshipModel>.from(
                  items.map((x) => GetRelationshipModel.fromJson(x)));
            }
          }
        }
        else if (data['invitation'] != null && url == NetworkConstantsUtil.myRelations) {

          var items = data['invitation']['items'];
          if (items != null && items.length > 0) {
            model.myRelationships = List<MyRelationsModel>.from(
                items.map((x) => MyRelationsModel.fromJson(x)));
          }
        }
        else if (data['invitation'] != null && url == NetworkConstantsUtil.getRelationbyId) {
          var items = data['invitation'];
          if (items != null && items.length > 0) {
            model.myRelationships = List<MyRelationsModel>.from(
                items.map((x) => MyRelationsModel.fromJson(x)));
          }
        }
        else if (data['invitation'] != null && url == NetworkConstantsUtil.myInvitations) {
           var items = data['invitation']['items'];
           if (items != null && items.length > 0) {
             model.myInvitations = List<MyInvitationsModel>.from(
            items.map((x) => MyInvitationsModel.fromJson(x)));
           }
        }
      }
    } else {
      if (data == null) {
        Timer(const Duration(seconds: 1), () {
          Get.to(() => const LoginScreen());
        });
      } else if (data['token'] != null) {
        model.token = data['token'] as String;
      } else if (data['errors'] != null) {
        Map errors = data['errors'];
        var errorsArr = errors[errors.keys.first] ?? [];
        String error = errorsArr.first ?? LocalizationString.errorMessage;
        model.message = error;
      } else {
        Timer.periodic(const Duration(seconds: 1), (timer) {
          Get.to(() => const LoginScreen());
        });
      }
    }
    return model;
  }

  factory ApiResponseModel.fromUsersJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];

    if (model.success) {
      model.message = json['message'];
      if (data != null && data.length > 0) {
        if (data['user'] != null && data['user'].length > 0) {
          model.users = List<UserModel>.from(
              data['user'].map((x) => UserModel.fromJson(x)));
        }
      }
    } else {
      Map errors = data['errors'];
      var errorsArr = errors[errors.keys.first] ?? [];
      String error = errorsArr.first ?? LocalizationString.errorMessage;
      model.message = error;
    }
    return model;
  }

  factory ApiResponseModel.fromErrorJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = false;
    model.message = json['message'];
    return model;
  }
}
