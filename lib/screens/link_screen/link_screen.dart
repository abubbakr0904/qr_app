import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../bloc/qr_bloc/qr_bloc.dart';
import '../../data/models/product_model/product_model.dart';
import '../../data/models/product_model/status.dart';
import '../../service/widget_saver.dart';
import '../qr_screen/qr_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  // String filePath = "";
  //
  // Future<void> _downloadCheque(String id) async {
  //   showLoading(context: context);
  //   bool isFileCreated = await _createChequeFile(id);
  //   if (!mounted) return;
  //   hideLoading(context: context);
  //   if (isFileCreated) {
  //     if (filePath.isNotEmpty) {
  //       //Open File
  //       // OpenFilex.open(filePath);
  //       //Save image to Gallery
  //       GallerySaver.saveImage(filePath).then((value) {
  //         showSuccessMessage(message: "Image Saved", context: context);
  //       });
  //     }
  //   } else {
  //     showSuccessMessage(
  //       message: "Error",
  //       context: context,
  //     );
  //   }
  // }
  //
  // Future<bool> _createChequeFile(String id) async {
  //   var storageStatus = await Permission.storage.status;
  //   if (storageStatus == PermissionStatus.denied) {
  //     await Permission.storage.request();
  //   }
  //
  //   String dir = (Platform.isAndroid
  //           ? await getExternalStorageDirectory()
  //           : await getApplicationSupportDirectory())!
  //       .path;
  //   if (!mounted) return false;
  //   RenderRepaintBoundary boundary =
  //       _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();
  //   ByteData byteData =
  //       (await image.toByteData(format: ui.ImageByteFormat.png)) as ByteData;
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   File file = File('$dir/cheque-${id}.png');
  //   debugPrint('$dir/cheque-${id}.png');
  //   filePath = file.path;
  //   await file.writeAsBytes(pngBytes);
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return QrScannerScreen(
                      barcode: (barcode) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(barcode.code.toString()),
                          ),
                        );
                        context.read<ProductBloc>().add(
                          AddProductEvent(
                            productModel: ProductModel(
                              name: "Pomidor",
                              id: 2,
                              qrCode: barcode.code.toString(),
                              description: "Tabiiy",
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey,
      body: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if (state.status == FormStatus.loading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state.status == FormStatus.error) {
          return Center(
            child: Text(state.statusText),
          );
        }
        GlobalKey _globalKey = GlobalKey();


        return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(state.products.length, (index){
               ProductModel productModel = state.products[index];
                return RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productModel.name,
                          style: TextStyle(fontSize: 32),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            QrImageView(
                              data: productModel.qrCode,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ],
                        ),
                        Text(
                          "QR-Code: ${productModel.qrCode}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                WidgetSaverService.openWidgetAsImage(
                                  context: context,
                                  widgetKey: _globalKey,
                                  fileId: productModel.qrCode,
                                );
                              },
                              child: const Icon(Icons.share),
                            ),
                            TextButton(
                              onPressed: () {
                                WidgetSaverService.saveWidgetToGallery(
                                  context: context,
                                  widgetKey: _globalKey,
                                  fileId: productModel.qrCode,
                                );
                              },
                              child: const Icon(Icons.download),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        );
      }),
    );
  }
}