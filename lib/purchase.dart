import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meet_up/main.dart';

// MARK: - Purchase
// 상품 정보 가져오기
Future<ProductDetails> getProductsInfo() async {
  // 상품 ID
  final Set<String> ids = {'coin1000_saled'};

  // 상품 정보 가져오기
  final ProductDetailsResponse response =
      await InAppPurchase.instance.queryProductDetails(ids);

  // 상품 정보가 없는 경우
  if (response.notFoundIDs.isNotEmpty) {
    logger.e('상품 정보를 찾을 수 없습니다.');
  }

  // 상품 정보 출력
  for (var productDetails in response.productDetails) {
    logger.d('Product id: ${productDetails.id}');
    logger.d('Product title: ${productDetails.title}');
    logger.d('Product description: ${productDetails.description}');
    logger.d('Product price: ${productDetails.price}');
  }

  return response.productDetails.first;
}

// 결제 시도
Future<void> initiatePurchase(ProductDetails productDetails) async {
  // 결제 정보 설정
  final PurchaseParam purchaseParam = PurchaseParam(
    productDetails: productDetails,
  );

  // 결제 시도
  final purchaseResponse = await InAppPurchase.instance
      .buyNonConsumable(purchaseParam: purchaseParam);

  // 결제 결과
  if (!purchaseResponse) {
    logger.e('[인앱결제] 결제 실패}');
  } else {
    logger.d('[인앱결제] 결제 성공');
  }
}
