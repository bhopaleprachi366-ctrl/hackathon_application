import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  bool isUploadingImage = false;

  String email = "";
  String role = "";
  String imageUrl = "";

  // --------------------------------------------------
  // CLOUDINARY DETAILS
  // --------------------------------------------------

  static const String cloudName = "kej7zrnn";
  static const String uploadPreset = "subserver_profile";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // --------------------------------------------------
  // LOAD PROFILE
  // --------------------------------------------------

  Future<void> loadProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        return;
      }

      DocumentSnapshot document =
          await _firestore.collection("users").doc(user.uid).get();

      if (document.exists) {
        Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        addressController.text = data["address"] ?? "";

        setState(() {
          email = data["email"] ?? user.email ?? "";
          role = data["role"] ?? "customer";
          imageUrl = data["image"] ?? "";
          isLoading = false;
        });
      } else {
        setState(() {
          email = user.email ?? "";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load profile: $e"),
          ),
        );
      }
    }
  }

  // --------------------------------------------------
  // PICK IMAGE
  // --------------------------------------------------

  Future<void> pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        return;
      }

      setState(() {
        isUploadingImage = true;
      });

      await uploadToCloudinary(File(pickedImage.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Image selection failed: $e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // UPLOAD IMAGE TO CLOUDINARY
  // --------------------------------------------------

  Future<void> uploadToCloudinary(File imageFile) async {
    User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    try {
      var request = http.MultipartRequest(
        "POST",
        url,
      );

      request.fields["upload_preset"] = uploadPreset;
      request.fields["folder"] = "subserve/profile/${user.uid}";

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imageFile.path,
        ),
      );

      var response = await request.send();

      final responseData =
          await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);

        String uploadedImageUrl = data["secure_url"];

        await _firestore.collection("users").doc(user.uid).update({
          "image": uploadedImageUrl,
        });

        setState(() {
          imageUrl = uploadedImageUrl;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile photo updated"),
            ),
          );
        }
      } else {
        throw Exception(
          "Cloudinary upload failed: $responseData",
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload failed: $e"),
          ),
        );
      }
    }
  }

  // --------------------------------------------------
  // SAVE PROFILE
  // --------------------------------------------------

  Future<void> saveProfile() async {
    User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _firestore.collection("users").doc(user.uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update profile: $e"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // LOGOUT
  // --------------------------------------------------

  Future<void> logout() async {
    await _auth.signOut();

    if (!mounted) {
      return;
    }

    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
  }

  // --------------------------------------------------
  // PROFILE IMAGE
  // --------------------------------------------------

  Widget profileImage() {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 58,
        backgroundImage: NetworkImage(imageUrl),
      );
    }

    return const CircleAvatar(
      radius: 58,
      child: Icon(
        Icons.person,
        size: 65,
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 10),

            // PROFILE PHOTO
            Stack(
              children: [
                profileImage(),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: isUploadingImage
                        ? null
                        : pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          AppColors.primary,
                      child: isUploadingImage
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              nameController.text.isEmpty
                  ? "SubServe User"
                  : nameController.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              email,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),

            // ROLE
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // PERSONAL INFORMATION
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: 15),

            // EMAIL - READ ONLY
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: email,
              ),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 25),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving
                    ? null
                    : saveProfile,
                icon: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),

                label: Text(
                  isSaving
                      ? "Saving..."
                      : "Save Changes",
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LOGOUT
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.error,
                ),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}