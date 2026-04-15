import 'package:flutter/material.dart';
import 'package:glow_container/glow_container.dart';
import 'package:animated_scroll_item/animated_scroll_item.dart';
import 'package:loan_app/reuseableWidget/listwidget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:blinking_border/blinking_border.dart';

import '../InformationPage/apply_page.dart';
import '../InformationPage/payment.dart';
import '../MessageUi/messages.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  // Draggable icon position
  double top = 500;
  double left = 250;

  // Track separate selection states to avoid conflicts
  int gridSelectedIndex = -1;
  int listSelectedIndex = -1;

  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Continuous pulsing animation for the "Apply Loan" alert
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              "Cash Pay",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.attach_money, color: Colors.white),
            Spacer(),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF3A3A3A),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavBar(),
      body: Stack(
        children: [
          Container(color: Colors.white),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Text(
                        'Welcome to Cash Pay!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: GlowContainer(
                      glowRadius: 20,
                      gradientColors: const [
                        Colors.blue,
                        Colors.purple,
                        Colors.pink,
                      ],
                      rotationDuration: const Duration(seconds: 3),
                      showAnimatedBorder: true,
                      containerOptions: ContainerOptions(
                        width: double.infinity,
                        height: 200,
                        borderRadius: 30,
                        backgroundColor: const Color(0xFF3A3A3A),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'images/cashpay.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // GRID SECTION: Uses gridSelectedIndex
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildSelectableGridItem(
                          0,
                          Icons.payment,
                          "Pay Loan",
                          const Payment(),
                        ),
                        _buildSelectableGridItem(
                          1,
                          Icons.request_page,
                          "Request Loan",
                          const Payment(),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: BlinkingBorder(
                            color: Colors.blueAccent,
                            strokeWidth: 3.0,
                            borderRadius: BorderRadius.circular(15.0),
                            duration: const Duration(milliseconds: 500),
                            child: ZoomTapAnimation(
                              onTap: () {
                                setState(() => gridSelectedIndex = 2);
                                _navigateToPage(const ApplyPage());
                              },
                              child: _buildSelectableGridItem(
                                2,
                                Icons.task_alt,
                                "Apply Loan",
                                const ApplyPage(),
                                isCustomTap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // LIST SECTION: Uses listSelectedIndex
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return AnimatedScrollItem(
                          size: const Size(double.infinity, 150),
                          configs: [
                            ItemAnimationConfig(
                              itemTransform: (animationValue, size, matrix) {
                                final curveValue = Curves.easeOutBack.transform(
                                  animationValue,
                                );
                                return matrix
                                  ..setTranslationRaw(
                                    0.0,
                                    (1 - curveValue) * 25,
                                    0.0,
                                  )
                                  ..scale(0.95 + 0.05 * curveValue);
                              },
                            ),
                          ],
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                listSelectedIndex = index;
                              });
                              _navigateToPage(const Payment());
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: listSelectedIndex == index
                                    ? Colors.blue.withOpacity(0.15)
                                    : Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: listSelectedIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Listwidget(index: index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: top,
            left: left,
            child: GestureDetector(
              onTap: () => _navigateToPage(const Messages()),
              onPanUpdate: (details) {
                setState(() {
                  top += details.delta.dy;
                  left += details.delta.dx;
                  if (top < 0) top = 0;
                  if (left < 0) left = 0;
                  if (top > size.height - 180) top = size.height - 180;
                  if (left > size.width - 80) left = size.width - 80;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFF3A3A3A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.chat, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A3A3A), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("Home", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text("Profile", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF3A3A3A),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 1 || index == 2) _navigateToPage(const Payment());
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page),
          label: "Request",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Pay"),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notifications",
        ),
      ],
    );
  }

  Widget _buildSelectableGridItem(
    int index,
    IconData icon,
    String label,
    Widget page, {
    bool isCustomTap = false,
  }) {
    bool isSelected = gridSelectedIndex == index;
    return GestureDetector(
      onTap: isCustomTap
          ? null
          : () {
              setState(() => gridSelectedIndex = index);
              _navigateToPage(page);
            },
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlowContainer(
          glowRadius: 15,
          gradientColors: isSelected
              ? [Colors.blue, Colors.purple, Colors.pink]
              : [Colors.black, Colors.white, Colors.blue],
          containerOptions: ContainerOptions(
            height: 100,
            borderRadius: 15,
            backgroundColor: const Color(0xFF3A3A3A),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 45),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
