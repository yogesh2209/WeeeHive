//
//  Constant.h
//  WeeeHive
//
//  Created by Schoofi on 16/10/15.
//  Copyright © 2015 Schoofi. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "AppDelegate.h"

//temp url for me : schoofi.com/weehieve/yogesh/

#define MAIN_URL                    @"http://weeehive.com/"
#define POST_LOGIN                  @"json-wh-login.php"
#define POST_REG                    @"json-wh-reg.php"
#define POST_STATES                 @"json-wh-states.php"
#define POST_TYPES                  @"json-wh-type.php"
#define POST_EDITPROFILE            @"json-wh-edit-profile.php"
#define POST_UPDATEPROFILE          @"json-wh-update-profile.php"
#define POST_STATUS                 @"json-wh-status.php"
#define POST_PROFILE                @"json-wh-profile.php"
#define POST_USERREQUEST            @"json-wh-neg-req.php"
#define POST_NEGKNOWLIST            @"json-wh-neg-know.php"
#define POST_YOURNEGHBOR            @"json-wh-your-neg.php"
#define POST_NEGHTIMES              @"json-wh-negtimes.php"
#define POST_NEGTIMESPOSTCOMMENT    @"json-wh-neg-post-cmnt.php"
#define POST_NEGHTIMESADDCOMMENT    @"json-wh-neg-add-cmnt.php"
#define POST_CONTACTUS              @"json-wh-contact-us.php"
#define POST_COUPONS                @"json-wh-flycoupon.php"
#define POST_POLLLIST               @"json-wh-poll.php"
#define POST_POLLACTION             @"json-wh-poll-action.php"
#define POST_POLLACTION2            @"json-wh-poll-action2.php"
#define POST_SUBMITTEDPOLLS         @"json-wh-sub-poll.php"
#define POSTNEGHTIMESCOMMENT        @"json-wh-neg-add-cmnt.php"
#define POST_WEEGROUPMSGS           @"json-wh-group-msgs.php"
#define POST_WEEGROUPMSGADD         @"json-wh-group-addmsg.php"
#define POST_UPLOADCOUPON           @"json-wh-upload-coupon.php"
#define POST_GENDER                 @"json-wh-reg-gender.php"
#define POST_YOURWEEHIVE            @"json-wh-yourweehive.php"
#define POST_EXITGROUP              @"json-wh-exit-group.php"
#define POST_IMAGEURL               @"json-wh-imageurl.php"
#define POST_CITY                   @"json-wh-city.php"
#define POST_CITYNEGHBOUR           @"json-wh-city-neg.php"
#define POST_LOCALITY               @"json-wh-city-neg-loc.php"
#define POST_HELPIN                 @"json-wh-helpin.php"
#define POST_RATING                 @"json-wh-rating.php"
#define POST_ADDFRIENDSGROUP        @"json-wh-add-grp-members.php"
#define POST_NEGHFRIENDSLIST        @"json-wh-neg-friends.php"
#define POST_GROUPNOTWEEHIVE        @"json-wh-not-weehive.php"
#define POST_GROUPMEMBERS           @"json-wh-group-members.php"
#define POST_ADDGROUP               @"json-wh-add-group.php"
#define POST_GROUPCHATLIST          @"json-wh-group-msgs.php"
#define POST_ADDMSGGROUP            @"json-wh-group-addmsg.php"
#define POST_FREINDTOADDGROUP       @"json-wh-friends-toadd-group.php"
#define POST_LOGOUT                 @"json-wh-logout.php"
#define POST_FORGOTPASS1            @"json-wh-changepass.php"
#define POST_UPDATEPASSWORD         @"json-changepass1.php"
#define POST_ADDMESSAGENEGHCHAT     @"json-wh-add-neg-chat.php"
#define POST_NEGHBOURCHAT           @"json-wh-neg-chat.php"
#define POST_SCHOOLLIST             @"json-wh-school.php"
#define POST_ADDPOLL                @"json-wh-add-poll.php"
#define POST_ADDNEGHTIMESTWEET      @"json-wh-add-neg-times-tweet.php"
#define POST_EDITCREDENTIALS        @"json-wh-edit-credential.php"
#define POST_USERSTATUS             @"json-wh-user-status.php"
#define POST_ADDGROUPDEFAULT        @"json-wh-add-group-members-default.php"
#define POST_FRIENDSLISTTOADDGROUP  @"json-wh-add-friends.php"
#define POST_PUSHNOTIFICATIONLIST   @"json-wh-notifications-list.php"

#define POST_UPDATEADDRESS          @"json-wh-update-add.php"
#define POST_ADDRESS                @"json-wh-address.php"

#define POST_PUSHBADGE              @"json-wh-badge.php"

//resend verification code service
#define POST_RESENDCODE             @"json-wh-req-verification-code.php"


//Filters
#define POST_FILTERHELP_IN_AS         @"json-wh-list-helpin.php"
#define POST_FILTEREDHELP_IN          @"json-wh-fl-filtered-helpin.php"
#define POST_FILTERED_NEGHTIMES       @"json-wh-filtered-negtime.php"
#define POST_SORTED_NEGHTIMES         @"json-wh-sort-negtimes.php"
#define POST_FILTEREDNEGHKNOW         @"json-wh-filtered-neg-know.php"
#define POST_FILTEREDWEEHIVE          @"json-wh-filtered-your-weehive.php"
#define POST_ADDMEMBERSFILTER         @"json-wh-add-group-member-filter.php"  

//Push Screens
#define POST_FRIENDREQUESTS           @"json-wh-friend-requests.php"
#define POST_ACTIONREQUEST            @"json-wh-action-friend-request.php"  
#define POST_MESSAGESLIST             @"json-wh-messages.php"
#define POST_ACTIONGROUPREQUEST       @"json-wh-action-group-request.php"
#define POST_GROUPREQUEST             @"json-wh-group-requests.php"
#define POST_SENDGROUPREQUEST         @"json-wh-send-group-request.php"


//URLs for Terms, Privacy policy, about and help.
#define WHTERMS                     @"http://schoofi.com/weehieve/yogesh/terms.docx"
#define WHPRIVACY                   @"http://schoofi.com/weehieve/yogesh/privacy.docx"
#define WHABOUT                     @"http://schoofi.com/weehieve/yogesh/about.docx"
#define WHHELP                      @"http://schoofi.com/weehieve/yogesh/help.docx"



//TableViewCells
#define WHNEGLIKEKNOW_CELL          @"negKnowCustomCell"
#define WHNEGKNOWDETAILS_CELL       @"negKnowDetailsCustomCell"
#define WHYOURNEG_CELL              @"yourNegCustomCell"
#define WHNEGHDETAILS_CELL          @"yourNeghDetailsCustomCell"
#define WHCOUPONS_CELL              @"couponCustomCell"
#define WHSETTINGS_CELL             @"settingsCustomCell"
#define WHABOUTUS_CELL              @"aboutUsCustomCell"
#define WHPLAIN_CELL                @"plainCell"
#define WHHELP_CELL                 @"helpInCustomCell"
#define WHHELPFILTER_CELL           @"helpInAsCustomCell"
#define WHHELPDETAILS_CELL          @"helpInDetailsCustomCell"
#define WHWEEHIVEGROUP_CELL         @"weehiveGroupCustomCell"
#define WHNEGHTIMESCOMMENTS_CELL    @"neghTimesCommentCustomCell"
#define WHPOLL_CELL                 @"pollListCustomCell"
#define WHSUBMITTEDPOLL_CELL        @"submitedListCustomCell"
#define WHYOURWEEHIVE_CELL          @"weehiveGroupCustomCell"
#define WHWEEHIVEGROUPMEMBERS_CELL  @"membersCustomCell"
#define WHMEMBERPROFILE_CELL        @"memberProfileCustomCell"
#define WHGROUPCHAT_CELL            @"chatCustomCell"
#define WHCOUPONTEXT_CELL           @"couponTextOnlyCustomCell"
#define WHFRIENDLIST_CELL           @"friendListCustomCell"
#define WHNEGHFRIENDS_CELL          @"neghFriendsCustomCell"
#define WHNEGHFRIENDSPROFILE_CELL   @"neghFriendsProfileCustomCell"
#define WHMESSAGES_CELL             @"messagesCustomCell"
#define POST_REQUESTSCELL           @"requestCustomCell"
#define POST_GROUPREQUESTCELL       @"groupRequestsCustomCell"
#define POST_NOTIFICATIONLISTCELL   @"notificationCustomCell"

//CollectionView Cells
#define WHNEGHTIMES_CELL            @"negTimesCustomCell"
#define WHNEGHTIMES_IMAGE_CELL      @"neghTimesImageCustomCell"



#define GREEN_COLOR           [UIColor colorWithRed:5.0f/255.0f green:122.0f/255.0f blue:0.0f/255.0f alpha:1.0]

#define ORANGE_COLOR(xx)   [UIColor colorWithRed:255.0f/255.0f green:84.0f/255.0f blue:62.0f/255.0f alpha:xx]












#endif /* Constant_h */
