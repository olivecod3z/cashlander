import 'dart:ui';

//import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/models/income_model.dart';
//import 'package:cash_lander2/src/features/authentication/screens/income_category.dart' hide IncomeCategory;
//import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<IncomeCategory> theCategories = [
  IncomeCategory(
    incName: 'Primary Income',
    incIcon: PhosphorIconsBold.briefcase,
    incColor: Color(0xFF4ADE80),
    incSubCategories: [
      'Salary',
      'Wages',
      'Bonuses',
      'Commission',
      'Overtime Pay',
      'Freelance Projects',
      'Business Profits',
    ],
  ),
  IncomeCategory(
    incName: 'Passive Income',
    incIcon: PhosphorIconsBold.coins,
    incColor: Color(0xFFFACC15),
    incSubCategories: ['Interest', 'Dividends', 'Rental Income', 'Royalties'],
  ),
  IncomeCategory(
    incName: 'Social Media',
    incIcon: PhosphorIconsBold.camera,
    incColor: Color(0xFFEC4899),
    incSubCategories: [
      'YouTube Revenue',
      'TikTok Creator Fund',
      'Instagram Sponsorships',
      'Influencer Deals',
      'Affiliate Earnings',
      'Ad Revenue',
      'Livestream Tips',
    ],
  ),
  IncomeCategory(
    incName: 'Irregular Income',
    incIcon: PhosphorIconsBold.gift,
    incColor: Color(0xFFF97316),
    incSubCategories: [
      'Gifts',
      'Donations',
      'Refunds',
      'Rebates',
      'Item Sales',
      'One-off Jobs',
      'Tips (offline)',
      'Promo Cashback',
    ],
  ),
  IncomeCategory(
    incName: 'Crypto & Web3',
    incIcon: PhosphorIconsBold.currencyBtc,
    incColor: Color(0xFF8B5CF6),
    incSubCategories: [
      'Trading Profits',
      'Staking Rewards',
      'Airdrops',
      'NFT Sales',
    ],
  ),
  IncomeCategory(
    incName: 'Support & Allowance',
    incIcon: PhosphorIconsBold.handHeart,
    incColor: Color(0xFF60A5FA),
    incSubCategories: [
      'Allowance from Parents',
      'Spouse/Partner Support',
      'NYSC Allowance',
      'N-Power Payments',
      'Child Support',
    ],
  ),
  IncomeCategory(
    incName: 'Academic',
    incIcon: PhosphorIconsBold.bookmark,
    incColor: Color(0xFF22C55E),
    incSubCategories: [
      'Scholarships',
      'Grants',
      'Student Loans',
      'Education Stipends',
    ],
  ),
  IncomeCategory(
    incName: 'Claims & Payouts',
    incIcon: PhosphorIconsBold.shieldCheck,
    incColor: Color(0xFF9CA3AF),
    incSubCategories: [
      'Insurance Payouts',
      'Legal Settlements',
      'Compensations',
    ],
  ),
];
