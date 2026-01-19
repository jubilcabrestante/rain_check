import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/router/router.gr.dart';

@RoutePage()
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final List<Map<String, dynamic>> navList = [
    {"title": "Calculate", "route": CalculateRoute()},
    {"title": "Predict", "route": PredictRoute()},
    {"title": "How to Use RainCheck", "route": GuideRoute()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //  Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Juan Dela Cruz",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              // Account Icon
              Icon(Icons.account_circle),
            ],
          ),

          // Weather Container
          Expanded(
            // TODO: Implement weather api here
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_city, size: 35),
                        // TODO: Implement dynamic location here but only if the location city is puerto princesa city
                        Text("Puerto Princesa City, Palawan"),
                      ],
                    ),
                    Gap(5),
                    Text(
                      "Todays Forecast",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(20),
                    Row(
                      children: [
                        Icon(Icons.water_drop, size: 50),
                        // TODO: Implement dynamic rain percentage here
                        Text("40%"),
                      ],
                    ),
                    Text("Light showers expected"),
                    Text("Accumulation: 5mm"),
                  ],
                ),
                Gap(2),
                Column(
                  children: [
                    Icon(Icons.water_drop, size: 50),
                    Spacer(),
                    Text(
                      "Now",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    // TODO: Implement dynamic temperature here
                    Text(
                      "18°C",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Navigation Container
          Text("Quick Actions"),
          Expanded(
            child: ListView.builder(
              itemCount: navList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(navList[index]['title']),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    context.router.push(navList[index]['route']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
