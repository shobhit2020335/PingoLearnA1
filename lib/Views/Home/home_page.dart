import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/Constants/app_const.dart';
import 'package:pingolearn_assignment/Constants/constant_widgets.dart';
import 'package:pingolearn_assignment/Constants/progress_bar.dart';
import 'package:pingolearn_assignment/Models/comment_model.dart';
import 'package:provider/provider.dart';

import '../../Providers/comment_provider.dart';
import '../../Providers/remote_cofig_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteConfigProvider = Provider.of<RemoteConfigProvider>(context);
    final commentsProvider = Provider.of<CommentProvider>(context);
    remoteConfigProvider.fetchRemoteConfig();
    commentsProvider.fetchComments(context);

    bool isAllDataFetched = remoteConfigProvider.isMaskEmailFetched &&
        commentsProvider.isDataFetched;

    return Scaffold(
      drawer: ConstantWidgets.navDrawer(context),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          },
        ),
        title: Text(
          'Comments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConst.white,
            fontFamily: AppConst.poppins,
          ),
        ),
        backgroundColor: AppConst.blue,
      ),
      body: !isAllDataFetched
          ? Progressbar()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: commentsProvider.comments.length,
                    itemBuilder: (context, index) {
                      CommentModel comment = commentsProvider.comments[index];
                      return listCard(comment, remoteConfigProvider);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String maskEmail(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex > 3) {
      return email.substring(0, 3) + '****' + email.substring(atIndex);
    } else {
      return email;
    }
  }

  Widget listCard(
      CommentModel comment, RemoteConfigProvider remoteConfigProvider) {
    print(' masked emails is ${remoteConfigProvider.maskEmail}');
    String displayEmail = comment.email;
    if (comment.email == remoteConfigProvider.maskEmail) {
      displayEmail = maskEmail(comment.email);
    }

    return Container(
      margin: EdgeInsets.only(top: 16, right: 16, left: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConst.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: AppConst.darkGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    comment.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppConst.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ',
                        maxLines: 1,
                        style: AppStyles.defaultTextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: AppConst.darkGrey)),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        comment.name,
                        style: TextStyle(
                            color: AppConst.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ',
                        style: AppStyles.defaultTextStyle(
                          fontSize: 14,
                          color: AppConst.darkGrey,
                          fontStyle: FontStyle.italic,
                        )),
                    Expanded(
                      child: Text(
                        displayEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.defaultTextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppConst.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(comment.body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.defaultTextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppConst.black)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
