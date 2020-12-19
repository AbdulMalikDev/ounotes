import 'package:FSOUNotes/models/subject.dart';

class CourseInfo {
  static List<String> semestersInNumbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];

  static List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
    "Semester 7",
    "Semester 8"
  ];

  static List<String> branch = [
    "IT",
    "CSE",
    "ECE",
    "EEE",
    "CIVIL",
    "EIE",
    "MECH",
    'PE',
  ];

  static List<String> colleges = [
    "Muffakham Jah College of Engineering and Technology",
    "Osmania University's College of Technology",
    "CBIT",
    "Vasavi",
    "MVSR ",
    "Deccan College ",
    "ISL Engineering College",
    "Methodist ",
    "Stanley College ",
    "NGIT",
    "University College of Engineering",
    "Matrusri Engineering College",
    "Swathi Institute of Technology & Science",
    "JNTU Affiliated Colleges",
    "Other"
  ];

  static List<String> yeartype = [
    "Single year",
    "Range",
  ];

  static List<Subject> aallsubjects = [

    //1ST  SEM
    Subject(1, "ENVIRONMENTAL SCIENCE", [1], ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(2, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", [1],
        ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(3, "MATHEMATICS-I", [1],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH', 'PE']),
    Subject(4, "CHEMISTRY", [1], ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(5, "PROGRAMMING FOR PROBLEM SOLVING", [1],
        ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(6, "INDIAN CONSTITUTION", [1], ['ECE', 'IT', 'MECH', 'PE']),
    Subject(7, "PHYSICS", [1], ['ECE', 'IT', 'MECH', 'PE']),
    Subject(
        8, "BASIC ELECTRICAL ENGINEERING", [1], ['ECE', 'IT', 'MECH', 'PE']),

    //2ND SEM
    Subject(9, "MATHEMATICS-II", [2],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH', 'PE']),
    Subject(10, "ENGLISH", [2],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH', 'PE']),
    Subject(11, "INDIAN CONSTITUTION", [2], ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(12, "PHYSICS", [2], ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(13, "BASIC ELECTRICAL ENGINEERING", [2],
        ['CSE', 'CIVIL', 'EEE', 'EIE']),
    Subject(14, "ENVIRONMENTAL SCIENCE", [2], ['ECE', 'IT', 'MECH', 'PE']),
    Subject(15, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", [2],
        ['ECE', 'IT', 'MECH', 'PE']),
    Subject(16, "CHEMISTRY", [2], ['ECE', 'IT', 'MECH', 'PE']),
    Subject(17, "PROGRAMMING AND PROBLEM SOLVING", [2],
        ['ECE', 'IT', 'MECH', 'PE']),

    //3RD SEM

    //COMMON SUBJECTS
    Subject(18, "INDIAN CONSTITUTION", [3], ['MECH', 'ECE', 'IT']),
    Subject(19, "ENVIRONMENTAL SCIENCE", [3], ['CSE', 'CIVIL', 'EEE']),
    Subject(20, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", [3],
        ['CSE', 'CIVIL', 'EEE']),
    Subject(21, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH", [3],
        ['MECH', 'IT', 'ECE']),
    Subject(22, "FINANCE AND ACCOUNTING", [3], ['ECE', 'IT', 'MECH']),
    Subject(23, "MATHEMATICS-III(PDE,PROB&STATS)", [3], ['ECE', 'MECH']),
    Subject(24, "MATHEMATICS-III(PROB&STATS)", [3], ['IT']),
    Subject(25, "BASIC ELECTRONICS", [3], ['MECH', 'IT', 'CSE']),
    Subject(26, "BIOLOGY FOR ENGINEERS", [3], ['EEE', 'CIVIL', 'CSE']),
    Subject(27, "DIGITAL ELECTRONICS", [3], ['ECE', 'IT', 'CSE']),
    Subject(28, "ENGINEERING MECHANICS", [3], ['EEE', 'CIVIL', 'MECH']),
    Subject(29, "INDUSTRIAL PSYCHOLOGY", [3], ['EEE', 'CIVIL']),
    Subject(30, "ENERGY SCIENCES AND ENGINEERING", [3], ['EEE', 'CIVIL']),
    //MECH
    Subject(31, "METALLURGY AND MATERIAL SCIENCE", [3], ['MECH']),
    Subject(32, "THERMODYNAMICS", [3], ['MECH']),
    //CSE
    Subject(33, "OPERATIONS RESEARCH", [3], ['CSE']),
    Subject(34, "DATA STRUCTURES AND ALGORITHMS", [3], ['CSE']),
    Subject(35, "DISCRETE MATHEMATICS", [3], ['CSE']),
    Subject(36, "PROGRAMMING LANGUAGES", [3], ['CSE']),
    //IT
    Subject(37, "DATA STRUCTURES", [3], ['IT']),
    Subject(
        38, "MATHEMATICAL FOUNDATIONS OF INFORMATION TECHNOLOGY", [3], ['IT']),
    //ECE
    Subject(39, "ELEMENTS OF MECHANICAL ENGINEERING", [3], ['ECE']),
    Subject(40, "ELECTRONIC DEVICES", [3], ['ECE']),
    Subject(41, "NETWORK THEORY", [3], ['ECE']),
    //CIVIL
    Subject(42, "SOLID MECHANICS", [3], ['CIVIL']),
    Subject(43, "ENGINEERING GEOLOGY", [3], ['CIVIL']),
    Subject(44, "SURVEYING AND GEOMATICS", [3], ['CIVIL']),
    //EEE
    Subject(45, "ANALOG ELECTRONICS", [3], ['EEE']),
    Subject(46, "ELECTRICAL CIRCUIT ANALYSIS", [3], ['EEE']),
    Subject(47, "ELECTROMAGNETIC FIELDS", [3], ['EEE']),

    //4TH SEM

    //COMMON SUBJECTS
    Subject(48, "INDIAN CONSTITUTION", [4], ['EEE', 'CIVIL', 'CSE']),
    Subject(49, "ENVIRONMENTAL SCIENCE", [4], ['MECH', 'IT', 'ECE']),
    Subject(50, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", [4],
        ['MECH', 'IT', 'ECE']),
    Subject(51, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH", [4],
        ['CSE', 'CIVIL', 'EEE']),
    Subject(52, "FINANCE AND ACCOUNTING", [4], ['CSE', 'CIVIL', 'EEE']),
    Subject(53, "MATHEMATICS-III(PROB&STATS)", [4], ['EEE', 'CSE']),
    Subject(54, "MATHEMATICS-III(PDE,PROB&STATS)", [4], ['CIVIL']),
    Subject(55, "BIOLOGY FOR ENGINEERS", [4], ['ECE', 'IT', 'MECH']),
    Subject(56, "INDUSTRIAL PSYCHOLOGY", [4], ['MECH', 'ECE']),
    Subject(57, "ELEMENTS OF MECHANICAL ENGINEERING", [4], ['EEE', 'CIVIL']),
    Subject(58, "SIGNALS AND SYSTEMS", [4], ['ECE', 'IT', 'CSE']),
    //MECH
    Subject(59, "ENERGY SCIENCES AND ENGINEERING", [4], ['MECH']),
    Subject(60, "MECHANICS OF MATERIALS", [4], ['MECH']),
    Subject(61, "APPLIED THERMODYNAMICS", [4], ['MECH']),
    Subject(62, "KINEMATICS OF MACHINERY", [4], ['MECH']),
    Subject(63, "MANUFACTURING PROCESS", [4], ['MECH']),
    //CSE
    Subject(64, "OOP USING JAVA", [4], ['CSE']),
    Subject(65, "COMPUTER ORGANISATION", [4], ['CSE']),
    Subject(66, "DATABASE MANAGEMENT SYSTEMS", [4], ['CSE']),
    //IT
    Subject(67, "OPERATIONS RESEARCH", [4], ['IT']),
    Subject(68, "JAVA PROGRAMMING", [4], ['IT']),
    Subject(69, "DATABASE SYSTEMS", [4], ['IT']),
    Subject(70, "COMPUTER ORGANISATION AND MICROPROCESSOR", [4], ['IT']),
    Subject(71, "DATA COMMUNICATIONS", [4], ['IT']),
    //ECE
    Subject(72, "ANALOG ELECTRONIC CIRCUITS", [4], ['ECE']),
    Subject(73, "ELECTROMAGNETIC THEORY AND MAGNETIC LINES", [4], ['ECE']),
    Subject(74, "PULSE AND LINEAR INTEGRATED CIRCUITS", [4], ['ECE']),
    Subject(75, "COMPUTER ORGANISATION AND ARCHITECHTURE", [4], ['ECE']),
    //CIVIL
    Subject(76, "MECHANISMS OF MATERIALS AND STRUCTURES", [4], ['CIVIL']),
    Subject(77, "FLUID MECHANICS", [4], ['CIVIL']),
    Subject(78, "MATERIALS:TESTING AND EVALUATION", [4], ['CIVIL']),
    //EEE
    Subject(79, "ELECTRICAL MACHINES-I", [4], ['EEE']),
    Subject(80, "DIGITAL ELECTRONICS AND LOGIC DESIGN", [4], ['EEE']),
    Subject(81, "POWER ELECTRONICS", [4], ['EEE']),

    //5TH SEM

    //COMMON SUBJECTS
    Subject(82, "GENDER SENSITIZATION", [5], ['CSE', 'EEE', 'IT', 'MECH']),
    Subject(83, "OPERATING SYSTEMS", [5], ['CSE', 'IT']),
    //MECH
    Subject(84, "MANUFACTURING PROCESSES", [5], ['MECH']),
    Subject(85, "DYNAMICS OF MACHINES", [5], ['MECH']),
    Subject(86, "MACHINE DESIGN", [5], ['MECH']),
    Subject(87, "HEAT TRANSFER", [5], ['MECH']),
    Subject(88, "OPERATIONS RESEARCH", [5], ['MECH']),
    Subject(89, "CAD/CAM", [5], ['MECH']),
    //CSE
    Subject(90, "DATABASE MANAGEMENT SYSTEMS", [5], ['CSE']),
    Subject(91, "DATA COMMUNICATIONS", [5], ['CSE']),
    Subject(92, "AUTOMATA LANGUAGES AND COMPUTATION", [5], ['CSE']),
    Subject(93, "COMPUTER GRAPHICS", [5], ['CSE']),
    Subject(94, "MANAGERIAL ECONOMICS AND ACCOUNTANCY", [5], ['CSE']),
    Subject(95, "ARTIFICIAL INTELLIGENCE", [5], ['CSE']),
    //IT
    Subject(96, "SOFTWARE ENGINEERING", [5], ['IT']),
    Subject(97, "DATABASE SYSTEMS", [5], ['IT']),
    Subject(98, "AUTOMATA THEORY", [5], ['IT']),
    Subject(99, "COMPUTER NETWORKS", [5], ['IT']),
    //ECE
    Subject(100, "ANALOG COMMUNICATION", [5], ['ECE']),
    Subject(101, "DIGITAL SIGNAL PROCESSING", [5], ['ECE']),
    Subject(102, "AUTOMATIC CONTROL SYSTEMS", [5], ['ECE']),
    Subject(103, "LINEAR ICS AND APPLICATIONS", [5], ['ECE']),
    Subject(104, "COMPUTER ORGANISATION AND ARCHITECHTURE", [5], ['ECE']),
    Subject(105, "DIGITAL SYSTEM DESIGN WITH VERILOG HDL", [5], ['ECE']),
    //CIVIL
    Subject(106, "REINFORCEMENT CEMENT CONCRETE", [5], ['CIVIL']),
    Subject(107, "THEORY OF STRUCTURES-I", [5], ['CIVIL']),
    Subject(108, "CONCRETE TECHNOLOGY", [5], ['CIVIL']),
    Subject(109, "HYDRAULIC MACHINES", [5], ['CIVIL']),
    Subject(110, "TRANSPORTATION ENGINEERING-I", [5], ['CIVIL']),
    Subject(111, "ENVIRONMENTAL ENGINEERING", [5], ['CIVIL']),
    Subject(112, "WATER RESOURCE ENGINEERING-I", [5], ['CIVIL']),
    //EEE
    Subject(113, "POWER SYSTEMS-II", [5], ['EEE']),
    Subject(114, "ELECTRICAL MACHINES-II", [5], ['EEE']),
    Subject(115, "ELECTRICAL MEASUREMENTS AND INSTRUMENTATION", [5], ['EEE']),
    Subject(116, "LINEAR CONTROL SYSTEMS", [5], ['EEE']),
    Subject(117, "DIGITAL SIGNAL PROCESSING AND APPLICATIONS", [5], ['EEE']),

    //6TH SEM

    //MECH
    Subject(118, "METAL CUTTING AND MACHINE TOOLS", [6], ['MECH']),
    Subject(119, "REFRIGIRATOR AND AIR CONDITIONING", [6], ['MECH']),
    Subject(120, "HYDRAULIC MACHINERY AND SYSTEMS", [6], ['MECH']),
    Subject(121, "METROLOGY AND INSTRUMENTATION", [6], ['MECH']),
    Subject(122, "AUTOMOBILE ENGINEERING", [6], ['MECH']),
    //CSE
    Subject(123, "DESIGN AND ANALYSIS OF ALGORITHMS", [6], ['CSE']),
    Subject(124, "SOFTWARE ENGINEERING", [6], ['CSE']),
    Subject(125, "COMPUTER NETWORKS AND PROGRAMMING", [6], ['CSE']),
    Subject(126, "WEB PROGRAMMING", [6], ['CSE']),
    //IT
    Subject(127, "WEB APPLICATION DEVELOPMENT", [6], ['IT']),
    Subject(128, "COMPILER CONSTRUCTION", [6], ['IT']),
    Subject(129, "EMBEDDED SYSTEM", [6], ['IT']),
    Subject(130, "DESIGN AND ANALYSIS OF ALGORITHMS", [6], ['IT']),
    //ECE
    Subject(131, "DIGITAL COMMUNICATION", [6], ['ECE']),
    Subject(132, "ANTENNAS AND WAVE PROPAGATION", [6], ['ECE']),
    Subject(133, "MICROPROCESSOR AND MICROCONTROLLER", [6], ['ECE']),
    Subject(134, "MANAGERIAL ECONOMICS AND ACCOUNTANCY", [6], ['ECE']),
    //CIVIL
    Subject(135, "STEEL STRUCTURES", [6], ['CIVIL']),
    Subject(136, "STRUCTURAL ENGINEERING DESIGN AND DETAILING-I(CONCRETE)", [6],
        ['CIVIL']),
    Subject(137, "THEORY OF STRUCTURES-II", [6], ['CIVIL']),
    Subject(138, "WATER RESOURCE MANAGEMENT-II", [6], ['CIVIL']),
    Subject(139, "SOIL MECHANICS", [6], ['CIVIL']),
    Subject(140, "TRANSPORTATION ENGINEERING-II", [6], ['CIVIL']),
    //EEE
    Subject(141, "ELECTRICAL MACHINES-III", [6], ['EEE']),
    Subject(142, "MICROPROCESSOR AND MICROCONTROLLER", [6], ['EEE']),
    Subject(143, "SWITCHGEAR AND PROTECTION", [6], ['EEE']),
    Subject(144, "RENEWABLE ENERGY TECHNOLOGIES", [6], ['EEE']),

    //7TH SEM

    //MECH
    Subject(145, "THERMAL TURBO MACHINES", [7], ['MECH']),
    Subject(146, "FINITE ELEMENT ANALYSIS", [7], ['MECH']),
    Subject(147, "INDUSTRIAL ENGINEERING", [7], ['MECH']),
    Subject(148, "PRODUCTION AND OPERATIONS MANAGEMENT", [7], ['MECH']),
    Subject(149, "MANAGERIAL ECONOMICS AND ACCOUNTANCY", [7], ['MECH']),
    //CSE
    Subject(150, "COMPILER CONSTRUCTION", [7], ['CSE']),
    Subject(151, "INFORMATION SECURITY", [7], ['CSE']),
    Subject(152, "DISTRIBUTED SYSTEMS", [7], ['CSE']),
    Subject(153, "DATA MINING", [7], ['CSE']),
    //IT
    Subject(154, "VLSI DESIGN", [7], ['IT']),
    Subject(155, "BIG DATA ANALYTICS", [7], ['IT']),
    Subject(156, "WIRELESS MOBILE COMMUNICATION", [7], ['IT']),
    Subject(157, "NETWORK SECURITY AND CRYPTOGRAPHY", [7], ['IT']),
    //ECE
    Subject(158, "EMBEDDED SYSTEM", [7], ['ECE']),
    Subject(159, "VLSI DESIGN", [7], ['ECE']),
    Subject(160, "MICROWAVE TECHNIQUES", [7], ['ECE']),
    Subject(161, "INDUSTRIAL ADMINISTRATION AND FINANCIAL MANAGEMENT", [7],
        ['ECE']),
    Subject(162, "HUMAN VALUES AND PROFESSIONAL ETHICS", [7], ['ECE']),
    //EEE
    Subject(163, "POWER SYSTEM OPERATION AND CONTROL", [7], ['EEE']),
    Subject(164, "ELECTRIC DRIVES AND STATIC CONTROL", [7], ['EEE']),
    Subject(165, "ELECTRICAL MACHINE DESIGN", [7], ['EEE']),
    //CIVIL
    Subject(
        166, "STRUCTURAL ENGINEERING AND DRAWING-II(STEEL)", [7], ['CIVIL']),
    Subject(167, "ESTIMATION COSTING AND SPECIFICATIONS", [7], ['CIVIL']),
    Subject(168, "FINITE ELEMENT TECHNIQUES", [7], ['CIVIL']),
    Subject(169, "PRESTRESSED CONCRETE", [7], ['CIVIL']),
    Subject(170, "FOUNDATION ENGINEERING", [7], ['CIVIL']),

    //8TH SEM
    Subject(171, "PROFESSIONAL ELECTIVE-IV", [8],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH']),
    Subject(172, "PROFESSIONAL ELECTIVE-III", [8],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH']),
    Subject(173, "PROFESSIONAL ELECTIVE-V", [8],
        ['CSE', 'CIVIL', 'EEE', 'EIE', 'ECE', 'IT', 'MECH']),
    Subject(174, "UTILISATION OF ELECTRICAL ENERGY", [8], ['EEE']),
    Subject(175, "GENDER SENSITIZATION", [8], ['CIVIL']),
    Subject(176, "CONSTRUCTION MANAGEMENT AND TECHNOLOGY", [8], ['CIVIL']),
    Subject(177, "PROFESSIONAL ELECTIVE-II", [8], ['MECH']),
  ];
}

// @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SearchViewModel>.reactive(
//         builder: (context, model, child) => Scaffold(),
//         viewModelBuilder:() => SearchViewModel());
//   }
