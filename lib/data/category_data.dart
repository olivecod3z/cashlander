import 'package:cash_lander2/src/constants/colors.dart';
import 'package:cash_lander2/src/features/authentication/models/expense_model.dart';
//import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final List<BudgetCategory> allCategories = [
  BudgetCategory(
    name: 'Feeding',
    icon: PhosphorIconsFill.bowlFood,
    color: foodColor,
    subCategories: [
      "Market food items",
      "Supermarket groceries",
      "Snacks and drinks",
      "Fast food / Restaurants",
    ],
  ),
  BudgetCategory(
    name: 'Transportation',
    icon: PhosphorIconsFill.car,
    color: transColor,
    subCategories: [
      "Fuel",
      "Public transport",
      "Bolt / Uber rides",
      "Intercity travel (Sienna, Flights)",
    ],
  ),
  BudgetCategory(
    name: 'Personal Care',
    icon: PhosphorIconsFill.heart,
    color: careColor,
    subCategories: [
      "Hair & skin",
      "Skincare",
      "Makeup / Beauty",
      "Clothes & Shoes",
    ],
  ),
  BudgetCategory(
    name: 'Rent/Housing',
    icon: PhosphorIconsFill.house,
    color: rentColor,
    subCategories: [
      "House rent",
      "Agent / Agreement fees",
      "Repairs and maintenance",
    ],
  ),
  BudgetCategory(
    name: 'Utility Bills',
    icon: PhosphorIconsFill.lightning,
    color: utilColor,
    subCategories: [
      "Electricity",
      "Generator fuel / Maintenance",
      "Water",
      "Waste disposal",
    ],
  ),
  BudgetCategory(
    name: 'Mobile & Internet',
    icon: PhosphorIconsFill.wifiHigh,
    color: internetColor,
    subCategories: [
      "Airtime",
      "Data bundle",
      "Wi-Fi subscriptions",
      "Starlink",
    ],
  ),
  BudgetCategory(
    name: 'Savings',
    icon: PhosphorIconsFill.piggyBank,
    color: saveColor,
    subCategories: ["Emergency fund", "Fixed savings", "Target savings"],
  ),
  BudgetCategory(
    name: 'Investments',
    icon: PhosphorIconsFill.trendUp,
    color: investColor,
    subCategories: ["Crypto", "Stocks", "Real estate"],
  ),
  BudgetCategory(
    name: 'Charity',
    icon: PhosphorIconsFill.handHeart,
    color: charityColor,
    subCategories: [],
  ),

  BudgetCategory(
    name: 'Health',
    icon: PhosphorIconsFill.firstAid,
    color: healthColor,
    subCategories: [
      "Hospital visits",
      "Medications / Prescriptions",
      "Insurance",
    ],
  ),
  BudgetCategory(
    name: 'Subscriptions',
    icon: PhosphorIconsFill.musicNotesSimple,
    color: subscriptColor,
    subCategories: ["Netflix", "Spotify", "Decoder", "Other app subscriptions"],
  ),
  BudgetCategory(
    name: 'Repairs',
    icon: PhosphorIconsFill.wrench,
    color: repairColor,
    subCategories: [],
  ),
  BudgetCategory(
    name: 'Education',
    icon: PhosphorIconsFill.book,
    color: eduColor,
    subCategories: ["School fees", "Online courses", "Books & study materials"],
  ),
  BudgetCategory(
    name: 'Big Purchases',
    icon: PhosphorIconsFill.shoppingCart,
    color: bigPurColor,
    subCategories: ["New gadget / Appliance"],
  ),
  BudgetCategory(
    name: 'Family Support',
    icon: PhosphorIconsFill.usersThree,
    color: famColor,
    subCategories: ["Black tax"],
  ),
  BudgetCategory(
    name: 'Loan Repayment',
    icon: PhosphorIconsFill.creditCard,
    color: loanColor,
    subCategories: [],
  ),
  BudgetCategory(
    name: 'Events / Gifts',
    icon: PhosphorIconsFill.gift,
    color: giftColor,
    subCategories: [],
  ),
  BudgetCategory(
    name: 'Business Expenses',
    icon: PhosphorIconsFill.briefcase,
    color: expColor,
    subCategories: ["Personal"],
  ),
  BudgetCategory(
    name: 'Miscellaneous',
    icon: PhosphorIconsFill.dotsThree,
    color: misColor,
    subCategories: [],
  ),
];
