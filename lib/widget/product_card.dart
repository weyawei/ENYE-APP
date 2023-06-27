import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/products/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 200.0,
          child: Image.asset(product.imageUrl, fit: BoxFit.cover,),
        ),
        Positioned(
          top: 60,
          child: Container(width: MediaQuery.of(context).size.width /2.5,
            height: 80,
            decoration: BoxDecoration(color: Colors.black.withAlpha(50),),
          ),
        ),
        Positioned(
          top: 65,
          left: 5,
          child: Container(width: MediaQuery.of(context).size.width /2.5- 10,
            height: 70,
            decoration: BoxDecoration(color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                        Text( '\₱${Product.products[0].price}',
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IconButton(icon: Icon(Icons.add_circle, color: Colors.white,
                    ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
