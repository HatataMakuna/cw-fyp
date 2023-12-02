import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pre-order and Automation Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RewardPage(),
    );
  }
}

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  int userPoints = 500;
  List<AchievedReward> achievedRewards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Rewards'),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sub.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserCard(userName: 'Chun Wai', userPoints: userPoints),
                      const SizedBox(height: 16),
                      const Text(
                        'Your Rewards',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue,),
                      ),
                      const SizedBox(height: 16),
                      RewardCard(
                        title: 'Free Delivery',
                        description: 'Get free delivery on your next order!',
                        points: 100,
                        userPoints: userPoints,
                        onRedeem: (int points) {
                          setState(() {
                            userPoints -= points;
                            achievedRewards.add(AchievedReward(
                              title: 'Free Delivery',
                              details: 'Free delivery on your next order!',
                              termsAndConditions:
                                  'Valid for one-time use only.',
                            ));
                          });
                        },
                      ),
                      RewardCard(
                        title: 'Discount Coupon',
                        description:
                            'Enjoy a 20% discount on selected items.',
                        points: 150,
                        userPoints: userPoints,
                        onRedeem: (int points) {
                          setState(() {
                            userPoints -= points;
                            achievedRewards.add(AchievedReward(
                              title: 'Discount Coupon',
                              details: '20% discount on selected items.',
                              termsAndConditions:
                                  'Not applicable to certain products.',
                            ));
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Achieved Rewards',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                // Display achieved rewards
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: achievedRewards
                      .map((reward) => AchievedRewardCard(achievedReward: reward))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String userName;
  final int userPoints;

  UserCard({required this.userName, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your Points: $userPoints',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final int points;
  final int userPoints;
  final Function(int) onRedeem;

  RewardCard({
    required this.title,
    required this.description,
    required this.points,
    required this.userPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Points: $points',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: userPoints >= points
                      ? () {
                          onRedeem(points);
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey; // Disabled color
                        }
                        return Colors.orange; // Enabled color
                      },
                    ),
                  ),
                  child: const Text('Redeem'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AchievedReward {
  final String title;
  final String details;
  final String termsAndConditions;

  AchievedReward({
    required this.title,
    required this.details,
    required this.termsAndConditions,
  });
}

class AchievedRewardCard extends StatelessWidget {
  final AchievedReward achievedReward;

  AchievedRewardCard({required this.achievedReward});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievedReward.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              achievedReward.details,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Terms & Conditions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              achievedReward.termsAndConditions,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
