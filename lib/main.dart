import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food/providers/cart_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food/models/menu_model.dart';
import 'package:http/http.dart' as myHttp;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomejaController = TextEditingController();
  TextEditingController uangbayarController = TextEditingController();

  final String urlMenu =
      "https://script.google.com/macros/s/AKfycbxkjy6sro6Y_XaN4-4VlLBQuWKZgq3mu7QZLgBQ0ml5OsSYmSg6Acih5W5EasTYQD6TGg/exec";
  Future<List<MenuModel>> getAllData() async {
    List<MenuModel> ListMenu = [];
    var response = await myHttp.get(Uri.parse(urlMenu));
    List data = json.decode(response.body);

    data.forEach((element) {
      ListMenu.add(MenuModel.fromJson(element));
    });

    return ListMenu;
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 300,
              child: Column(
                children: [
                  Text("Nama"),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("No. Meja"),
                  TextFormField(
                    controller: nomejaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Uang Bayar"),
                  TextFormField(
                    controller: uangbayarController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, value, _) {
                      String strPesanan = "";
                      value.cart.forEach((element) {
                        strPesanan = strPesanan +
                            "\n" +
                            element.name +
                            "(" +
                            element.quantity.toString() +
                            ")\n";
                      });
                      return ElevatedButton(
                          onPressed: () async {
                            String pesanan = "Nama : " +
                                namaController.text +
                                "\n" +
                                "Nomor Meja : " +
                                nomejaController.text +
                                "\n" +
                                "Uang Bayar : " +
                                "\n" +
                                uangbayarController.text +
                                "\n" +
                                "Pesanan : " +
                                '\n' +
                                strPesanan;

                            String url =
                                'https://api.whatsapp.com/send?phone=6281225144885&text=$pesanan';

                            await launch(url);
                          },
                          child: Text("Order Now"));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: Badge(
          alignment: AlignmentDirectional.topEnd,
          label: Consumer<CartProvider>(
            builder: (context, value, _) {
              return Text(
                (value.total > 0) ? value.total.toString() : "0",
                style: GoogleFonts.montserrat(color: Colors.white),
              );
            },
          ),
          child: Icon(Icons.shopping_cart),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: getAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              MenuModel menu = snapshot.data![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(menu.image))),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menu.name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            menu.description,
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Rp. " + menu.price.toString(),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .addRemove(
                                                                menu.name,
                                                                menu.id,
                                                                false);
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Consumer<CartProvider>(
                                                    builder:
                                                        (context, value, _) {
                                                      var id = value.cart
                                                          .indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .menuId ==
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id);
                                                      return Text(
                                                        (id == -1)
                                                            ? "0"
                                                            : value.cart[id]
                                                                .quantity
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: 15),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .addRemove(
                                                                menu.name,
                                                                menu.id,
                                                                true);
                                                      },
                                                      icon: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.green)),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Text("Tdak ada koneksi internet"),
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
