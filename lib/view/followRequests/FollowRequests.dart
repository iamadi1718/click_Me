import 'package:click_me/Models/followRequestsModel/FollowRequestsModel.dart';
import 'package:click_me/services/FollowRequestsServices/FollowRequestsServices.dart';

import 'package:click_me/view/utils/api.dart';
import 'package:flutter/material.dart';

class FollowRequestsScreen extends StatefulWidget {
  const FollowRequestsScreen({super.key});

  @override
  State<FollowRequestsScreen> createState() => _FollowRequestsScreenState();
}

class _FollowRequestsScreenState extends State<FollowRequestsScreen> {
  late Future<Followrequestsmodel> futureRequests;

  @override
  void initState() {
    super.initState();
    futureRequests = FollowRequestsService().getFollowRequestsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Follow Requests",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FutureBuilder<Followrequestsmodel>(
        future: futureRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.data == null ||
              snapshot.data!.data!.isEmpty) {
            return const Center(
              child: Text("No Requests"),
            );
          }

          final requests = snapshot.data!.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              return FollowRequestTile(request: request);
            },
          );
        },
      ),
    );
  }
}
class FollowRequestTile extends StatelessWidget {
  final RequestData request;

  const FollowRequestTile({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final user = request.requester;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: Row(
        children: [

          /// Profile Image
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: user?.profilePicture != null
                ? NetworkImage(
                    "${Api.baseUrl}${user!.profilePicture}",
                  )
                : null,
            child: user?.profilePicture == null
                ? const Icon(Icons.person)
                : null,
          ),

          const SizedBox(width: 12),

          /// Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "@${user?.firstName?.toLowerCase() ?? "username"}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          /// Allow Button
          SizedBox(
            width: 80,
            height: 35,
            child: ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                "Allow",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Reject Button
          SizedBox(
            width: 85,
            height: 35,
            child: ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                "Reject",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
