// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccountsResponse _$UserAccountsResponseFromJson(
        Map<String, dynamic> json) =>
    UserAccountsResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      message: json['message'] as String,
      data: UserAccountsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountsResponseToJson(
        UserAccountsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

UserAccountsData _$UserAccountsDataFromJson(Map<String, dynamic> json) =>
    UserAccountsData(
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAccounts: (json['total_accounts'] as num).toInt(),
    );

Map<String, dynamic> _$UserAccountsDataToJson(UserAccountsData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accounts': instance.accounts,
      'total_accounts': instance.totalAccounts,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      defaultAccountId: (json['default_account_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'default_account_id': instance.defaultAccountId,
    };

UserAccount _$UserAccountFromJson(Map<String, dynamic> json) => UserAccount(
      accountId: UserAccount._parseInt(json['account_id']),
      accountCode: json['account_code'] as String,
      accountName: json['account_name'] as String,
      accountType: json['account_type'] as String,
      accountStatus: json['account_status'] as String,
      accountCreatedAt: json['account_created_at'] as String,
      role: json['role'] as String,
      permissions: json['permissions'] == null
          ? null
          : AccountPermissions.fromJson(
              json['permissions'] as Map<String, dynamic>),
      userAccountStatus: json['user_account_status'] as String,
      accessGrantedAt: json['access_granted_at'] as String,
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$UserAccountToJson(UserAccount instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'account_code': instance.accountCode,
      'account_name': instance.accountName,
      'account_type': instance.accountType,
      'account_status': instance.accountStatus,
      'account_created_at': instance.accountCreatedAt,
      'role': instance.role,
      'permissions': instance.permissions,
      'user_account_status': instance.userAccountStatus,
      'access_granted_at': instance.accessGrantedAt,
      'is_default': instance.isDefault,
    };

AccountPermissions _$AccountPermissionsFromJson(Map<String, dynamic> json) =>
    AccountPermissions(
      canCollect: json['can_collect'] as bool?,
      canAddSupplier: json['can_add_supplier'] as bool?,
      canViewReports: json['can_view_reports'] as bool?,
      canManageEmployees: json['can_manage_employees'] as bool?,
    );

Map<String, dynamic> _$AccountPermissionsToJson(AccountPermissions instance) =>
    <String, dynamic>{
      'can_collect': instance.canCollect,
      'can_add_supplier': instance.canAddSupplier,
      'can_view_reports': instance.canViewReports,
      'can_manage_employees': instance.canManageEmployees,
    };

SwitchAccountResponse _$SwitchAccountResponseFromJson(
        Map<String, dynamic> json) =>
    SwitchAccountResponse(
      code: (json['code'] as num).toInt(),
      status: json['status'] as String,
      message: json['message'] as String,
      data: SwitchAccountData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SwitchAccountResponseToJson(
        SwitchAccountResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

SwitchAccountData _$SwitchAccountDataFromJson(Map<String, dynamic> json) =>
    SwitchAccountData(
      user: json['user'] as Map<String, dynamic>,
      account: DefaultAccount.fromJson(json['account'] as Map<String, dynamic>),
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SwitchAccountDataToJson(SwitchAccountData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'account': instance.account,
      'accounts': instance.accounts,
    };

DefaultAccount _$DefaultAccountFromJson(Map<String, dynamic> json) =>
    DefaultAccount(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$DefaultAccountToJson(DefaultAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'type': instance.type,
    };
