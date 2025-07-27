import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

class L10nHelper {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  // Helper methods for common translations
  static String getWelcome(BuildContext context) => of(context).get('welcome');
  static String getLogin(BuildContext context) => of(context).get('login');
  static String getRegister(BuildContext context) =>
      of(context).get('register');
  static String getEmail(BuildContext context) => of(context).get('email');
  static String getPassword(BuildContext context) =>
      of(context).get('password');
  static String getUsername(BuildContext context) =>
      of(context).get('username');
  static String getDashboard(BuildContext context) =>
      of(context).get('dashboard');
  static String getSchedule(BuildContext context) =>
      of(context).get('schedule');
  static String getStudy(BuildContext context) => of(context).get('study');
  static String getDocuments(BuildContext context) =>
      of(context).get('documents');
  static String getGroups(BuildContext context) => of(context).get('groups');
  static String getProfile(BuildContext context) => of(context).get('profile');
  static String getSettings(BuildContext context) =>
      of(context).get('settings');
  static String getLanguage(BuildContext context) =>
      of(context).get('language');
  static String getTheme(BuildContext context) => of(context).get('theme');
  static String getNotifications(BuildContext context) =>
      of(context).get('notifications');
  static String getSave(BuildContext context) => of(context).get('save');
  static String getCancel(BuildContext context) => of(context).get('cancel');
  static String getDelete(BuildContext context) => of(context).get('delete');
  static String getSearch(BuildContext context) => of(context).get('search');
  static String getLoading(BuildContext context) => of(context).get('loading');
  static String getError(BuildContext context) => of(context).get('error');
  static String getSuccess(BuildContext context) => of(context).get('success');
  static String getConfirm(BuildContext context) => of(context).get('confirm');
  static String getYes(BuildContext context) => of(context).get('yes');
  static String getNo(BuildContext context) => of(context).get('no');
  static String getOk(BuildContext context) => of(context).get('ok');
  static String getClose(BuildContext context) => of(context).get('close');
  static String getBack(BuildContext context) => of(context).get('back');
  static String getNext(BuildContext context) => of(context).get('next');
  static String getPrevious(BuildContext context) =>
      of(context).get('previous');
  static String getRefresh(BuildContext context) => of(context).get('refresh');
  static String getRetry(BuildContext context) => of(context).get('retry');
  static String getNoData(BuildContext context) => of(context).get('noData');
  static String getNoInternet(BuildContext context) =>
      of(context).get('noInternet');
  static String getTryAgain(BuildContext context) =>
      of(context).get('tryAgain');
}
