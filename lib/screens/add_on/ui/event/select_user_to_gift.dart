import 'package:foap/components/empty_states.dart';
import 'package:foap/components/shimmer_widgets.dart';
import 'package:foap/components/top_navigation_bar.dart';
import 'package:foap/components/user_card.dart';
import 'package:foap/controllers/user_network_controller.dart';
import 'package:foap/helper/common_components.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/helper/localization_strings.dart';
import 'package:foap/helper/user_profile_manager.dart';
import 'package:foap/manager/service_locator.dart';
import 'package:foap/model/user_model.dart';
import 'package:foap/util/app_config_constants.dart';
import 'package:get/get.dart';
import 'package:foap/helper/imports/event_imports.dart';
import 'package:flutter/material.dart';

import 'buy_ticket.dart';

class SelectUserToGiftEventTicket extends StatefulWidget {
  final EventModel event;
  final bool isAlreadyBooked;
  final Function(UserModel)? selectUserCallback;

  const SelectUserToGiftEventTicket(
      {Key? key,
      required this.event,
      required this.isAlreadyBooked,
      this.selectUserCallback})
      : super(key: key);

  @override
  SelectUserToGiftEventTicketState createState() =>
      SelectUserToGiftEventTicketState();
}

class SelectUserToGiftEventTicketState
    extends State<SelectUserToGiftEventTicket> {
  final UserNetworkController _userNetworkController = UserNetworkController();
  final UserProfileManager _userProfileManager = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _userNetworkController.clear();
    _userNetworkController
        .getFollowingUsers(_userProfileManager.user.value!.id);
  }

  @override
  void didUpdateWidget(covariant SelectUserToGiftEventTicket oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _userNetworkController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        body: Column(
          children: [

            backNavigationBar(title: selectUserString.tr),
            divider().tP8,
            Expanded(
              child: GetBuilder<UserNetworkController>(
                  init: _userNetworkController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_userNetworkController.isLoading.value) {
                          _userNetworkController.getFollowingUsers(
                              _userProfileManager.user.value!.id);
                        }
                      }
                    });

                    List<UserModel> usersList =
                        _userNetworkController.following;
                    return _userNetworkController.isLoading.value
                        ? const ShimmerUsers().hP16
                        : Column(
                            children: [
                              usersList.isEmpty
                                  ? noUserFound(context)
                                  : Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 50),
                                        controller: scrollController,
                                        itemCount: usersList.length,
                                        itemBuilder: (context, index) {
                                          return UserTile(
                                              profile: usersList[index],
                                              viewCallback: () {
                                                if (widget.isAlreadyBooked) {
                                                  widget.selectUserCallback!(
                                                      usersList[index]);
                                                  Get.back();
                                                } else {
                                                  Get.to(() => BuyTicket(
                                                        event: widget.event,
                                                        giftToUser:
                                                            usersList[index],
                                                      ));
                                                }
                                              });
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 20,
                                          );
                                        },
                                      ).hP16,
                                    ),
                            ],
                          );
                  }),
            ),
          ],
        ));
  }
}
