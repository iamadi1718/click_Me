import 'package:click_me/controller/likecontroller/interests_controller.dart';
import 'package:click_me/view/custombutton/Custombutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Interestspage extends StatelessWidget {
  Interestspage({super.key});

  final controller = Get.put(InterestsController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.1),
            const Text(
              'Tell us what you like!',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.interests.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.4,
                ),
                itemBuilder: (context, index) {
                  final item = controller.interests[index];
                  final String title = item['title']!;
                  final String emoji = item['emoji']!;

                  return Obx(() {
                    final isSelected = controller.selectedInterests.contains(
                      title,
                    );

                    return GestureDetector(
                      onTap: () => controller.toggleInterest(title),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color.fromRGBO(85, 13, 155, 0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color.fromRGBO(85, 13, 155, 1)
                                    : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected
                                          ? const Color.fromRGBO(85, 13, 155, 1)
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: height * 0.05),
            Row(
              children: [
                SizedBox(width: width * 0.05),
                TextButton(
                  onPressed: controller.skip,
                  child: const Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(85, 13, 155, 1),
                                ),
                              ),
                            )
                          : Custombutton(
                              text: 'Done',
                              onTap: controller.saveInterests,
                              buttoncolor: const Color.fromRGBO(85, 13, 155, 1),
                              bordercolor: const Color.fromRGBO(85, 13, 155, 1),
                              textcolor: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
