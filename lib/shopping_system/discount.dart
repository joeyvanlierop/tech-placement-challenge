import 'package:tech_placement_challenge/shopping_system/item.dart';

/// Abstract implementation of a discount object.
///
/// Adheres to the strategy pattern. Each implementation of [Discount] must
/// override [calculatePrice()].
abstract class Discount {
  /// Description of the discount.
  ///
  /// ```
  /// description = "8 Items For The $6.00"
  /// ```
  final String description;

  const Discount({this.description});

  /// Calculates the discounted price of an item.
  ///
  /// @param item The item to discount.
  /// @param count The amount of items present.
  /// @returns The discounted price.
  double calculatePrice(Item item, int count);
}

/// Predefined implementation of a discount.
///
/// Applicable for when the discount is of the format:
///   "[n] for $[discountPrice]"
///   "8 for $6.00"
class DiscountNForPrice extends Discount {
  /// The amount of items required for the discounted price to be applied.
  final int n;

  /// The discounted price to be applied if [n] items are present.
  final double discountPrice;

  const DiscountNForPrice(
    this.n,
    this.discountPrice,
  ) : super(description: '$n For \$$discountPrice');

  /// Calculates the discounted price by doing the following:
  ///   - Determine the amount of pairs of [n] items there are present.
  ///   - Calculate the price of the non-discounted items by multiplying the
  ///     [amountNormal] by the items normal price.
  ///   - Calculate the price of the discounted items by multiplying the
  ///     [amountDiscounted] by the [discountPrice].
  ///   - Return the sum of the discounted and non-discounted prices.
  @override
  double calculatePrice(Item item, int count) {
    int amountDiscounted = count ~/ n;
    int amountNormal = count - amountDiscounted * n;

    double priceDiscounted = amountDiscounted * discountPrice;
    double priceNormal = amountNormal * item.price;
    double totalPrice = priceDiscounted + priceNormal;

    return totalPrice;
  }
}

/// Predefined implementation of a discount.
///
/// Applicable for when the discount is of the format:
///   "Buy [buyN] get [getM] free"
///   "Buy 3 get 1 free"
///
/// In order to follow the rules of the UNiDAYS coding challenge, an additional
/// item is not given if [n] item are purchased. Rather, if an additional item
/// is purchased after [n] items are purchased, the additional item is free of
/// charge.
class DiscountBuyNGetM extends Discount {
  /// The amount of items required to obtain [getM] free items
  final int buyN;

  /// The amount of items received free of charge once [buyN] is attained
  final int getM;

  DiscountBuyNGetM(this.buyN, this.getM)
      : super(description: 'Buy $buyN Get $getM Free');

  /// Calculates the discounted price by doing the following:
  ///   - Iterate over the item count until [buyN] items is reached
  ///     - During each iteration, sum the items price
  ///   - Once [buyN] is reached, the next [getM] items are skipped
  ///
  /// This might be able to be revised so that it functions in constant time,
  /// however this iterative approach is quite concise and works very well.
  @override
  double calculatePrice(Item item, int count) {
    double totalPrice = 0;

    for (int i = 0; i < count; i++) {
      totalPrice += item.price;

      if (i % buyN == 0) {
        i += getM;
      }
    }

    return totalPrice;
  }
}

/// Predefined implementation of a discount.
///
/// Applicable for when the discount is of the format:
///   "Buy [buyN] for the price of [forM]"
///   "Buy 3 for the price of 2"
class DiscountNForM extends Discount {
  /// The amount of items required to be eligible for the discount
  final int buyN;

  /// The price for [buyN] items
  final int forM;

  DiscountNForM(this.buyN, this.forM)
      : super(description: 'Buy $buyN For The Price Of $forM');

  /// Calculates the discounted price by doing the following:
  ///   - Determine how many groups of [buyN] items there are
  ///   - Recalculate the amount of items by subtracting the original count
  ///   by the amount of [buyN] item groups there are
  ///     - [forM] is taken into account at this point
  double calculatePrice(Item item, int count) {
    int groupsOfN = count ~/ buyN;
    int amountNormal = count - groupsOfN * buyN;
    int amountDiscounted = groupsOfN * forM;

    int totalAmount = amountNormal + amountDiscounted;
    double totalPrice = totalAmount * item.price;

    return totalPrice;
  }
}
