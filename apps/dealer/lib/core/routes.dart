import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_layout/main_layout.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/features/auth_screens/login.dart';
import 'package:vintage_app/features/auth_screens/signup.dart';
import 'package:vintage_app/features/auth_screens/check_email.dart';
import 'package:vintage_app/features/auth_screens/business_information_view.dart';
import 'package:vintage_app/features/auth_screens/dealer_verification_view.dart';
import 'package:vintage_app/features/auth_screens/forgot_password.dart';
import 'package:vintage_app/features/auth_screens/identity_verification_view.dart';
import 'package:vintage_app/features/auth_screens/new_password.dart';
import 'package:vintage_app/features/auth_screens/payout_details_view.dart';
import 'package:vintage_app/features/auth_screens/store_profile_view.dart';
import 'package:vintage_app/features/auth_screens/verification_in_progress_view.dart';
import 'package:vintage_app/features/intro/intro_slider.dart';
import 'package:vintage_app/features/intro/splash.dart';
import 'package:vintage_app/features/messages/inbox_view.dart';
import 'package:vintage_app/features/messages/single_message.dart';
import 'package:vintage_app/features/dealer_flow/events/all_events_view.dart';
import 'package:vintage_app/features/dealer_flow/events/event_detail_view.dart';
import 'package:vintage_app/features/dealer_flow/home/home_view.dart';
import 'package:vintage_app/features/dealer_flow/marketplace/marketplace_tab_view.dart';
import 'package:vintage_app/features/dealer_flow/marketplace/checkout_view.dart';
import 'package:vintage_app/features/dealer_flow/marketplace/make_offer_view.dart';
import 'package:vintage_app/features/dealer_flow/marketplace/shopping_cart_view.dart';
import 'package:vintage_app/features/dealer_flow/marketplace/single_product_view.dart';
import 'package:vintage_app/features/dealer_flow/my_finds/edit_item_view.dart';
import 'package:vintage_app/features/dealer_flow/my_finds/inventory_item_detail_view.dart';
import 'package:vintage_app/features/dealer_flow/my_finds/my_finds_view.dart';
import 'package:vintage_app/features/dealer_flow/my_finds/offers_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/achievements_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/accept_order_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/app_settings_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/change_password_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/two_factor_auth_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/tfa_setup_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/tfa_verify_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/tfa_success_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/language_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/edit_profile.dart';
import 'package:vintage_app/features/dealer_flow/profile/help_faq_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/membership_points_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/order_history_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/orders_overview_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/profile_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/purchase_history_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/privacy_terms_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/privacy_policy_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/rewards_achievements_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/reviews_ratings_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/track_order_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/verification_status_view.dart';
import 'package:vintage_app/features/dealer_flow/profile/write_review_view.dart';
import 'package:vintage_app/features/dealer_flow/scan/add_new_item_view.dart';
import 'package:vintage_app/features/dealer_flow/scan/additional_specifications_view.dart';
import 'package:vintage_app/features/dealer_flow/scan/ai_scanner_view.dart';
import 'package:vintage_app/features/dealer_flow/scan/ai_scan_result_view.dart';
import 'package:vintage_app/features/dealer_flow/scan/upload_from_gallery_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/my_wallet_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/add_funds_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/add_payment_method_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/escrow_payments_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/payment_methods_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/release_payment_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/transaction_history_view.dart';
import 'package:vintage_app/features/dealer_flow/wallet/withdraw_funds_view.dart';
import 'package:vintage_app/features/notifications/notifications_view.dart';

class Routes {
  static GoRouter routes = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/introSlider', builder: (context, state) => IntroSlider()),
      GoRoute(
        path: "/login",
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: "/signup",
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const SignupScreen()),
      ),
      GoRoute(
        path: '/dealer/verification',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const DealerVerificationView()),
      ),
      GoRoute(
        path: '/dealer/business-info',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const BusinessInformationView()),
      ),
      GoRoute(
        path: '/dealer/payout-details',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const PayoutDetailsView()),
      ),
      GoRoute(
        path: '/dealer/store-profile',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const StoreProfileView()),
      ),
      GoRoute(
        path: '/dealer/identity-verification',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const IdentityVerificationView()),
      ),
      GoRoute(
        path: '/dealer/verification-progress',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const VerificationInProgressView()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          if (state.uri.path.startsWith('/dealer/scan') ||
              state.uri.path == '/dealer/my-finds') {
            return child;
          }

          return GlobalLayout(body: child);
        },
        routes: [
          GoRoute(
            path: '/homeScreen',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const HomeScreen()),
          ),
          GoRoute(
            path: '/dealer/orders',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const OrdersOverviewView()),
          ),
          // Placeholder routes so footer navigation has valid targets.
          GoRoute(
            path: '/dealer/my-finds',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: MyFindsView()),
          ),
          GoRoute(
            path: '/dealer/my-finds/item/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? '1';
              return slidePage(
                state: state,
                child: InventoryItemDetailView(itemId: id),
              );
            },
          ),
          GoRoute(
            path: '/dealer/market',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: MarketplaceView()),
          ),
          GoRoute(
            path: '/dealer/scan',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const AddNewItemView()),
          ),
          GoRoute(
            path: '/dealer/scan/camera',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const AiScannerView()),
          ),
          GoRoute(
            path: '/dealer/scan/gallery',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const UploadFromGalleryView()),
          ),
          GoRoute(
            path: '/dealer/scan/result',
            pageBuilder: (context, state) {
              final path = state.extra is String ? state.extra as String : null;
              return slidePage(
                state: state,
                child: AiScanResultView(imagePath: path),
              );
            },
          ),
          GoRoute(
            path: '/dealer/scan/result/additional-specifications',
            pageBuilder: (context, state) {
              final path = state.extra is String ? state.extra as String : null;
              return slidePage(
                state: state,
                child: AdditionalSpecificationsView(imagePath: path),
              );
            },
          ),
          GoRoute(
            path: '/dealer/edit-item',
            pageBuilder: (context, state) {
              final extra = state.extra;
              final data = (extra is Map ? extra : <String, dynamic>{}) as Map<String, dynamic>;
              return slidePage(
                state: state,
                child: EditItemView(
                  itemId: '0',
                  isNewItem: true,
                  listingData: data,
                ),
              );
            },
          ),
          GoRoute(
            path: '/dealer/messages',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const InboxView()),
          ),
        ],
      ),
      GoRoute(
        path: '/forgotPassword',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: '/checkEmail',
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return slidePage(
            state: state,
            child: CheckEmailScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: '/newPassword',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const NewPasswordScreen()),
      ),
      GoRoute(
        path: '/market/product/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slidePage(
            state: state,
            child: SingleProductView(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/market/cart',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const ShoppingCartView());
        },
      ),
      GoRoute(
        path: '/market/product/:id/offer',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slidePage(
            state: state,
            child: MakeOfferView(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/shipping',
        pageBuilder: (context, state) {
          return slidePage(
            state: state,
            child: const CheckoutView(step: CheckoutStep.shipping),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/payment',
        pageBuilder: (context, state) {
          return slidePage(
            state: state,
            child: const CheckoutView(step: CheckoutStep.payment),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/review',
        pageBuilder: (context, state) {
          return slidePage(
            state: state,
            child: const CheckoutView(step: CheckoutStep.review),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/success',
        pageBuilder: (context, state) {
          return slidePage(
            state: state,
            child: const CheckoutView(step: CheckoutStep.success),
          );
        },
      ),
      GoRoute(
        path: '/dealer/profile',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const ProfileView());
        },
      ),
      GoRoute(
        path: '/dealer/verification-status',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const VerificationStatusView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const AppSettingsView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/change-password',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const ChangePasswordView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/language',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const LanguageView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/two-factor-auth',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const TwoFactorAuthView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/two-factor-auth/setup',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const TFASetupView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/two-factor-auth/verify',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const TFAVerifyView());
        },
      ),
      GoRoute(
        path: '/dealer/app-settings/two-factor-auth/success',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const TFASuccessView());
        },
      ),
      GoRoute(
        path: '/dealer/editprofile',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: EditProfile());
        },
      ),
      GoRoute(
        path: '/dealer/order-history',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const OrderHistoryView());
        },
      ),
      GoRoute(
        path: '/dealer/achievements',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const AchievementsView());
        },
      ),
      GoRoute(
        path: '/dealer/membership-points',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const MembershipPointsView());
        },
      ),
      GoRoute(
        path: '/dealer/help-faq',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const HelpFaqView());
        },
      ),
      GoRoute(
        path: '/dealer/privacy-terms',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const PrivacyTermsView());
        },
      ),
      GoRoute(
        path: '/dealer/privacy-policy',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const PrivacyPolicyView());
        },
      ),
      GoRoute(
        path: '/dealer/purchase-history',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const PurchaseHistoryView());
        },
      ),
      GoRoute(
        path: '/dealer/reviews-ratings',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const ReviewsRatingsView());
        },
      ),
      GoRoute(
        path: '/dealer/rewards-achievements',
        pageBuilder: (context, state) {
          return slidePage(
            state: state,
            child: const RewardsAchievementsView(),
          );
        },
      ),
      GoRoute(
        path: '/dealer/order-history/track/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'VV789234';
          return slidePage(
            state: state,
            child: TrackOrderView(orderId: id),
          );
        },
      ),
      GoRoute(
        path: '/dealer/order-history/track/:id/review',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'VV789234';
          return slidePage(
            state: state,
            child: WriteReviewView(orderId: id),
          );
        },
      ),
      GoRoute(
        path: '/dealer/offers',
        pageBuilder: (context, state) {
          final tab = state.uri.queryParameters['tab'];
          final submitted = state.uri.queryParameters['submitted'] == '1';

          return slidePage(
            state: state,
            child: OffersView(
              initialTab: tab == 'send' ? OffersTab.send : OffersTab.received,
              showSubmittedToast: submitted,
            ),
          );
        },
      ),
      GoRoute(
        path: '/dealer/wallet',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const MyWalletView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/withdraw',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const WithdrawFundsView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/add',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const AddFundsView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/payment-method',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const PaymentMethodsView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/payment-method/add',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const AddPaymentMethodView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/escrow-payments',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const EscrowPaymentsView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/transaction-history',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const TransactionHistoryView());
        },
      ),
      GoRoute(
        path: '/dealer/wallet/release-payment',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final map = extra is Map ? extra : const <String, dynamic>{};
          return slidePage(
            state: state,
            child: ReleasePaymentView(
              orderId: (map['orderId'] as String?) ?? 'ORD-2024-1234',
              itemTitle:
                  (map['itemTitle'] as String?) ?? 'Victorian Pocket Watch',
              amount: (map['amount'] as String?) ?? '\$1450.00',
              seller: (map['seller'] as String?) ?? 'Heritage Antiques',
              date: (map['date'] as String?) ?? '2/8/2024',
            ),
          );
        },
      ),
      GoRoute(
        path: '/events',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: AllEventsView());
        },
      ),
      GoRoute(
        path: '/events/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slidePage(
            state: state,
            child: EventDetailView(eventId: id),
          );
        },
      ),
      GoRoute(
        path: '/single_message',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: SingleMessage());
        },
      ),
      GoRoute(
        path: '/dealer/notifications',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const DealerNotificationsView());
        },
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: const DealerNotificationsView());
        },
      ),
      GoRoute(
        path: '/dealer/orders/accept/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'ORD-2451';
          final extra = state.extra;
          final map = extra is Map ? extra : const <String, dynamic>{};

          return slidePage(
            state: state,
            child: AcceptOrderView(
              orderId: id,
              itemTitle:
                  (map['itemTitle'] as String?) ?? 'Victorian Mahogany Chair',
              priceText: (map['priceText'] as String?) ?? '\$850',
              ageText: (map['ageText'] as String?) ?? '2h ago',
              productImage:
                  (map['productImage'] as String?) ?? AppImages.productOne,
            ),
          );
        },
      ),
      GoRoute(
        path: '/dealer/my-finds/edit/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return slidePage(
            state: state,
            child: EditItemView(itemId: id),
          );
        },
      ),
      GoRoute(
        path: '/dealer/edit-item',
        pageBuilder: (context, state) {
          final extra = state.extra;
          final data = (extra is Map ? extra : <String, dynamic>{}) as Map<String, dynamic>;
          return slidePage(
            state: state,
            child: EditItemView(
              itemId: '0',
              isNewItem: true,
              listingData: data,
            ),
          );
        },
      ),
    ],
  );
}

CustomTransitionPage slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
