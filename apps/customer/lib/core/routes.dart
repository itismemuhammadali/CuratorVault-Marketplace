import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_app/core/components/global_layout/main_layout.dart';
import 'package:vintage_app/features/auth_screens/login.dart';
import 'package:vintage_app/features/auth_screens/check_email.dart';
import 'package:vintage_app/features/auth_screens/forgot_password.dart';
import 'package:vintage_app/features/auth_screens/new_password.dart';
import 'package:vintage_app/features/intro/intro_slider.dart';
import 'package:vintage_app/features/intro/splash.dart';
import 'package:vintage_app/features/messages/chat_screen.dart';
import 'package:vintage_app/features/messages/single_message.dart';
import 'package:vintage_app/features/user_flow/events/all_events_view.dart';
import 'package:vintage_app/features/user_flow/events/event_detail_view.dart';
import 'package:vintage_app/features/user_flow/events/event_participants_view.dart';
import 'package:vintage_app/features/user_flow/home/home_view.dart';
import 'package:vintage_app/features/user_flow/marketplace/checkout_view.dart';
import 'package:vintage_app/features/user_flow/marketplace/make_offer_view.dart';
import 'package:vintage_app/features/user_flow/marketplace/marketplace_tab_view.dart';
import 'package:vintage_app/features/user_flow/marketplace/shopping_cart_view.dart';
import 'package:vintage_app/features/user_flow/marketplace/single_product_view.dart';
import 'package:vintage_app/features/user_flow/my_finds/edit_item_view.dart';
import 'package:vintage_app/features/user_flow/my_finds/inventory_item_detail_view.dart';
import 'package:vintage_app/features/user_flow/my_finds/my_finds_view.dart';
import 'package:vintage_app/features/user_flow/my_finds/offers_view.dart';
import 'package:vintage_app/features/user_flow/profile/accept_order_view.dart';
import 'package:vintage_app/features/user_flow/profile/achievements_view.dart';
import 'package:vintage_app/features/user_flow/profile/change_password_view.dart';
import 'package:vintage_app/features/user_flow/profile/edit_profile.dart';
import 'package:vintage_app/features/user_flow/profile/help_faq_view.dart';
import 'package:vintage_app/features/user_flow/profile/language_view.dart';
import 'package:vintage_app/features/user_flow/profile/membership_points_view.dart';
import 'package:vintage_app/features/user_flow/profile/membership_rewards_view.dart';
import 'package:vintage_app/features/user_flow/profile/order_history_view.dart';
import 'package:vintage_app/features/user_flow/profile/orders_overview_view.dart';
import 'package:vintage_app/features/user_flow/profile/privacy_policy_view.dart';
import 'package:vintage_app/features/user_flow/profile/privacy_and_terms_view.dart';
import 'package:vintage_app/features/user_flow/profile/purchase_history_view.dart';
import 'package:vintage_app/features/user_flow/profile/settings_view.dart';
import 'package:vintage_app/features/user_flow/profile/profile_view.dart';
import 'package:vintage_app/features/user_flow/profile/reviews_ratings_view.dart';
import 'package:vintage_app/features/user_flow/profile/rewards_achievements_view.dart';
import 'package:vintage_app/features/user_flow/profile/tfa_setup_view.dart';
import 'package:vintage_app/features/user_flow/profile/tfa_success_view.dart';
import 'package:vintage_app/features/user_flow/profile/tfa_verify_view.dart';
import 'package:vintage_app/features/user_flow/profile/track_order_view.dart';
import 'package:vintage_app/features/user_flow/profile/two_factor_auth_view.dart';
import 'package:vintage_app/features/user_flow/profile/write_review_view.dart';
import 'package:vintage_app/features/user_flow/scan/add_new_item_view.dart';
import 'package:vintage_app/features/user_flow/scan/ai_scan_result_view.dart';
import 'package:vintage_app/features/user_flow/scan/ai_scanner_view.dart';
import 'package:vintage_app/features/user_flow/scan/upload_from_gallery_view.dart';
import 'package:vintage_app/features/user_flow/wallet/add_funds_view.dart';
import 'package:vintage_app/features/user_flow/wallet/add_payment_method_view.dart';
import 'package:vintage_app/features/user_flow/wallet/escrow_payments_view.dart';
import 'package:vintage_app/features/user_flow/wallet/my_wallet_view.dart';
import 'package:vintage_app/features/user_flow/wallet/payment_methods_view.dart';
import 'package:vintage_app/features/user_flow/wallet/release_payment_view.dart';
import 'package:vintage_app/features/user_flow/wallet/transaction_history_view.dart';
import 'package:vintage_app/features/user_flow/wallet/withdraw_funds_view.dart';
import 'package:vintage_app/features/notifications/notifications_view.dart';


class Routes {
  static GoRouter routes = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/introSlider', builder: (context, state) => IntroSlider()),
      GoRoute(
        path: "/login",
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const LoginScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          if (state.uri.path.startsWith('/user/scan')) {
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
          // Placeholder routes so footer navigation has valid targets.
          GoRoute(
            path: '/user/my-finds',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: MyFindsView()),
          ),
          GoRoute(
            path: '/user/market',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: MarketplaceView()),
          ),
          GoRoute(
            path: '/user/profile',
            pageBuilder: (context, state) =>
                slidePage(state: state, child: const ProfileView()),
          ),
          GoRoute(
            path: '/user/scan',
            pageBuilder: (context, state) {
              return slidePage(
                state: state,
                child: const AddNewItemView(),
              );
            },
          ),
          GoRoute(
            path: '/user/scan/camera',
            pageBuilder: (context, state) {
              return slidePage(
                state: state,
                child: const AiScannerView(),
              );
            },
          ),
          GoRoute(
            path: '/user/scan/gallery',
            pageBuilder: (context, state) {
              return slidePage(
                state: state,
                child: const UploadFromGalleryView(),
              );
            },
          ),
          GoRoute(
            path: '/user/scan/crop',
            pageBuilder: (context, state) {
              final imagePath = state.extra is String ? state.extra as String : '';
              return slidePage(
                state: state,
                child: AiScannerView(imagePath: imagePath),
              );
            },
          ),
          GoRoute(
            path: '/user/scan/result',
            pageBuilder: (context, state) {
              final path = state.extra is String ? state.extra as String : null;
              return slidePage(
                state: state,
                child: AiScanResultView(imagePath: path),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/user/cart',
        pageBuilder: (context, state) => slidePage(state: state, child: ShoppingCartView()),
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
        path: '/user/editprofile',
        pageBuilder: (context, state) {
          return slidePage(state: state, child: EditProfile());
        },
      ),
      GoRoute(
          path: '/events',
          pageBuilder: (context, state) {
            return slidePage(state: state, child: AllEventsView());
          }
      ),
      GoRoute(
        path: '/user/chat',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const ChatScreen()),
      ),
      GoRoute(
        path: '/user/notifications',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const NotificationsView()),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) =>
            slidePage(state: state, child: const NotificationsView()),
      ),
      GoRoute(
        path: '/single_message',

        pageBuilder: (context, state) {
          return slidePage(state: state, child: SingleMessage());
        },
      ),
      GoRoute(
        path: '/user/wallet',
        pageBuilder: (context, state) => slidePage(state: state, child: const MyWalletView()),
      ),
      GoRoute(
        path: '/user/wallet/add-funds',
        pageBuilder: (context, state) => slidePage(state: state, child: const AddFundsView()),
      ),
      GoRoute(
        path: '/user/wallet/withdraw',
        pageBuilder: (context, state) => slidePage(state: state, child: const WithdrawFundsView()),
      ),
      GoRoute(
        path: '/user/wallet/transactions',
        pageBuilder: (context, state) => slidePage(state: state, child: const TransactionHistoryView()),
      ),
      GoRoute(
        path: '/user/wallet/release-payment',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const ReleasePaymentView(
            orderId: 'ORD-1001',
            itemTitle: 'Vintage Watch',
            amount: '\$450',
            date: 'May 12, 2026',
            seller: 'Classic Timepieces',
          ),
        ),
      ),
      GoRoute(
        path: '/user/wallet/escrow',
        pageBuilder: (context, state) => slidePage(state: state, child: const EscrowPaymentsView()),
      ),
      GoRoute(
        path: '/user/wallet/payment-methods',
        pageBuilder: (context, state) => slidePage(state: state, child: const PaymentMethodsView()),
      ),
      GoRoute(
        path: '/user/wallet/add-payment-method',
        pageBuilder: (context, state) => slidePage(state: state, child: const AddPaymentMethodView()),
      ),
      GoRoute(
        path: '/user/checkout',
        pageBuilder: (context, state) {
          String? productId;
          if (state.extra is Map) {
            productId = (state.extra as Map)['productId'] as String?;
          }
          return slidePage(
            state: state,
            child: CheckoutView(step: CheckoutStep.shipping, productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/shipping',
        pageBuilder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return slidePage(
            state: state,
            child: CheckoutView(step: CheckoutStep.shipping, productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/payment',
        pageBuilder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return slidePage(
            state: state,
            child: CheckoutView(step: CheckoutStep.payment, productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/review',
        pageBuilder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return slidePage(
            state: state,
            child: CheckoutView(step: CheckoutStep.review, productId: productId),
          );
        },
      ),
      GoRoute(
        path: '/market/checkout/success',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const CheckoutView(step: CheckoutStep.success),
        ),
      ),

      GoRoute(
        path: '/user/make-offer',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const MakeOfferView(productId: '1'),
        ),
      ),
      GoRoute(
        path: '/user/orders',
        pageBuilder: (context, state) => slidePage(state: state, child: const OrdersOverviewView()),
      ),
      GoRoute(
        path: '/user/orders/history',
        pageBuilder: (context, state) {
          String? from;
          if (state.extra is Map) {
            from = (state.extra as Map)['from'] as String?;
          }
          return slidePage(state: state, child: OrderHistoryView(from: from));
        },
      ),
      GoRoute(
        path: '/user/orders/accept',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const AcceptOrderView(
            orderId: 'ORD-1001',
            itemTitle: 'Vintage Leather Jacket',
            priceText: '\$250',
            ageText: '1970s',
            productImage: 'assets/images/user.png',
          ),
        ),
      ),
      GoRoute(
        path: '/user/orders/track/:orderId',
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? 'ORD-1001';
          return slidePage(
            state: state,
            child: TrackOrderView(orderId: orderId),
          );
        },
      ),
      GoRoute(
        path: '/user/write-review',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const WriteReviewView(orderId: 'ORD-1001'),
        ),
      ),
      GoRoute(
        path: '/user/reviews',
        pageBuilder: (context, state) => slidePage(state: state, child: const ReviewsRatingsView()),
      ),
      GoRoute(
        path: '/user/membership-points',
        pageBuilder: (context, state) => slidePage(state: state, child: const MembershipPointsView()),
      ),
      GoRoute(
        path: '/user/achievements',
        pageBuilder: (context, state) => slidePage(state: state, child: const AchievementsView()),
      ),
      GoRoute(
        path: '/user/rewards-achievements',
        pageBuilder: (context, state) => slidePage(state: state, child: const RewardsAchievementsView()),
      ),
      GoRoute(
        path: '/user/app-settings',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const SettingsView(),
        ),
      ),
      GoRoute(
        path: '/user/change-password',
        pageBuilder: (context, state) => slidePage(state: state, child: const ChangePasswordView()),
      ),
      GoRoute(
        path: '/user/language',
        pageBuilder: (context, state) => slidePage(state: state, child: const LanguageView()),
      ),
      GoRoute(
        path: '/user/help-faq',
        pageBuilder: (context, state) => slidePage(state: state, child: const HelpFaqView()),
      ),
      GoRoute(
        path: '/user/privacy-policy',
        pageBuilder: (context, state) => slidePage(state: state, child: const PrivacyPolicyView()),
      ),
      GoRoute(
        path: '/user/privacy-terms',
        pageBuilder: (context, state) => slidePage(state: state, child: const PrivacyAndTermsView()),
      ),
      GoRoute(
        path: '/user/membership-rewards',
        pageBuilder: (context, state) => slidePage(state: state, child: const MembershipRewardsView()),
      ),
      GoRoute(
        path: '/user/purchase-history',
        pageBuilder: (context, state) => slidePage(state: state, child: const PurchaseHistoryView()),
      ),
      GoRoute(
        path: '/user/tfa-setup',
        pageBuilder: (context, state) => slidePage(state: state, child: const TFASetupView()),
      ),
      GoRoute(
        path: '/user/tfa-verify',
        pageBuilder: (context, state) => slidePage(state: state, child: const TFAVerifyView()),
      ),
      GoRoute(
        path: '/user/tfa-success',
        pageBuilder: (context, state) => slidePage(state: state, child: const TFASuccessView()),
      ),
      GoRoute(
        path: '/user/2fa',
        pageBuilder: (context, state) => slidePage(state: state, child: const TwoFactorAuthView()),
      ),
      GoRoute(
        path: '/user/my-finds/offers',
        pageBuilder: (context, state) {
          String? tabParam;
          if (state.extra is Map) {
            tabParam = (state.extra as Map)['tab'] as String?;
          }
          final initialTab = tabParam == 'send' ? OffersTab.send : OffersTab.received;
          return slidePage(
            state: state,
            child: OffersView(initialTab: initialTab),
          );
        },
      ),
      GoRoute(
        path: '/user/my-finds/detail',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const InventoryItemDetailView(itemId: '1'),
        ),
      ),
      GoRoute(
        path: '/user/my-finds/edit',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const EditItemView(itemId: '1'),
        ),
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
        path: '/events/participants',
        pageBuilder: (context, state) => slidePage(
          state: state,
          child: const EventParticipantsView(eventId: '1'),
        ),
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
