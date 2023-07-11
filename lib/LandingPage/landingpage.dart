import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galonku/LandingPage/login_role.dart';
import '../Models/_card_carousel.dart';

class LandingPage extends StatefulWidget {
  static const nameRoute = '/landingpage';

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  bool isSkipped = false;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    setSkipStatus();
  }


  Future<void> setSkipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSkipped', true);
  }

  final List<Widget> landingCarousel = [
    CardCarousel(
      text: "Temukan Isi Ulang dimana Saja",
      borderRadius: BorderRadius.circular(10),
      image: Image.asset("images/page_1.png"),
      color: Color.fromARGB(255, 52, 83, 209),
    ),
    CardCarousel(
      text: "Cukup Klik, Galonku siap antar kerumahmu",
      borderRadius: BorderRadius.circular(10),
      image: Image.asset("images/page_2.png"),
      color: Color.fromARGB(255, 239, 63, 63),
    ),
    CardCarousel(
      text: "Temukan pelanggan lebih luas",
      borderRadius: BorderRadius.circular(10),
      image: Image.asset("images/page_3.png"),
      color: Color.fromARGB(255, 42, 167, 69),
    ),
  ];

  Future<void> refreshPage() async {
    setState(() {
      _current = 0;
    });
    await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                kontenLanding(context),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: lewati(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column kontenLanding(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "GalonKu",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text("#solusiDahagamu"),
          ],
        ),
        Center(
          child: RefreshIndicator(
            onRefresh: refreshPage,
            child: CarouselSlider(
              items: landingCarousel,
              carouselController: _controller,
              options: CarouselOptions(
                height: 500,
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: landingCarousel
              .asMap()
              .entries
              .map(
                (entry) => GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Row lewati(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, top: 50),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                await setSkipStatus();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, LoginRole.nameRoute);
              },
              child: Row(
                children: [
                  Text(
                    "Lewati",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_circle_right_outlined),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
