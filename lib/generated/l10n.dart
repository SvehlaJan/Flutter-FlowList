// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get app_name {
    return Intl.message(
      'Flow List',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  String get general_submit {
    return Intl.message(
      'Submit',
      name: 'general_submit',
      desc: '',
      args: [],
    );
  }

  String get general_add {
    return Intl.message(
      'Add',
      name: 'general_add',
      desc: '',
      args: [],
    );
  }

  String get general_delete {
    return Intl.message(
      'Delete',
      name: 'general_delete',
      desc: '',
      args: [],
    );
  }

  String get general_cancel {
    return Intl.message(
      'Cancel',
      name: 'general_cancel',
      desc: '',
      args: [],
    );
  }

  String get general_email {
    return Intl.message(
      'Email',
      name: 'general_email',
      desc: '',
      args: [],
    );
  }

  String get general_password {
    return Intl.message(
      'Password',
      name: 'general_password',
      desc: '',
      args: [],
    );
  }

  String get error_image_invalid {
    return Intl.message(
      'This file is not an image',
      name: 'error_image_invalid',
      desc: '',
      args: [],
    );
  }

  String get error_page_not_found {
    return Intl.message(
      'Page not found :-(',
      name: 'error_page_not_found',
      desc: '',
      args: [],
    );
  }

  String get chat_title {
    return Intl.message(
      'Chat',
      name: 'chat_title',
      desc: '',
      args: [],
    );
  }

  String get chat_input_hint {
    return Intl.message(
      'Type your message...',
      name: 'chat_input_hint',
      desc: '',
      args: [],
    );
  }

  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  String get login_title {
    return Intl.message(
      'Login',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  String get login_error_email_empty {
    return Intl.message(
      'Email can\'t be empty.',
      name: 'login_error_email_empty',
      desc: '',
      args: [],
    );
  }

  String get login_error_email_invalid {
    return Intl.message(
      'Email is not valid.',
      name: 'login_error_email_invalid',
      desc: '',
      args: [],
    );
  }

  String get login_error_password_empty {
    return Intl.message(
      'Password can\'t be empty.',
      name: 'login_error_password_empty',
      desc: '',
      args: [],
    );
  }

  String get login_button_login {
    return Intl.message(
      'Login',
      name: 'login_button_login',
      desc: '',
      args: [],
    );
  }

  String get login_button_google_login {
    return Intl.message(
      'Google login',
      name: 'login_button_google_login',
      desc: '',
      args: [],
    );
  }

  String get login_button_skip {
    return Intl.message(
      'Skip',
      name: 'login_button_skip',
      desc: '',
      args: [],
    );
  }

  String get records_list_title {
    return Intl.message(
      'Flow notes',
      name: 'records_list_title',
      desc: '',
      args: [],
    );
  }

  String get records_list_empty_title {
    return Intl.message(
      'Welcome happy human!',
      name: 'records_list_empty_title',
      desc: '',
      args: [],
    );
  }

  String get records_list_empty_body {
    return Intl.message(
      'Start with your first entry or link an account so that we can know each other better.',
      name: 'records_list_empty_body',
      desc: '',
      args: [],
    );
  }

  String get records_list_button_chat {
    return Intl.message(
      'Let\'s chat',
      name: 'records_list_button_chat',
      desc: '',
      args: [],
    );
  }

  String get records_list_button_login {
    return Intl.message(
      'Log in',
      name: 'records_list_button_login',
      desc: '',
      args: [],
    );
  }

  String get record_detail_title {
    return Intl.message(
      'Your day',
      name: 'record_detail_title',
      desc: '',
      args: [],
    );
  }

  String get record_detail_by_prefix {
    return Intl.message(
      'By',
      name: 'record_detail_by_prefix',
      desc: '',
      args: [],
    );
  }

  String get record_detail_entry_hint_1 {
    return Intl.message(
      'Your first entry',
      name: 'record_detail_entry_hint_1',
      desc: '',
      args: [],
    );
  }

  String get record_detail_entry_hint_2 {
    return Intl.message(
      'Your second entry',
      name: 'record_detail_entry_hint_2',
      desc: '',
      args: [],
    );
  }

  String get record_detail_entry_hint_3 {
    return Intl.message(
      'Your third entry',
      name: 'record_detail_entry_hint_3',
      desc: '',
      args: [],
    );
  }

  String get record_detail_delete_dialog_title {
    return Intl.message(
      'Are you sure to delete this record?',
      name: 'record_detail_delete_dialog_title',
      desc: '',
      args: [],
    );
  }

  String get record_detail_date_picker_title {
    return Intl.message(
      'Select date',
      name: 'record_detail_date_picker_title',
      desc: '',
      args: [],
    );
  }

  String get record_detail_score_picker_title {
    return Intl.message(
      'Day score',
      name: 'record_detail_score_picker_title',
      desc: '',
      args: [],
    );
  }

  String get chat_action_lets_do_it {
    return Intl.message(
      'Let\'s do it!',
      name: 'chat_action_lets_do_it',
      desc: '',
      args: [],
    );
  }

  String get chat_action_skip {
    return Intl.message(
      'Skip',
      name: 'chat_action_skip',
      desc: '',
      args: [],
    );
  }

  String get chat_action_photo {
    return Intl.message(
      'Photo',
      name: 'chat_action_photo',
      desc: '',
      args: [],
    );
  }

  String get chat_action_gallery {
    return Intl.message(
      'Gallery',
      name: 'chat_action_gallery',
      desc: '',
      args: [],
    );
  }

  String get chat_action_gif {
    return Intl.message(
      'Gif',
      name: 'chat_action_gif',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_welcome {
    return Intl.message(
      'Welcome :-) Let\'s write down your best moments of the day.',
      name: 'chat_bot_welcome',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_entry_1 {
    return Intl.message(
      'What was your best moment of the day?',
      name: 'chat_bot_entry_1',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_entry_2 {
    return Intl.message(
      'It sounds great! What was your second best moment?',
      name: 'chat_bot_entry_2',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_entry_3 {
    return Intl.message(
      'Lucky you! And what was the third best moment?',
      name: 'chat_bot_entry_3',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_picture {
    return Intl.message(
      'Great. Would you like to add some picture or photo to this day?',
      name: 'chat_bot_picture',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_gif {
    return Intl.message(
      'You can also add some funny GIF :-)',
      name: 'chat_bot_gif',
      desc: '',
      args: [],
    );
  }

  String get chat_bot_finished {
    return Intl.message(
      'Great work! You can now see your notes history.',
      name: 'chat_bot_finished',
      desc: '',
      args: [],
    );
  }

  String get aaa {
    return Intl.message(
      'bbb',
      name: 'aaa',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}