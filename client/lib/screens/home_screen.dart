import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zap_list_flutter/components/carousel_component.dart';
import 'package:zap_list_flutter/components/header_component.dart';
import 'package:zap_list_flutter/components/product_card_component.dart';
import 'package:zap_list_flutter/controllers/product_controller.dart';
import 'package:zap_list_flutter/models/product_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  User? user;

  HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productController = ProductController();
  List<Product> products = [];

  List categories = [
    'Grãos',
    'Chás e cafés',
    'Farinhas e derivados',
    'Congelados',
    'Biscoitos e salgadinhos',
    'Utensílios de cozinha',
    'Açúcares e adoçantes',
    'Frutas',
    'Verduras',
    'Legumes',
    'Carnes',
    'Peixes',
    'Massas',
    'Laticínios e ovos',
    'Padaria',
    'Temperos e especiarias',
    'Doces e guloseimas',
    'Bebidas',
    'Material de higiene',
    'Material de limpeza',
    'Itens pra cachorro',
    'Conservas e enlatados',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    setupFCM();
    fetchData();
  }

  @override
  void dispose() {
    productController.dispose();
    super.dispose();
  }

  void fetchData() async {
    try {
      final res = await productController.fetchProducts();
      setState(() {
        products = res;
      });
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    }
  }

  void setupFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em foreground!');
      print('Dados: ${message.data}');
      if (message.notification != null) {
        print('Título: ${message.notification?.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App aberto por uma notificação!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            ImageCarousel(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Categorias'),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.black, size: 20),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Image.asset('assets/images/graos.png', width: 80, height: 80),
                      Text('Grãos'),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Image.asset('assets/images/chasECafes.png', width: 80, height: 80),
                      Text('Chás e cafés'),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Image.asset('assets/images/farinhasEDerivados.png', width: 80, height: 80),
                      Text('Farinhas e derivados'),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Image.asset('assets/images/congelados.png', width: 80, height: 80),
                      Text('Congelados'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  ...categories.map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                c,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                ...products
                                    .where((product) => product.category == c)
                                    .take(10)
                                    .map((product) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                    child: ProductCard(product: product),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
