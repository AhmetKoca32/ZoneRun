import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Resolves auth error codes to localized messages for the current context.
class AuthL10n {
  AuthL10n._();

  static String? messageFor(BuildContext context, String? code) {
    if (code == null) return null;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return code;
    switch (code) {
      case 'authErrorAuthStateFailed':
        return l10n.authErrorAuthStateFailed;
      case 'authErrorNotReady':
        return l10n.authErrorNotReady;
      case 'authErrorSignUpFailed':
        return l10n.authErrorSignUpFailed;
      case 'authErrorSignInFailed':
        return l10n.authErrorSignInFailed;
      case 'authErrorGoogleCancelled':
        return l10n.authErrorGoogleCancelled;
      case 'authErrorGoogleFailed':
        return l10n.authErrorGoogleFailed;
      case 'authErrorPasswordResetFailed':
        return l10n.authErrorPasswordResetFailed;
      case 'authErrorSignOutFailed':
        return l10n.authErrorSignOutFailed;
      case 'authErrorSignInRequired':
        return l10n.authErrorSignInRequired;
      case 'authErrorWeakPassword':
        return l10n.authErrorWeakPassword;
      case 'authErrorEmailInUse':
        return l10n.authErrorEmailInUse;
      case 'authErrorInvalidEmail':
        return l10n.authErrorInvalidEmail;
      case 'authErrorUserDisabled':
        return l10n.authErrorUserDisabled;
      case 'authErrorUserNotFound':
        return l10n.authErrorUserNotFound;
      case 'authErrorWrongPassword':
        return l10n.authErrorWrongPassword;
      case 'authErrorInvalidCredential':
        return l10n.authErrorInvalidCredential;
      case 'authErrorTooManyRequests':
        return l10n.authErrorTooManyRequests;
      case 'authErrorOperationNotAllowed':
        return l10n.authErrorOperationNotAllowed;
      case 'authErrorRequiresRecentLogin':
        return l10n.authErrorRequiresRecentLogin;
      case 'authErrorNetworkFailed':
        return l10n.authErrorNetworkFailed;
      case 'authErrorExpiredActionCode':
        return l10n.authErrorExpiredActionCode;
      case 'authErrorInvalidActionCode':
        return l10n.authErrorInvalidActionCode;
      case 'authErrorPopupClosed':
        return l10n.authErrorPopupClosed;
      case 'authErrorPopupBlocked':
        return l10n.authErrorPopupBlocked;
      case 'authErrorAccountExistsDifferentCredential':
        return l10n.authErrorAccountExistsDifferentCredential;
      case 'authErrorGeneric':
      default:
        return l10n.authErrorGeneric;
    }
  }
}
