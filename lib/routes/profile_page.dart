import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:path/path.dart' as path;

import 'package:flow/entity/profile.dart';
import 'package:flow/objectbox.dart';
import 'package:flow/objectbox/objectbox.g.dart';
import 'package:flow/utils/utils.dart';
import 'package:flow/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int? profileId;

  const ProfilePage({super.key, this.profileId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Evicting cache doesn't rebuild the image
  // and setState(() {}) hasn't been useful.
  //
  // Makes me do these kind of weird stuff :)))
  int _profilePictureUpdateCounter = 0;

  late final Profile? _profile;

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _profile = ObjectBox()
        .box<Profile>()
        .query(
          widget.profileId != null
              ? Profile_.id.equals(widget.profileId!)
              : null,
        )
        .build()
        .findFirst();

    _nameController = TextEditingController(text: _profile?.name);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => save(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: _profile == null
              ? const Center(
                  child: Text("Impossible state"),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: "pfp",
                        child: ProfilePicture(
                          key: ValueKey(_profilePictureUpdateCounter),
                          filePath: _profile!.imagePath,
                          onTap: changeProfilePicture,
                          showOverlayUponHover: true,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _nameController,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> changeProfilePicture() async {
    final cropped = await pickAndCropSquareImage(context, maxDimension: 512);
    if (cropped == null) {
      // Error toast is handled in `pickAndCropSquareImage`
      return;
    }

    final byteData = await cropped.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();

    if (bytes == null) throw "";

    final dataDirectory = ObjectBox.appDataDirectory;

    final file = File(path.join(
      dataDirectory,
      _profile!.imagePath,
    ));

    try {
      await FileImage(file).evict();
      _profilePictureUpdateCounter++;
    } catch (e) {
      log("[Flow] Profile Page > Failed to evict profile FileImage cache due to:\n$e");
    }

    await file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> save() async {
    try {
      await ObjectBox().box<Profile>().putAsync(_profile!);
    } catch (e) {
      log("[Profile Page] failed to put $_profile due to $e");
    }
  }
}
