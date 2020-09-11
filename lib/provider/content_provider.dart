import 'package:donorapp/modals/bottom_nav_bar.dart';
import 'package:donorapp/modals/favourite_chat.dart';
import 'package:donorapp/modals/medical.dart';
import 'package:donorapp/modals/news.dart';
import 'package:donorapp/modals/profile_info.dart';
import 'package:donorapp/modals/testimonies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Weight {Yes, No}

enum Egg {Yes, No}

enum Cancer {Yes, No}

class ContentProvider extends ChangeNotifier {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBottomNavVisible;
  bool get isBottomNavVisible => _isBottomNavVisible;
  String photoUrl = '';

  ContentProvider() {
    _isBottomNavVisible = true;
  }

  void notShowBottomNavBar() {
    _isBottomNavVisible = false;
    notifyListeners();
  }

  void showBottomNavBar() {
    _isBottomNavVisible = true;
    notifyListeners();
  }

  bool showListView(bool show) {
    notifyListeners();
    return show;
  }

  String about = 'The DONOR is an application where legitimate donors of blood, '
      'kidneys, liver  e.t.c can be found by recipients. Recipients can call, '
      'and chat using the application chat. You can also make request for donors.';

  List<String> text = [
    'Did you just recovered from Covid-19?',
    'Help others surviving by donating your plasma.',
    'Let\'s fight it together and the world a better place.',
    'When you are in a situation of seeking blood for yourself or a ',
    'family member, you are left with very little time to find a donor',
  ];

  List<IconData> socialMediaIcon = [
    FontAwesomeIcons.facebook,
    FontAwesomeIcons.twitter,
    FontAwesomeIcons.instagram
  ];
  //Profile Colors
  List<Color> randColors = [Colors.amber, Colors.blue, Colors.green];

  List<ProfileInfo> profileInfo = [
    ProfileInfo(value: 'O+', tag: 'Blood Group'),
    ProfileInfo(value: 'Male', tag: 'Gender'),
    ProfileInfo(value: '25', tag: 'Age'),
    ProfileInfo(value: '1.7 ft', tag: 'Height'),
    ProfileInfo(value: '73 kg', tag: 'Weight'),
    ProfileInfo(value: '10', tag: 'Donation Times'),
  ];
  String profileQuote = 'The blood you donate gives someone another change'
      ' of life on day that someone maybe a close relative, a friend, a loved one '
      ' or even you. So you never can tell who.';
  String profileQuote2 = 'Give yourself and those in need an elixir of life by pledging your organs. '
      'Live life after death - pledge to donate your body.\n\nMohith Agadi & Amit Abraham';

  List<String> sponsors = ['ibmlogo.png','microsoftlogo.png','itflogo.png',
    'niinelogo.png','nepclogo.png','globallogo.png','afrilabslogo.png',
    'twentyfirstlogo.png','bank_of_industry.png','startuplogo.png',];

  List<Medical> medPersonal = [
    Medical(picture: 'images/doctor_1.jpeg', name: 'Dr. Yakubu Wilson', position: 'Medical Personnel'),
    Medical(picture: 'images/doctor_2.jpeg', name: 'Dr. Ojone William', position: 'Medical Personnel'),
    Medical(picture: 'images/doctor_3.jpeg', name: 'Dr. Timonthy Paul', position: 'Medical Personnel'),
    Medical(picture: 'images/doctor_4.jpeg', name: 'Dr. Bethy Sheriff', position: 'Medical Personnel'),
    Medical(picture: 'images/doctor_5.png', name: 'Dr. Mohammed Abdul', position: 'Medical Personnel'),
    Medical(picture: 'images/developer.jpg', name: 'Vicolas Akoh', position: 'Developer'),
  ];

  List<BottomNavItems> bottomNavIcons = [
    BottomNavItems(icon: Icons.supervisor_account, title: 'AboutUs', showTitle: true),
    BottomNavItems(icon: FontAwesomeIcons.search, title: 'Search', showTitle: true),
    BottomNavItems(icon: FontAwesomeIcons.home, title: 'Home', showTitle: true),
    BottomNavItems(icon: Icons.chat_bubble, title: 'Chat', showTitle: true),
    BottomNavItems(icon: Icons.settings, title: 'Settings', showTitle: true),
  ];

  List<Testimonies> testimonies = [
    Testimonies(condition: 'Thoracic Outlet Syndrome', story: 'Now I walk with people as a normal person, '
    'not as someone who is different in terms of appearance or health.', testifier: 'Mohammad A.' ),
    Testimonies(condition: 'Aortic Dissection', story: 'I\'m definitely not one to sweat the small stuff anymore. I can\'t '
        'describe how great it is to be able to go home to your wife, kids and family and get back to normal life.', testifier: 'Rodney M.' ),
    Testimonies(condition: 'Atrial Fibrillation (AFib)', story: 'Before I met Dr. Calkins, I felt tired, depressed and couldn’t live my life '
        'to the fullest. My AFib was greatly impacting my quality of life.', testifier: 'Sani Ibrahim' ),
    Testimonies(condition: 'Mitral Valve Defect', story: 'As a business owner and father of two active teenage daughters, the thought of such '
        'invasive surgery and potentially difficult recovery was very concerning to me.', testifier: 'Kevin Zupnik' ),
    Testimonies(condition: 'Thoracic Outlet Syndrome', story: 'I was by far the youngest woman in the yoga class, only in my 40s, while the others were mostly in their 70s. '
        'I had to leave the class because I was experiencing painful tingling in my arms while trying to do the poses that required me to keep my arms outstretched, making it impossible to continue.', testifier: 'Melissa' ),
    Testimonies(condition: 'Thoracic Outlet Syndrome', story: 'When Peyton was 12, she started experiencing tingling in her fingers and an uncomfortable sensation in her rib cage.', testifier: 'Matthew Eze' ),
  ];

  List<News> news = [
    News(picture: 'images/newspic1.jpg', title: 'Coronavirus safety for donors', article: 'We have put extra safety measures in place at our '
        'donation venues. Find out what we are doing to keep blood donation continuing as normal.'),
    News(picture: 'images/newspic2.jpg', title: 'We need black donors', article: 'Some rare blood types that are more common in people of'
        'black heritage are in demand.'),
    News(picture: 'images/newspic3.jpg', title: 'Cancelled appointments', article: 'Sorry if your donation has been cancelled. Keeping donors '
        'two metres apart has meant reducing appointments.'),
    News(picture: 'images/newspic4.jpg', title: 'Who can give blood?', article: 'Most people can give blood if they are fit and healthy. Check you can give.'),
    News(picture: 'images/newspic5.jpg', title: 'Get the Donor Give Blood App', article: 'If you already have an online account why not download our Apple or '
        'Android app to book and manage your appointments.'),
    News(picture: 'images/newspic6.png', title: 'We need black donors', article: 'Some rare blood types that are more common in people of'
        'black heritage are in demand.'),
  ];

  List<FavouriteChat> favouriteChats = [
    FavouriteChat(profilePicture: 'images/profile_pic.jpg', profileName: 'Wisdom Peters'),
    FavouriteChat(profilePicture: 'images/profile_pic_1.jpg', profileName: 'Samson Lukeman'),
    FavouriteChat(profilePicture: 'images/profile_pic_2.jpg', profileName: 'Mary Steve'),
    FavouriteChat(profilePicture: 'images/profile_pic_3.jpg', profileName: 'Samuel Williams'),
    FavouriteChat(profilePicture: 'images/profile_pic_4.jpg', profileName: 'Elisha Wilson'),
    FavouriteChat(profilePicture: 'images/profile_pic_5.jpg', profileName: 'Sarah Peters'),
    FavouriteChat(profilePicture: 'images/profile_pic_6.jpg', profileName: 'Ayodeji Adams'),
    FavouriteChat(profilePicture: 'images/profile_pic_7.jpg', profileName: 'Marvellous Lukeman'),
    FavouriteChat(profilePicture: 'images/profile_pic_8.jpg', profileName: 'John Silver'),
    FavouriteChat(profilePicture: 'images/profile_pic_9.jpg', profileName: 'Eve Michael'),
    FavouriteChat(profilePicture: 'images/profile_pic_10.jpg', profileName: 'Rachel Isaac'),
    FavouriteChat(profilePicture: 'images/profile_pic_11.jpg', profileName: 'Godfrey Emma'),
    FavouriteChat(profilePicture: 'images/profile_pic_12.jpg', profileName: 'Rose Emma'),
  ];

  String textSpan_1 = "Did you recovered from COVID-19? Then you have the option to help patients battling "
      "with the disease by donating your plasma. Since you battled the disease, your plasma presently "
      "contains COVID-19 antibodies. These antibodies gave one path to your insusceptible immune body system "
      "to battle the infection when you were wiped out, so your plasma will help other people fight off the ailment\n\n";

  String textSpan_2 = "Healing plasma is the fluid piece of blood that is gathered from patients just recovered from the "
      "novel coronavirus illness, COVID-19, brought about by the infection SARS-CoV-2. COVID-19 patients create antibodies "
      "in the blood against the infection. Antibodies are proteins that may help battle the disease. Improving plasma is being"
      " researched for the treatment of COVID-19 in light of the fact that there is no affirmed treatment for this infection for "
      "now and there is some data that recommends it may enable a few patients to recovered from COVID-19. \n\n";

  String textSpan_3 = "Individuals who have completely recovered from COVID-19 for in any event fourteen (14) days are urged to "
      "consider giving plasma, which may help spare the lives of different patients. COVID-19 improving plasma should possibly be "
      "gathered from recouped people in the event that they are qualified to give blood. People more likely than not had an earlier "
      "conclusion of COVID-19 recorded by a research facility test and meet other benefactor measures. People must have total goal of "
      "side effects for at any rate 14 days before gift. A negative lab test for dynamic COVID-19 infection isn't important to fit the "
      "bill for gift.\n\n";

  String textSpan_4 = "You can consider giving blood! One blood gift can set aside to three lives. The COVID-19 pandemic has made phenomenal "
      "difficulties the U.S. blood gracefully. Giver focuses have encountered an emotional decrease in gifts because of the execution of social "
      "separating and the retraction of blood drives. Blood is required each day to give lifesaving medicines to an assortment of patients. You "
      "can help guarantee that blood keeps on being accessible for patients by finding a blood benefactor focus close to you to plan your gift. "
      "A few locales additionally have data about giving plasma.\n\n";

  String textSpan_5 = "Organ donation happens simply after life-supporting treatment has been halted, when the breathing and heartbeat  have "
      "stopped, and demise has been pronounced. Demise is proclaimed:\n - when the brain or mind lost it's function or \n- when breathing and the "
      "heart hault irrevocably which signifies death.\n\n";

  String textSpan_6 = "As a result of the passionate pressure included, settling on a choice about donating organs and tissues can be exceptionally "
      "hard. Your misfortune might be made simpler by realizing that you are following the desires of your adored one. The individual may have "
      "conversed with you about organ and tissue gift, or may have marked a contributor card.\n\n";

  String textSpan_7 = "In the event that you don't have the foggiest idea about your adored one's desires precisely, you should settle on the "
      "best choice that you can from what you think about your cherished one's qualities and your own.\n\n";

  String textSpan_8 = "Families who give organs and tissues gain comfort from realizing that the demise of somebody dear to them will help "
      "other people, and that their cherished one will leave a heritage by sparing the life of somebody who needs and organ or tissue relocate.\n";

  String textSpan_9 = "A doctor or donation facilitator may talk about the alternative to give your cherished one's organs and tissues after the "
      "individual in question passes on. Your endorsement and composed assent are required for organ and tissue donation.\n\n";

  String textSpan_10 = "You will be posed inquiries about your relative's clinical and social history. These inquiries must be posed in the event "
      "that there are clinical reasons why your cherished one's organs and tissues can't be utilized for transplantation.\n\n";

  String textSpan_11 = "Every emergency clinic observes set principles (called conventions) for organ and tissue gift. While the guidelines may "
      "vary somewhat from emergency clinic to medical clinic, they are composed to manage the consideration given to your adored one. You ought "
      "to have the option to see a duplicate of the convention that your clinic follows. The convention depicts the way toward setting up your "
      "adored one for organ and tissue donation.\n\n";

  String textSpan_12 = "The achievement of a transfer relies upon numerous elements. A significant one is the means by which well organs and tissues "
      "are kept up until they are evacuated. To keep organs and tissues solid, certain systems might be done before life-continuing help is pulled "
      "back or after death has been announced. These strategies are not part of the clinical consideration of your adored one, and include:\n";

  String textSpan_13 = "- Blood and other lab tests done to ensure your adored one meets the clinical rules for gift.\n- A cylinder called a catheter "
      "or cannula embedded into an enormous vein. This cylinder conveys liquids that help to save the organs after death has happened. \n- Prescription: "
      "Certain medications help increment the blood flexibly to organs. Heparin is a medication that prevents the blood from coagulating. "
      "Phentolamine is a medication that causes the veins to extend (expand). Choices to utilize these medications are presented on a defense "
      "by-case premise.\n\n";

  String textSpan_14 = "You might need to be with your adored one when life-continuing help is evacuated and the individual passes on. You can mastermind this "
      "with the clinical group thinking about your relative. Organs and tissues are expelled rapidly after death has happened. The clinical group centers "
      "altogether around thinking about your adored one. The specialist answerable for protecting and expelling the organs won't be equivalent to the '"
      "specialist who deals with you cherished one or the specialist who pronounces demise.\n\n";

  String textSpan_15 = "Passing for the most part happens not long after life-continuing help is halted, however now and again it might take a couple of "
      "hours. In the event that this occurs, the organs and tissues may not stay solid enough for transplantation.";

  String textSpan_16 = "First-time donates are acknowledged between the ages of 17 - 65, anyway you can be a still be a donor at age 16. Once you are a "
      "donor, you may proceed until any age, provided are donating like at least once in every two years.\n\n";

  String textSpan_17 = "The amount you gauge impacts how much blood you have. It's very important we don't take an excessive amount of blood or you could "
      "feel unwell. Any donor whose weight is below 50kg can't donate.\n\n";

  String textSpan_18 = "In case you had blood transfusion before. Unfortunately we can't accept your donatation.\n\n";

  String textSpan_19 = "If you had been diagnosed of cancer before other than basal cell carcinoma or cervical carcinoma insitu, unfortunately we can not accept your donation."
      "This is for the safety of both the receiver and the you the donor. Prevention is better than cure.\n\n";


  //Show Spinner
  bool showSpinner = false;
  void displaySpinner() {
    showSpinner = true;
  }

  void notDisplaySpinner() {
    showSpinner = false;
  }

  var isVisible = true;

  void showVisibilityOrgan() {
    isVisible = false;
    notifyListeners();
  }

  void showVisibilityBlood() {
    isVisible = true;
    notifyListeners();
  }

  Weight weight = Weight.Yes;
  Egg egg = Egg.Yes;
  Cancer cancer = Cancer.Yes;

  void weightAns(value) {
    weight = value;
    notifyListeners();
  }

  void eggAns(value) {
    egg = value;
    notifyListeners();
  }

  void cancerAns(value) {
    cancer = value;
    notifyListeners();
  }

  String defaultValue = 'Nigeria';

  void newDefaultValue (String newValue) {
    defaultValue = newValue;
    notifyListeners();
  }

  String bloodValue = 'O+';
  void newBloodValue (String newValue) {
    bloodValue = newValue;
    notifyListeners();
  }

  int age = 16;
  void ageValue (newValue) {
    age = newValue;
    notifyListeners();
  }

  int day = 1;
  void dayValue (newValue) {
    day = newValue;
    notifyListeners();
  }

  String month = 'January';
  void monthValue (String newValue) {
    month = newValue;
    notifyListeners();
  }

  String gender = 'Male';
  void genderValue(value) {
    gender = value;
    notifyListeners();
  }

  List<String> genders = ['Male','Female'];

  List<String> bloodType = ['A+','A-','B+','B-','AB+','AB-','O+','O-'];

  List<String> months = ['January','February','March','April','May','June',
    'July','August', 'September','October','November','December'];

  List<String> humanHeights = ['1.0', '1.1', '1.2', '1.3', '1.4', '1.5', '1.6', '1.7', '1.8', '1.9', '2.0'];

  List<String> organs = ['Liver','Kidney','Pancreas','Heart','Bone','Lung'];
  List<bool> organValue = [false, false, false, false, false, false];

  void organsChange(value, idx) {
    organValue[idx] = value;
    notifyListeners();
  }

  int year = 1990;
  void yearValue (newValue) {
    year = newValue;
    notifyListeners();
  }

  List<String> countryList = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas (the)",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia (Plurinational State of)",
    "Bonaire, Sint Eustatius and Saba",
    "Bosnia and Herzegovina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory (the)",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cayman Islands (the)",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos",
    "Colombia",
    "Comoros (the)",
    "Congo",
    "Cook Islands (the)",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Curaçao",
    "Cyprus",
    "Czechia",
    "Côte d'Ivoire",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini",
    "Ethiopia",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Polynesia",
    "Gabon",
    "Gambia (the)",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea (North)",
    "Korea (South)",
    "Kuwait",
    "Kyrgyzstan",
    "Lao",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macao",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Romania",
    "Russian",
    "Rwanda",
    "Réunion",
    "Saint Barthélemy",
    "Saint Helena, Ascension and Tristan da Cunha",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Martin (French part)",
    "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Sint Maarten (Dutch part)",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan (the)",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States of America",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela",
    "Viet Nam",
    "Wallis and Futuna",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe",
    "Åland Islands"
  ];
}