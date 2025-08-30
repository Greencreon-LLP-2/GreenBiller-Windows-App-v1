// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      loggedIn: fields[0] as bool?,
      accessToken: fields[1] as String?,
      username: fields[2] as String?,
      email: fields[3] as String?,
      phone: fields[4] as String?,
      userLevel: fields[5] as int?,
      status: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      licenseKey: fields[8] as String?,
      subscriptionStart: fields[9] as dynamic,
      subscriptionId: fields[10] as dynamic,
      subscriptionEnd: fields[11] as dynamic,
      profileImage: fields[12] as dynamic,
      tokenExpiresIn: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.loggedIn)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.userLevel)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.licenseKey)
      ..writeByte(9)
      ..write(obj.subscriptionStart)
      ..writeByte(10)
      ..write(obj.subscriptionId)
      ..writeByte(11)
      ..write(obj.subscriptionEnd)
      ..writeByte(12)
      ..write(obj.profileImage)
      ..writeByte(13)
      ..write(obj.tokenExpiresIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
