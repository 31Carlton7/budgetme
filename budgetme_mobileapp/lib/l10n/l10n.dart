import 'package:intl/intl.dart';

//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names
class L10n {
  ///
  String get dashboard => Intl.message('Dashboard', name: 'dashboard', desc: '');

  ///
  String get monthlySavings => Intl.message('Monthly Savings', name: 'monthlySavings', desc: '');

  ///
  String get remainingBalance => Intl.message('Remaining Balance', name: 'remainingBalance', desc: '');

  ///
  String get totalSaved => Intl.message('Total Saved', name: 'totalSaved', desc: '');

  ///
  String get savingsGoals => Intl.message('Savings Goals', name: 'savingsGoals', desc: '');

  ///
  String get currentProgress => Intl.message('Current Progress', name: 'currentProgress', desc: '');

  ///
  String userPercentProgress(String percent) =>
      Intl.message('You are $percent% of the way there!', name: 'userPercentProgress', args: [percent], desc: '');

  ///
  String get timeLeft => Intl.message('Time Left', name: 'timeLeft', desc: '');

  ///
  String get years => Intl.message('Years', name: 'years', desc: '');

  ///
  String get months => Intl.message('Months', name: 'months', desc: '');

  ///
  String get days => Intl.message('Days', name: 'days', desc: '');

  ///
  String get hours => Intl.message('Hours', name: 'hours', desc: '');

  ///
  String get minutes => Intl.message('Minutes', name: 'minutes', desc: '');

  ///
  String get seconds => Intl.message('Seconds', name: 'seconds', desc: '');

  ///
  String get transactionHistory => Intl.message('Transaction History', name: 'transactionHistory', desc: '');

  ///
  String get seeAll => Intl.message('See All', name: 'seeAll', desc: '');

  ///
  String get transaction => Intl.message('Transaction', name: 'transaction', desc: '');

  ///
  String get editGoal => Intl.message('Edit Goal', name: 'editGoal', desc: '');

  ///
  String get deleteGoal => Intl.message('Delete Goal', name: 'deleteGoal', desc: '');

  ///
  String get next => Intl.message('Next', name: 'next', desc: '');

  ///
  String get skip => Intl.message('Skip', name: 'skip', desc: '');

  ///
  String get cancel => Intl.message('Cancel', name: 'cancel', desc: '');

  ///
  String get of => Intl.message('of', name: 'of', desc: '');

  ///
  String get create => Intl.message('Create', name: 'create', desc: '');

  ///
  String get edit => Intl.message('Edit', name: 'edit', desc: '');

  ///
  String get save => Intl.message('Save', name: 'save', desc: '');

  ///
  String get savingForQ => Intl.message('What are you saving for?', name: 'savingForQ', desc: '');

  ///
  String get howMuchNeededQ => Intl.message('How much money is needed?', name: 'howMuchNeededQ', desc: '');

  ///
  String get whenDeadlineQ => Intl.message('When is the deadline?', name: 'whenDeadlineQ', desc: '');

  ///
  String get howMuchSavedQ => Intl.message('How much money is currently saved?', name: 'howMuchSavedQ', desc: '');

  ///
  String get prefCurr => Intl.message('Select your Preferred Currency', name: 'prefCurr', desc: '');

  ///
  String get purchasePro => Intl.message('Purchase Pro�', name: 'purchasePro', desc: '');

  ///
  String get purchaseProText => Intl.message('Unlock unlimited Goals for just 2.99 USD 😆 Pay once, Pay forever',
      name: 'purchaseProText', desc: '');

  ///
  String get statistics => Intl.message('July Statistics', name: 'statistics', desc: '');

  ///
  String get settings => Intl.message('Settings', name: 'settings', desc: '');

  ///
  String get adjustMonthlySpendingLimit =>
      Intl.message('Adjust Monthly Spending Limit', name: 'adjustMonthlySpendingLimit', desc: '');

  ///
  String get about => Intl.message('About', name: 'about', desc: '');

  ///
  String get privacyPolicy => Intl.message('Privacy Policy', name: 'privacyPolicy', desc: '');

  ///
  String get support => Intl.message('Support', name: 'support', desc: '');

  ///
  String version(String number) => Intl.message('Version $number', name: 'version', args: [number], desc: '');

  ///
  String get profile => Intl.message('Profile', name: 'profile', desc: '');

  ///
  String get unlimitedGoals => Intl.message('Unlimited Goals', name: 'unlimitedGoals', desc: '');

  ///
  String get unlockText => Intl.message(
      'Unlock your true self with unlimited goals for a one-time purchase of just 2.99 USD! 😎 Note: Prices may vary in other currencie',
      name: 'unlockText',
      desc: '');

  ///
  String get purchase => Intl.message('Purchase', name: 'purchase', desc: '');

  ///
  String get pleaseNote => Intl.message(
      'Please note that increasing your weekly spending will make it harder to achieve goals and it is discouraged.',
      name: 'pleaseNote',
      desc: '');

  ///
  String get newMonthlySpendingLimit =>
      Intl.message('New Monthly Spending Limit', name: 'newMonthlySpendingLimit', desc: '');

  ///
  String get pressThePBtn =>
      Intl.message('Press the purple button to create a new Goal!', name: 'pressThePBtn', desc: '');

  ///
  String get search => Intl.message('Search', name: 'search', desc: '');

  ///
  String get finish => Intl.message('Finish', name: 'finish', desc: '');

  ///
  String pleaseEnterLess(String currency, String number) =>
      Intl.message('Please enter a value less than your required amount of $currency$number',
          name: 'pleaseEnterLess', args: [currency, number], desc: '');

  ///
  String get vacation => Intl.message('Vacation', name: 'vacation', desc: '');

  ///
  String get web => Intl.message('Web', name: 'web', desc: '');

  ///
  String get device => Intl.message('Device', name: 'device', desc: '');

  ///
  String get selectImage => Intl.message('Select Image', name: 'selectImage', desc: '');

  ///
  String get searchForImage =>
      Intl.message('Search for images on Unsplash using the search bar', name: 'searchForImage', desc: '');

  ///
  String get noResults => Intl.message('No Results', name: 'noResults', desc: '');

  ///
  String get done => Intl.message('Done', name: 'done', desc: '');

  ///
  String get remove => Intl.message('Remove', name: 'remove', desc: '');

  ///
  String get add => Intl.message('Add', name: 'add', desc: '');

  ///
  String get hideFrom => Intl.message('Hide from history', name: 'hideFrom', desc: '');

  ///
  String get deleteGoalQ => Intl.message('Delete Goal?', name: 'deleteGoalQ', desc: '');

  ///
  String get areYouSureDelQ => Intl.message('Are you sure want to delete your goal?', name: 'areYouSureDelQ', desc: '');

  ///
  String get delete => Intl.message('Delete', name: 'delete', desc: '');

  ///
  String get noTransactions => Intl.message('No transactions have been made...yet!', name: 'noTransactions', desc: '');

  ///
  String get congratulations =>
      Intl.message('Congratulations on completing your goal! �', name: 'congratulations', desc: '');

  ///
  String get startNewGoal => Intl.message('Start new goal', name: 'startNewGoal', desc: '');
}
