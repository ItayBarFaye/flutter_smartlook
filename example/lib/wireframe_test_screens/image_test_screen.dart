import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WireframeImageTestScreen extends StatefulWidget {
  const WireframeImageTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeImageTestScreen> createState() =>
      _WireframeImageTestScreenState();
}

class _WireframeImageTestScreenState extends State<WireframeImageTestScreen>
    with TickerProviderStateMixin {
  bool switchValue = false;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Single widget test Screen")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: RotationTransition(
                  turns: controller,
                  child: Image(
                    image:
                        Image.asset('res/images/detective_pikachu.jpeg').image,
                    width: 100,
                    height: 100,
                    //  color: Colors.black12,
                  ),
                ),
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/005.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/007.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              CachedNetworkImage(
                imageUrl: "https://picsum.photos/id/237/200/300",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              HeroMode(
                child: Hero(
                  tag: 'res/images/detective_pikachu.jpeg',
                  child: Image.asset(
                    'res/images/detective_pikachu.jpeg',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Image.asset(
                'res/images/detective_pikachu.jpeg',
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.asset(
                'res/images/mewtwo.jpeg',
                width: 100,
                height: 100,
              ),
              Image.asset(
                'res/images/pikachu.png',
                width: 50,
                height: 50,
              ),
              Image.asset(
                'res/images/pikachu.png',
                width: 50,
                height: 50,
                scale: 0.000005,
              ),
              Image.asset(
                'res/images/pikachu.png',
                width: 50,
                height: 50,
                color: Colors.white,
                colorBlendMode: BlendMode.colorDodge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
