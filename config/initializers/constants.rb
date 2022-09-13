SESSION_TIME_OUT = 3600.freeze
EMAIL_CONFIRMATION_TIME_OUT = 21600.freeze          # 6 hours of expiry
CHANGE_PASSWORD_TIME_OUT = 900.freeze               # 15 minutes of expiry
SECRET_KEY = "thepersioncatwithgreyhairs@2009"
USER_ROLES = %w(1 2 3)
ADMIN_USER_ROLE = "1"
PLATFORM_USER_ROLE = "2"
MAINTAINER_USER_ROLE = "3"

# Messages
INVALID_CREDENTIALS_MESSAGE = "invalid username or password."
DELETED_MESSAGE = " is successfully deleted."
INVALID_ACCESS_RIGHTS_MESSAGE = "user doesn't have enough rights to access this resource."
INACTIVATED_USER_MESSAGE = "user account should be activated to perform this operation."
SAME_USER_MESSAGE = "you cannot apply this operation on your own profile."
NO_RECORD_MESSAGE = "no such record found in the records."
ALREADY_TAKEN_AND_ACTIVATED = "this user is already taken. please follow forgot password to recover."
UNVERIFIED_EMAIL_MESSAGE = "need email verification to proceed."
FORGET_PASSWORD_MESSAGE = "email has been sent to you with link to change password."

# Email Subjects
SET_PASSWORD_EMAIL_SUBJECT = "Systems IPortal | Set Password"
EMAIL_CONFIRMATION_SUBJECT = "Systems IPortal | Email Confirmation"
ACTIVATE_ACCOUNT_NOTIFICATION_SUBJECT = "Systems IPortal | Account Activation Approval"
ACTIVATION_CONFIRMATION_NOTIFICATION_SUBJECT = "Systems IPortal | Your Account is now activated"
CHANGE_PASSWORD_SUBJECT = "Systems IPortal | Change Password"

# Urls
FRONTEND_CHANGE_PASSWORD_ENDPOINT="/session/change-password"