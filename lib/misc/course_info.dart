import 'package:FSOUNotes/enums/enums.dart';
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
    "AE"
  ];

  // DO NOT CHANGE THESE NAMES ( NOT EVEN SPACE )
  // USER ANALYTICS DOC IN FIREBASE USES THESE NAMES
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

  //Used for FCM topics
  static Map<String,String> collegeToShortFrom = {
    "Muffakham Jah College of Engineering and Technology" : "MJCET",
    "Osmania University's College of Technology"          : "OUCT",
    "CBIT"                                                : "CBIT",
    "Vasavi"                                              : "VASAVI",
    "MVSR "                                               : " MVSR",
    "Deccan College "                                     : "DCET",
    "ISL Engineering College"                             : "ISL",
    "Methodist "                                          : "METHODIST",
    "Stanley College "                                    : "STANLEY",
    "NGIT"                                                : "NGIT",
    "University College of Engineering"                   : "UCOE",
    "Matrusri Engineering College"                        : "MEC",
    "Swathi Institute of Technology & Science"            : "SITS",
    "JNTU Affiliated Colleges"                            : "JNTU",
    "Other"                                               : "OTHER",
  };

  static List<String> yeartype = [
    "Single year",
    "Range",
  ];

  static Map<String,String> semesterToNumber = {
    "Semester 1":"1",
    "Semester 2":"2",
    "Semester 3":"3",
    "Semester 4":"4",
    "Semester 5":"5",
    "Semester 6":"6",
    "Semester 7":"7", 
    "Semester 8":"8", 
  };

  static List<Subject> aallsubjects = [

    // --> //* VERIFIED <-- AISA LIKHNA HAI SUBJECT KE UPAR AGAR VERIFY KARDIYE TO
    // --> //? ADDED <-- AISA LIKHNA HAI SUBJECT KE UPAR AGAR ADD KARDIYE TO
    // --> //! DELETED <-- AISA LIKHNA HAI SUBJECT KE UPAR AGAR DELETE KARDIYE TO
    // OK ?
    
    //* 1st Year VERIFIED
    Subject(1, "ENVIRONMENTAL SCIENCE",branchToSem: {'ECE':['2','4'],"MECH":['2','4'],"IT":['2','4'],"PE":['2','4'],"AE":['2','4'],"CSE":['1','3'],"CIVIL":['1','3'],"EEE":['1','3'],"EIE":['1','3']}),
    Subject(2, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE",branchToSem:{'ECE':["2",'4'],"MECH":["2",'4'],"IT":["2",'4'],"PE":["2",'4'],"AE":["2",'4'],"CSE":['1','3'],"CIVIL":['1','3'],"EEE":['1','3'],"EIE":['1','3']}),
    Subject(3, "MATHEMATICS-I",branchToSem: {"ECE":['1'],"IT":['1'],"MECH":['1'],"PE":['1'],"AE":['1'],"CSE":['1'],"CIVIL":['1'],"EEE":['1'],"EIE":['1']}),
    Subject(4, "CHEMISTRY",branchToSem: {'ECE':["2"],"MECH":["2"],"IT":["2"],"PE":["2"],"AE":["2"],"CSE":['1'],"CIVIL":['1'],"EEE":['1'],"EIE":['1'],}),
    Subject(5, "PROGRAMMING FOR PROBLEM SOLVING",branchToSem: {'ECE':["2",],"MECH":["2"],"IT":["2"],"PE":["2"],"AE":["2",],"CSE":['1'],"CIVIL":['1',],"EEE":['1'],"EIE":['1']}),
    Subject(18, "INDIAN CONSTITUTION",branchToSem: {'ECE':['1','3'],"MECH":["1",'3'],"IT":["1",'3'],"PE":["1",'3'],"AE":["1",'3'],"CSE":['2','4'],"CIVIL":['2','4'],"EEE":['2','4'],"EIE":['2','4']}),
    Subject(7, "PHYSICS",branchToSem: {'ECE':['1'],"MECH":['1'],"IT":["1"],"PE":["1"],"AE":["1"],"CSE":['2'],"CIVIL":['2'],"EEE":['2'],"EIE":['2']}),
    Subject(
        13, "BASIC ELECTRICAL ENGINEERING",branchToSem: {'ECE':['1'],"MECH":["1"],"IT":["1"],"PE":["1"],"AE":["1"],"CSE":['2'],"CIVIL":['2'],"EEE":['2'],"EIE":['2']}),
    Subject(9, "MATHEMATICS-II",branchToSem:{"ECE":["2"],"IT":["2"],"MECH":["2"],"PE":["2"],"AE":["2"],"CSE":['2'],"CIVIL":['2'],"EEE":['2'],"EIE":['2'],}),
    Subject(10, "ENGLISH", branchToSem: {"ECE":["2"],"IT":["2"],"MECH":["2"],"PE":["2"],"AE":["2"],"CSE":['2'],"CIVIL":['2'],"EEE":['2'],"EIE":['2']}),

    //Deleted 1st year duplicate subjects
    // Subject(11, "INDIAN CONSTITUTION", ),
    // Subject(12, "PHYSICS", ),
    // Subject(13, "BASIC ELECTRICAL ENGINEERING",
    //     ),
    // Subject(14, "ENVIRONMENTAL SCIENCE",),
    // Subject(15, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE",
    //    ),
    // Subject(16, "CHEMISTRY",),
    // Subject(17, "PROGRAMMING AND PROBLEM SOLVING",
    //    ),

    
    //2nd year
    Subject(21, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH",branchToSem: {'CIVIL':['4'],'CSE':['4'],'ECE':['3'],'EEE':['4'],'EIE':['4'],'IT':['3'],'MECH':['3'],'PE':['3']},),
    Subject(22, "FINANCE AND ACCOUNTING",branchToSem: {'AE':['3'],'CIVIL':['4'],'CSE':['4'],'ECE':['3'],'EEE':['4'],'EIE':['4'],'IT':['3'],'MECH':['3'],'PE':['3']}),
    Subject(23, "MATHEMATICS-III(PDE,PROB&STATS)",branchToSem: {'AE':['3'],'CIVIL':['4'],'ECE':['3'],'MECH':['3'],'PE':['3']}),
    Subject(24, "MATHEMATICS-III(PROB&STATS)", branchToSem: {'CSE':['4'],'EEE':['4'],'EIE':['4'],'IT':['3']},),
    Subject(25, "BASIC ELECTRONICS", branchToSem: {'AE':['3'],'CSE':['3'],'IT':['3'],'MECH':['3'],'PE':['3']}),
    Subject(26, "BIOLOGY FOR ENGINEERS",branchToSem: {'AE':['4'],'CIVIL':['3'],'CSE':['3'],'ECE':['4'],'EEE':['3'],'EIE':['3'],'IT':['4'],'MECH':['4'],'PE':['4']},),
    //name of this subject is digital electronics and logic design for EEE AND EIE (SIMILAR TO SUBJECT ID 80)
    Subject(27, "DIGITAL ELECTRONICS", branchToSem: {'CSE':['3'],'ECE':['3'],'EEE':['4'],'EIE':['4'],'IT':['3']},),
    Subject(28, "ENGINEERING MECHANICS",branchToSem: {'AE':['3'],'CIVIL':['3'],'EEE':['3'],'EIE':['3'],'PE':['3']}),
    Subject(29, "INDUSTRIAL PSYCHOLOGY",branchToSem: {'AE':['4'],'CIVIL':['3'],'ECE':['4'],'EEE':['3'],'EIE':['3'],'MECH':['4'],'PE':['4']},),
    Subject(30, "ENERGY SCIENCES AND ENGINEERING",branchToSem: {'AE':['4'],'CIVIL':['3'],'EEE':['3'],'EIE':['3'],'MECH':['4'],'PE':['4']},),
    //name of this subject is Fluid mechanics and machinary for Automobile sutdents
    Subject(31, "METALLURGY AND MATERIAL SCIENCE",branchToSem: {'AE':['4'],'MECH':['3'],'PE':['3']}, ),
    Subject(32, "THERMODYNAMICS", branchToSem: {'MECH':['3'],'PE':['3']},),
    Subject(33, "OPERATIONS RESEARCH", branchToSem: {'CSE':['3'],'IT':['4']},),
    Subject(34, "DATA STRUCTURES AND ALGORITHMS",branchToSem: {'CSE':['3']},),
    Subject(35, "DISCRETE MATHEMATICS", branchToSem: {'CSE':['3'],},),
    Subject(36, "PROGRAMMING LANGUAGES",branchToSem: {'CSE':['3'],},),
    //subject similar to id no. 34
    Subject(37, "DATA STRUCTURES", branchToSem: {'IT':['3']},),
    Subject(38, "MATHEMATICAL FOUNDATIONS OF INFORMATION TECHNOLOGY",branchToSem: {'IT':['3']},),
    Subject(39, "ELEMENTS OF MECHANICAL ENGINEERING", branchToSem: {'CIVIL':['4'],'ECE':['3'],'EEE':['4'],'EIE':['4'],},),
    Subject(40, "ELECTRONIC DEVICES",branchToSem: {'ECE':['3'],},),
    Subject(41, "NETWORK THEORY", branchToSem: {'ECE':['3'],'EIE':['3']},),
    Subject(42, "SOLID MECHANICS",branchToSem: {'CIVIL':['3'],},),
    Subject(43, "ENGINEERING GEOLOGY",branchToSem: {'CIVIL':['3'],},),
    Subject(44, "SURVEYING AND GEOMATICS", branchToSem: {'CIVIL':['3'],},),
    Subject(45, "ANALOG ELECTRONICS",branchToSem: {'EEE':['3'],'EIE':['3']},),
    Subject(46, "ELECTRICAL CIRCUIT ANALYSIS",branchToSem: {'EEE':['3'],},),
    Subject(47, "ELECTROMAGNETIC FIELDS",branchToSem: {'EEE':['3'],'EIE':['3']},),
    Subject(58, "SIGNALS AND SYSTEMS", branchToSem: {'CSE':['4'],'ECE':['4'],'IT':['4'],'EIE':['5'],'EEE':["5"]},),
    Subject(60, "MECHANICS OF MATERIALS",branchToSem: {'AE':['4'],'CIVIL':['4'],'MECH':['4'],'PE':['4']}, ),
    Subject(61, "APPLIED THERMODYNAMICS", branchToSem: {'MECH':['4'],'PE':['4']},),
    Subject(62, "KINEMATICS OF MACHINERY",branchToSem: {'AE':['4'],'MECH':['4'],'PE':['4']},),
    Subject(63, "MANUFACTURING PROCESS",branchToSem: {'MECH':['4'],'PE':['4']},),
    Subject(64, "OOP USING JAVA",branchToSem: {'CSE':['4'],},),
    Subject(65, "COMPUTER ORGANISATION",branchToSem: {'CSE':['4'],},),
    Subject(66, "DATABASE MANAGEMENT SYSTEMS",branchToSem: {'CSE':['4'],},),
    //subject similar to id 64
    Subject(68, "JAVA PROGRAMMING",branchToSem: {'IT':['4']},),
    Subject(69, "DATABASE SYSTEMS", branchToSem: {'IT':['4']},),
    Subject(70, "COMPUTER ORGANISATION AND MICROPROCESSOR", branchToSem: {'IT':['4']},),
    Subject(71, "DATA COMMUNICATIONS", branchToSem: {'IT':['4']},),
    //subject similar to id 45
    Subject(72, "ANALOG ELECTRONIC CIRCUITS", branchToSem: {'ECE':['4'],},),
    Subject(73, "ELECTROMAGNETIC THEORY AND MAGNETIC LINES", branchToSem: {'ECE':['4'],},),
    Subject(74, "PULSE AND LINEAR INTEGRATED CIRCUITS", branchToSem: {'ECE':['4'],},),
    Subject(75, "COMPUTER ORGANISATION AND ARCHITECHTURE",branchToSem: {'ECE':['4'],},),
    Subject(76, "MECHANISMS OF MATERIALS AND STRUCTURES",branchToSem: {'PE':['3']}),
    Subject(77, "FLUID MECHANICS",branchToSem: {'AE':['3'],'CIVIL':['4'],'PE':['3']},),
    Subject(78, "MATERIALS:TESTING AND EVALUATION", branchToSem: {'CIVIL':['4']},),
    Subject(79, "ELECTRICAL MACHINES-I",branchToSem: {'EEE':['4'],},),
    Subject(80, "DIGITAL ELECTRONICS AND LOGIC DESIGN",branchToSem: {'EEE':['4'],'EIE':['4']}),
    Subject(81, "POWER ELECTRONICS",branchToSem: {'EEE':['4'],'EIE':['4']},),

    //ADDED
    Subject(367, "THERMAL ENGINEERING",branchToSem: {'AE':['3'],},),
    //ADDED
    Subject(368, "AUTOMOTIVE CHASSIS COMPONENTS",branchToSem: {'AE':['4'],}, ),
    //ADDED 
    Subject(369, "OVERVIEW OF CIVIL ENGINEERING",branchToSem: {'CIVIL':['3'],}, ),
    //ADDED
    Subject(370, "TRANSDUCERS ENGINEERING",branchToSem: {'EIE':['4']},),
    //ADDED
    Subject(371, "ENGINEERING ELECTRONICS",branchToSem: {'MECH':['3']},),

    
    //Deleted 2nd year subjects
    // Subject(18, "INDIAN CONSTITUTION", ),
    // Subject(19, "ENVIRONMENTAL SCIENCE", ),
    // Subject(20, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE",
    //     ), 
    // Subject(48, "INDIAN CONSTITUTION",  ),
    // Subject(49, "ENVIRONMENTAL SCIENCE",  ),
    // Subject(50, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", 
    //     ),
    // Subject(51, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH", 
    //     ),
    // Subject(52, "FINANCE AND ACCOUNTING",  ),
    // Subject(53, "MATHEMATICS-III(PROB&STATS)", ),
    // Subject(54, "MATHEMATICS-III(PDE,PROB&STATS)",  ),
    // Subject(55, "BIOLOGY FOR ENGINEERS",  ),
    // Subject(56, "INDUSTRIAL PSYCHOLOGY",  ),
    // Subject(57, "ELEMENTS OF MECHANICAL ENGINEERING",  ),
    // Subject(59, "ENERGY SCIENCES AND ENGINEERING",  ),
    // Subject(67, "OPERATIONS RESEARCH",  ),



    // ********************************* 3rd year ***************************************************    

    //! Newly Added Subjects
    //SEM 5
    //CIVIL
    Subject(178, "Structural Analysis - I",branchToSem: {"CIVIL":["5"]}),
    Subject(179, "Hydraulic Engineering",branchToSem: {"CIVIL":["5"]}),
    Subject(180, "Structural Engineering Design and Detailing",branchToSem: {"CIVIL":["5"]}),
    Subject(181, "Geotechnical Engineering",branchToSem: {"CIVIL":["5"]}),
    Subject(182, "Hydrology and Water Resources Engineering", branchToSem: {"CIVIL":["5"]}),
    Subject(183, "Transportation Engineering",branchToSem: {"CIVIL":["5"]}),
    //EIE
    Subject(204, "Instrumentation Systems", branchToSem: {"EIE":["5"]}),
    Subject(205, "Power Plant Instrumentation",branchToSem: {"EIE":["5"]}),
    Subject(206, "Microprocessors and Microcontrollers", branchToSem: {"EIE":["5"],"ECE":["5"],"EEE":["5"]}),
    Subject(207, "Building Management Systems",branchToSem: {"EIE":["5"]},subjectType: SubjectType.Elective),
    Subject(208, "Principles of Communication Engineering", branchToSem: {"EIE":["5"]},subjectType: SubjectType.Elective),
    Subject(209, "Advanced Sensors", branchToSem: {"EIE":["5"]},subjectType: SubjectType.Elective),
    //MECH
    Subject(210, "Fluid Mechanics and Hydraulic Machines",branchToSem: {"MECH":["5"]}),
    Subject(212, "Production Planning and Control",branchToSem: {"MECH":["5"]},subjectType: SubjectType.Elective),
    Subject(213, "Powder Metallurgy",branchToSem: {"MECH":["5"]},subjectType: SubjectType.Elective),
    Subject(214, "Robotic Engineering",branchToSem: {"MECH":["5","8"],"PE":['8']},subjectType: SubjectType.Elective),
    Subject(215, "Theory of Elasticity",branchToSem: {"MECH":["5"]},subjectType: SubjectType.Elective),
    Subject(372, "Dynamics of Machines",branchToSem: {"MECH":["5"]}),

    //AE
    Subject(238, "Internal Combustion Engines",branchToSem: {"AE":["5"]}),
    Subject(239, "Automotive Transmission",branchToSem: {"AE":["5"]}),
    Subject(240, "Design of MachineComponents",branchToSem: {"AE":["5"]}),
    //PE
    Subject(241, "Machine Tool Design",branchToSem: {"PE":["5"]}),
    Subject(242, "Design of Machine Elements",branchToSem: {"PE":["5"],"MECH":["5"]}),
    Subject(243, "Computer Aided Design and Manufacturing",branchToSem: {"PE":["5"]}),
    //EEE
    Subject(245, "Power Systems – I",branchToSem: {"EEE":["5"]}),
    Subject(246, "Electric Distribution System",branchToSem: {"EEE":["5"]}),
    Subject(247, "Renewable Energy Sources",branchToSem: {"EEE":["5"]}),
    Subject(248, "Hybrid Electric Vehicles",branchToSem: {"EEE":["5"]}),
    //CSE
    Subject(257, "Advanced Computer Architecture",branchToSem: {"CSE":["5"],"IT":["6"],},subjectType: SubjectType.Elective),
    Subject(258, "Image Processing",branchToSem: {"CSE":["5","8"],},subjectType: SubjectType.Elective),
    
    Subject(259, "Embedded Systems",branchToSem: {"CSE":["5","8"],"IT":["6"],'ECE':['7']},subjectType: SubjectType.Elective),
    Subject(260, "Graph Theory",branchToSem: {"CSE":["5"]},subjectType: SubjectType.Elective),
    Subject(261, "Data Analytics",branchToSem: {"CSE":["5"]},subjectType: SubjectType.Elective),
    Subject(262, "Block Chain Technologies",branchToSem: {"CSE":["5"]},subjectType: SubjectType.Elective),
    Subject(263, "Information Retrieval Systems",branchToSem: {"CSE":["5","8"],"IT":["8"]},subjectType: SubjectType.Elective),
    Subject(264, "Soft Computing",branchToSem: {"CSE":["5"]},subjectType: SubjectType.Elective),
    //IT
    Subject(374, "Multimedia Technologies",branchToSem: {"IT":["5"]},subjectType: SubjectType.Elective),
    Subject(375, "Software Quality and Testing",branchToSem: {"CSE":["8"]},subjectType: SubjectType.Elective),
    Subject(376, "Web Services and Architecture",branchToSem: {"CSE":["8"],"IT":["8"],},subjectType: SubjectType.Elective),

    //SEM 6
    //CIVIL
    Subject(184, "Estimation and Specifications",branchToSem: {"CIVIL":["6"]}),
    Subject(185, "Structural Analysis –II",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(186, "Railway and Airport Engineering",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(187, "Ground Water Engineering",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(188, "Geotechnical Design",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(189, "Environmental Impact Assessment of Transportation Projects",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(190, "Design of Hydraulic Structures",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(191, "Traffic Engineering and Management",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(192, "Sustainable Construction Methods",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(193, "Remote Sensing & Geographical Information",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(194, "Road Safety Engineering",branchToSem: {"CIVIL":["6",'7'],'CSE':['7'],'IT':['7'],'EEE':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(195, "Principles of Green Building Practices",branchToSem: {"CIVIL":["6","8"]},subjectType: SubjectType.Elective),
    Subject(196, "Disaster Mitigation & Management",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    Subject(197, "Open Channel Flow & River Engineering",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    //EIE
    Subject(198, "Biomedical Instrumentation",branchToSem: {"EIE":["6"]}),
    Subject(199, "Process Control",branchToSem: {"EIE":["6"]}),
    Subject(200, "Electrical Energy Conservation and Auditing",branchToSem: {"EIE":["6"],"EEE":["6"]},subjectType: SubjectType.Elective),
    Subject(201, "Reliability Engineering",branchToSem: {"EIE":["6"],"EEE":["6"],"IT":["6"]},subjectType: SubjectType.Elective),
    // Subject(202, "Non-Conventional Energy Sources",branchToSem: {"EIE":["6"],"EEE":["6"]},subjectType: SubjectType.Elective),
    // Subject(203, "Illumination and Electric Traction Systems",branchToSem: {"EIE":["6"],"EEE":["6"]},subjectType: SubjectType.Elective),
    //ECE
    Subject(216, "Data Communication and computer networking",branchToSem: {"ECE":["6"]}),
    Subject(217, "Electronic Measurements and Instrumentation",branchToSem: {"ECE":["6",'7']}),
    // Subject(218, "Principles of Electronic Communications",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(219, "Fundamental Digital design using Verilog HDL",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(220, "Image and Video Processing",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(221, "Advanced Microcontrollers",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(222, "Optical Communications",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(223, "IOT Sensors",branchToSem: {"ECE":["6"]},subjectType: SubjectType.Elective),
    //MECH
    Subject(224, "Design of Solar Energy Systems",branchToSem: {"MECH":["6",'8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(225, "Refrigeration and Air Conditioning",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(226, "Control System Theory",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(227, "Additive Manufacturing Technologies",branchToSem: {"MECH":["6",'8'],"PE":["6"]},subjectType: SubjectType.Elective),
   
    Subject(228, "Mechatronics Systems",branchToSem: {"MECH":["6",'7'],'CSE':['7'],'IT':['7'],'EEE':['7'],'CIVIL':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(229, "Fatigue, Creep and Fracture",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(230, "Computational Fluid Flows",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(231, "Non-conventional Machining and Forming Methods",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(232, "Engineering Applications in Medicine",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(233, "Disaster Management",branchToSem: {"MECH":["6"],"IT":["6"],},subjectType: SubjectType.Elective),
    Subject(234, "Electronic Instrumentation",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(235, "Principles of Electronic Communication Systems",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(236, "3D Printing Technology",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    Subject(377, "Modern Machining and Forming Methods",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),

    //AE
    Subject(249, "Design of Automotive Components",branchToSem: {"AE":["6"]}),
    Subject(250, "Computer Aided Design, Analysis and Manufacturing",branchToSem: {"AE":["6"]}),
    Subject(251, "Production Technology",branchToSem: {"AE":["6"]}),
    Subject(252, "Performance And Testing Of Automotive Vehicles",branchToSem: {"AE":["6"]},subjectType: SubjectType.Elective),
    Subject(253, "Material Handling and Earth Moving Vehicles",branchToSem: {"AE":["6"]},subjectType: SubjectType.Elective),
    Subject(254, "Electric and Hybrid Vehicles",branchToSem: {"AE":["6"]},subjectType: SubjectType.Elective),
    //EEE
    Subject(255, "Utilization of Electrical Energy",branchToSem: {"EEE":["6","8"]}),
    //CSE
    Subject(256, "Compiler Design",branchToSem: {"CSE":["6"]}),
    Subject(267, "Advanced Operating Systems",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    Subject(268, "Cloud Computing",branchToSem: {"CSE":["6","8"]},subjectType: SubjectType.Elective),
    Subject(269, "Speech and Natural Language Processing",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    Subject(270, "Machine Learning",branchToSem: {"CSE":["6","8"],"IT":["6","8"],},subjectType: SubjectType.Elective),
    Subject(271, "Human Computer Interaction",branchToSem: {"CSE":["6","8"],"IT":["8"]},subjectType: SubjectType.Elective),
    Subject(272, "Digital Forensics",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    Subject(273, "Internet of Things",branchToSem: {"CSE":["6"],"ECE":["8"]}),
    Subject(274, "Soft Skills & Interpersonal Skills",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    Subject(275, "Human Resource Development and Organizational Behaviour",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    Subject(276, "Cyber Law and Ethics",branchToSem: {"CSE":["6"]},subjectType: SubjectType.Elective),
    //IT
    Subject(277, "Computational Intelligence",branchToSem: {"IT":["6",'8'],"CSE":["8"],},subjectType: SubjectType.Elective),
    Subject(278, "Adhoc and Sensor Networks",branchToSem: {"IT":["6",'8']},subjectType: SubjectType.Elective),
    Subject(279, "Natural Language Processing",branchToSem: {"IT":["6","8"],"CSE":["8"]},subjectType: SubjectType.Elective),
    Subject(280, "Information Storage and Management",branchToSem: {"IT":["6","8"]},subjectType: SubjectType.Elective),
    Subject(281, "Geo Spatial Techniques",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(282, "Principles of Embedded Systems",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(283, "Digital System Design using HDL Verilog",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(284, "Basics of Power Electronics",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(285, "Industrial Robotics",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(286, "Material Handling",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(287, "Automotive Safety & Ergonomics",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(288, "Object Oriented Analysis and Design",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(289, "Multimedia",branchToSem: {"IT":["6"]},subjectType: SubjectType.Elective),
    Subject(290, "Data Science Using R Programming",branchToSem: {"IT":["6",'7','8'],"CSE":['7','8'],'ECE':['7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),


    //5TH SEM

    //COMMON SUBJECTS
    //* VERIFIED FOR ECE 5
    Subject(82, "GENDER SENSITIZATION",branchToSem: {"ECE":["5"],"IT":["5"],"CIVIL":["8"]}),
    //* VERIFIED
    Subject(83, "OPERATING SYSTEMS",branchToSem: {"CSE":["5"],"IT":["5"]}),
    //!DELETE [EXTRA]
    // Subject(84, "MANUFACTURING PROCESSES",  ),
    // Subject(85, "DYNAMICS OF MACHINES",  ),
    //MECH
    //* VERIFIED
    Subject(378, "Automata Languages & Computation",branchToSem: {"MECH":["5"],"AE":["5"],"PE":["5"],"CSE":["5"]}),
    //* VERIFIED
    Subject(86, "MACHINE DESIGN",branchToSem: {"MECH":["6"],"PE":["6"]}),
    //* VERIFIED
    Subject(87, "HEAT TRANSFER",branchToSem: {"MECH":["5"],"AE":["5"],}),
    //*VERIFIED
    Subject(89, "CAD/CAM",branchToSem: {"MECH":["6"]},subjectType: SubjectType.Elective),
    //CSE
    //!DELETE [EXTRA]
    // Subject(90, "DATABASE MANAGEMENT SYSTEMS",  ),
    // Subject(91, "DATA COMMUNICATIONS",  ),
    // Subject(88, "OPERATIONS RESEARCH",  ),
    //*VERIFIED
    // Subject(92, "AUTOMATA LANGUAGES AND COMPUTATION",branchToSem: {"CSE":["5"]}),
    //* VERIFIED
    Subject(93, "COMPUTER GRAPHICS",branchToSem: {"CSE":["5"],"IT":["5"],}),
    //* VERIFIED FOR MECH SEM 6
    Subject(94, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",branchToSem: {"MECH":["6",'7'],'PE':['7']}),
    //* VERIFIED
    Subject(95, "ARTIFICIAL INTELLIGENCE",branchToSem: {"CSE":["5"],"IT":["5"]},subjectType: SubjectType.Elective),
    //IT
    //! DELETE [EXTRA]
    // Subject(96, "SOFTWARE ENGINEERING",  ),
    //! DELETE [EXTRA]
    // Subject(97, "DATABASE SYSTEMS",  ),
    //* VERIFIED
    Subject(98, "AUTOMATA THEORY",branchToSem: {"IT":["5"]}),
    //*VERIFIED
    Subject(99, "COMPUTER NETWORKS",branchToSem: {"CSE":["6"],"IT":["5"]}),
    //ECE
    //* VERIFIED
    Subject(100, "ANALOG COMMUNICATION",branchToSem: {"ECE":["5"]}),
    //* VERIFIED
    Subject(101, "DIGITAL SIGNAL PROCESSING",branchToSem: {'ECE':["5"]}),
    //* VERIFIED
    Subject(102, "AUTOMATIC CONTROL SYSTEMS",branchToSem: {'ECE':["5"]}),
    //! DELETE
    // Subject(103, "LINEAR ICS AND APPLICATIONS",  ),
    //! DELETE
    // Subject(104, "COMPUTER ORGANISATION AND ARCHITECHTURE",  ),
    //*VERIFIED, SEM CHANGED
    Subject(105, "DIGITAL SYSTEM DESIGN WITH VERILOG HDL",branchToSem: {"ECE":["6"]}),
    //CIVIL
    //! DELETE
    // Subject(106, "REINFORCEMENT CEMENT CONCRETE",  ),  
    // Subject(107, "THEORY OF STRUCTURES-I",  ),
    // Subject(108, "CONCRETE TECHNOLOGY",  ),
    // Subject(109, "HYDRAULIC MACHINES",  ),
    // Subject(110, "TRANSPORTATION ENGINEERING-I",  ),
    // Subject(112, "WATER RESOURCE ENGINEERING-I",  ),
    //* VERIFIED
    Subject(111, "ENVIRONMENTAL ENGINEERING",branchToSem: {"CIVIL":["6"]}),
    //EEE
    //* VERIFIED
    Subject(113, "POWER SYSTEMS-II",branchToSem: {"EEE":["6"]}),
    //* VERIFIED
    Subject(114, "ELECTRICAL MACHINES-II",branchToSem:{"EEE":["5"]}),
    //* VERIFIED FOR EIE 6 ONLY
    Subject(115, "ELECTRICAL MEASUREMENTS AND INSTRUMENTATION",branchToSem: {"EIE":["6"],"EEE":["6"]}),
    //* VERIFIED FOR EIE 5 ONLY
    Subject(116, "LINEAR CONTROL SYSTEMS",branchToSem: {"EIE":["5"],"EEE":["5"]}),
    //* VERIFIED FOR EIE EEE 6 ONLY
    Subject(117, "DIGITAL SIGNAL PROCESSING AND APPLICATIONS",branchToSem: {"EIE":["6"],"EEE":["6"]}),

    //6TH SEM

    //MECH
    //*VERIFIED
    Subject(118, "METAL CUTTING AND MACHINE TOOLS",branchToSem: {"MECH":["5"],"PE":["5"]}),
    //! DELETE
    // Subject(119, "REFRIGIRATOR AND AIR CONDITIONING",  ),
    // Subject(120, "HYDRAULIC MACHINERY AND SYSTEMS",  ),
    //*VERIFIED
    Subject(121, "METROLOGY AND INSTRUMENTATION",branchToSem: {"MECH":["6"],"PE":["6"]}),
    //* VERIFIED
    Subject(122, "AUTOMOBILE ENGINEERING",branchToSem: {"MECH":["6"],"PE":["6"]},subjectType: SubjectType.Elective),
    //CSE
    //*VERIFIED
    Subject(123, "DESIGN AND ANALYSIS OF ALGORITHMS",branchToSem: {"CSE":["6"],"IT":["6"],}),
    //* VERIFIED
    Subject(124, "SOFTWARE ENGINEERING",branchToSem: {"CSE":["5",'7'],"IT":["5",'7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']}),
    //  VERIFIED NAME COMPUTER NETWORKS AND PROGRAMMING --> COMPUTER NETWORKS
    // Subject(125, "COMPUTER NETWORKS",branchToSem: {"CSE":["6"]}),
    //! Delete
    // Subject(126, "WEB PROGRAMMING",  ),
    //IT
    //* VERIFIED CHANGED FROM WEB APPLICATION DEVELOPMENT --> Web and Internet Technologies 
    // Subject(127, "WEB APPLICATION DEVELOPMENT",  ,branchToSem: {"IT":["5"]}),
    Subject(127, "Web and Internet Technologies",branchToSem: {"CSE":["5"]},subjectType: SubjectType.Elective),
    //! DELETE [EXTRA]
    // Subject(128, "COMPILER CONSTRUCTION",  ),
    // Subject(129, "EMBEDDED SYSTEM",  ),
    //!  DELETE [EXTRA]
    // Subject(130, "DESIGN AND ANALYSIS OF ALGORITHMS",  ),
    //ECE
    //*VERIFIED
    Subject(131, "DIGITAL COMMUNICATION",branchToSem: {"ECE":["6"]}),
    //* VERIIFED [ CHANGED 'ANTENNAS'->'ANTENNA', SEM 6 TO 5]
    Subject(132, "ANTENNA AND WAVE PROPAGATION",branchToSem: {'ECE':["5"]}),
    //* Verified
    Subject(133, "MICROPROCESSOR AND MICROCONTROLLER",branchToSem:{"ECE":["5"]}),
    //! DELETE [EXTRA]
    // Subject(134, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",  ),
    //CIVIL
    //*VERIFIED
    Subject(135, "STEEL STRUCTURES",branchToSem: {"CIVIL":["6"]},subjectType: SubjectType.Elective),
    //! DELETE
    // Subject(136, "STRUCTURAL ENGINEERING DESIGN AND DETAILING-I(CONCRETE)", 
        // ),
    // Subject(137, "THEORY OF STRUCTURES-II",  ),
    // Subject(138, "WATER RESOURCE MANAGEMENT-II",  ),
    // Subject(139, "SOIL MECHANICS",  ),
    // Subject(140, "TRANSPORTATION ENGINEERING-II",  ),
    //EEE
    //!DELETE
    // Subject(141, "ELECTRICAL MACHINES-III",  ),
    //! DELETE [EXTRA]
    // Subject(142, "MICROPROCESSOR AND MICROCONTROLLER",  ),
    // Subject(143, "SWITCHGEAR AND PROTECTION",  ),
    // Subject(144, "RENEWABLE ENERGY TECHNOLOGIES",  ),

    //7TH SEM

    // ********************************* 4th year ***************************************************    

    //!NEW ADDED SUBJECTS
    //7th SEM
    Subject(291, "Green Building Technologies",branchToSem: {'CSE':['7'],'IT':['7'],'ECE':['7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(292, "Fundamentals of IoT",branchToSem: {'CSE':['7'],'IT':['7'],'ECE':['7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(293, "Non-Conventional Energy Sources",branchToSem: {'CSE':['7'],'IT':['7'],'ECE':['7'],'EEE':['6','7'],'CIVIL':['7'],'MECH':['7'],'EIE':['6','7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(294, "Entrepreneurship",branchToSem: {'CSE':['7'],'IT':['7'],'ECE':['7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7']},subjectType: SubjectType.Elective),
    Subject(295, "Principles of Electronic Communications",branchToSem: {'CSE':['7'],'IT':['7'],'EEE':['7'],'CIVIL':['7'],'MECH':['7'],'EIE':['7'],'PE':['7'],"ECE":["6"]},subjectType: SubjectType.Elective),
    Subject(296, "Illumination and Electric Traction systems",branchToSem: {'CSE':['7'],'IT':['7'],'EEE':['6','7'],'CIVIL':['7'],'MECH':['7'],'EIE':['6','7'],'PE':['7']},subjectType: SubjectType.Elective),
    
    //ECE
    Subject(297, "Mobile and Cellular Communications",branchToSem: {'ECE':['7']},subjectType: SubjectType.Elective),
    Subject(298, "Speech Signal Processing",branchToSem: {'ECE':['7']},subjectType: SubjectType.Elective),
    // Subject(299, "Digital Signal Processor Architectures",branchToSem: {'ECE':['7']},subjectType: SubjectType.Elective),
    
    //EEE
    Subject(300, "Digital Signal Processor Architectures",branchToSem: {'ECE':['7']},subjectType: SubjectType.Elective),

    //EIE
    Subject(301, "Opto-Electronic Instrumentation",branchToSem: {'EIE':['7']}),
    Subject(302, "Virtual Instrumentation",branchToSem: {'EIE':['7']}),
    Subject(303, "Analytical Instrumentation",branchToSem: {'EIE':['7']}),

    //PE
    Subject(304, "Tool Design",branchToSem: {'PE':['7'],'MECH':['8']}),

    //! 8TH SEM

    //* CSE DONE
    Subject(305, "Mobile Computing",branchToSem: {'CSE':['8']},subjectType: SubjectType.Elective),
    Subject(306, "Multicore and GPU Programming",branchToSem: {'CSE':['8']},subjectType: SubjectType.Elective),
    //IT
    Subject(307, "Distributed Databases",branchToSem: {'IT':['8']},subjectType: SubjectType.Elective),
    //ECE
    Subject(308, "Field Programmable Gate Arrays",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(309, "Neural Networks",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(310, "Satellite Communications",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(311, "Wireless Sensor Networks",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(312, "Global Navigational Satellite Systems",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(313, "System Verilog",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(314, "Multirate Signal Processing",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(315, "Real Time Operating Systems",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(316, "Fuzzy Logic And Applications",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(317, "Radar Systems",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    Subject(318, "Digital Fault Tolerant Systems",branchToSem: {'ECE':['8']},subjectType: SubjectType.Elective),
    //EEE
    Subject(319, "Power System Reliability",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(320, "Electric Vehicle and Hybrid Electric Vehicle",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(321, "Machine Modelling Analysis",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(322, "High Voltage DC Transmission",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(323, "Advanced Control Systems",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(324, "Electrical Estimation Costing & Safety",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(325, "Advanced Power Electronics",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(326, "Power Quality",branchToSem: {'EEE':['8'],"EIE":["8"]},subjectType: SubjectType.Elective),
    Subject(327, "Smart Grid Technologies",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(328, "Energy Management Systems and SCADA",branchToSem: {'EEE':['8'],'EIE':["8"]},subjectType: SubjectType.Elective),
    Subject(329, "Special Electrical Machines",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(330, "Power Electronics Applications to Renewable Energy",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    Subject(331, "Electrical Substation Design and Equipment",branchToSem: {'EEE':['8']},subjectType: SubjectType.Elective),
    //CIVIL
    Subject(332, "Construction Management AND Technology",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(333, "Retrofitting and Rehabilitation of Structures",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(334, "Computer Aided Analysis and Design",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(335, "Applied Hydrology",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(336, "Introduction to Climate Change",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(337, "Structural Dynamics",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(338, "Design with Geosynthetics",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(339, "Groundwater Management",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(340, "Intelligent Transportation Systems",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(341, "Prefabrication Engineering",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(342, "Advanced Reinforced Concrete Design",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    Subject(343, "Traffic Engineering & Infrastructure Design",branchToSem: {'CIVIL':['8']},subjectType: SubjectType.Elective),
    //MECH
    Subject(344, "Mechanical Vibrations",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(345, "Composite Materials",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(346, "Non-Destructive Testing",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(347, "Power Plant Engineering",branchToSem: {'MECH':['8']},subjectType: SubjectType.Elective),
    Subject(348, "Product Design And Process Planning",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(349, "Intellectual Property Rights",branchToSem: {'MECH':['8'],'PE':['8'],},subjectType: SubjectType.Elective),
    Subject(350, "Machine Tool Engineering and Design",branchToSem: {'MECH':['8'],'PE':['8'],},subjectType: SubjectType.Elective),
    Subject(351, "Energy Conservation and Management",branchToSem: {'MECH':['8'],'PE':['8'],},subjectType: SubjectType.Elective),
    Subject(352, "Advanced Propulsion and Space Science",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(353, "Waste Heat Recovery and Co-Generation",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    Subject(354, "Aerodynamic Design of Thermal Turbines",branchToSem: {'MECH':['8'],'PE':['8']},subjectType: SubjectType.Elective),
    //EIE
    Subject(355, "Advance Programmable Logic Controller",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(356, "Digital Control Systems",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(357, "Automation in Process Control",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(358, "Hydraulic & Pneumatics",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(359, "Software Design tools for Sensing & Control",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(360, "Advance Digital Signal Processing",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(361, "Biomedical Signal Processing",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(362, "Power plant design and safety management",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    Subject(363, "Digital Image Processing",branchToSem: {'EIE':['8']},subjectType: SubjectType.Elective),
    //PE
    Subject(364, "Total Quality Management",branchToSem: {'PE':['8']},subjectType: SubjectType.Elective),
    Subject(365, "Rapid Prototyping Technologies",branchToSem: {'PE':['8']},subjectType: SubjectType.Elective),
    Subject(366, "Plastic Engineering and Technology",branchToSem: {'PE':['8']},subjectType: SubjectType.Elective),
    

    //MECH
    //* VERIFIED
    Subject(145, "THERMAL TURBO MACHINES",branchToSem: {'MECH':['7']}),
    //* VERIFIED
    Subject(146, "FINITE ELEMENT ANALYSIS",branchToSem: {"MECH":["6",'7'],"PE":["6",'7']}),
    //* VERIFIED
    Subject(147, "INDUSTRIAL ENGINEERING",branchToSem: {'ECE':['7']}),
    //* VERIFIED
    Subject(148, "PRODUCTION AND OPERATIONS MANAGEMENT",branchToSem: {'ECE':['7'],'PE':['7']}),
    //! DELETE [EXTRA]
    // Subject(149, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",),
    //CSE
    //* VERIFIED
    Subject(150, "COMPILER CONSTRUCTION",branchToSem: {"CSE":["6",'7'],"IT":["6"]}),
    //* VERIFIED
    Subject(151, "INFORMATION SECURITY",branchToSem: {'CSE':['7']}),
    //*VERIFIED
    Subject(152, "DISTRIBUTED SYSTEMS",branchToSem: {"IT":["6","8"],"CSE":['7'],},subjectType: SubjectType.Elective),
    //*VERIFIED
    Subject(153, "DATA MINING",branchToSem: {"CSE":["6",'7'],"IT":["6"],}),
    //IT
    //*VERIFIED
    Subject(154, "VLSI DESIGN",branchToSem: {'IT':['7'],'ECE':['7']}),
    //*VERIFIED
    Subject(155, "BIG DATA ANALYTICS",branchToSem: {'IT':['7']}),
    //*VERIFIED
    Subject(156, "WIRELESS MOBILE COMMUNICATION",branchToSem: {'IT':['7']}),
    //*VERIFIED
    Subject(157, "NETWORK SECURITY AND CRYPTOGRAPHY",branchToSem: {'IT':['7']}),
    //ECE
    //! DELETE [EXTRA]
    // Subject(158, "EMBEDDED SYSTEM",),
    // Subject(159, "VLSI DESIGN",),
    //*VERIFIED
    Subject(160, "MICROWAVE TECHNIQUES",branchToSem: {'ECE':['7']}),
    //*VERIFIED
    Subject(161, "INDUSTRIAL ADMINISTRATION AND FINANCIAL MANAGEMENT",branchToSem: {'ECE':['7']}),
    //*VERIFIED
    Subject(162, "HUMAN VALUES AND PROFESSIONAL ETHICS",branchToSem: {'ECE':['7']}),
    //EEE
    //*VERIFIED
    Subject(163, "POWER SYSTEM OPERATION AND CONTROL",branchToSem: {'EEE':['7']}),
    //*VERIFIED
    Subject(164, "ELECTRIC DRIVES AND STATIC CONTROL",branchToSem: {'EEE':['7']}),
    //*VERIFIED
    Subject(165, "ELECTRICAL MACHINE DESIGN",branchToSem: {'EEE':['7']}),
    //CIVIL
    //*VERIFIED
    Subject(
        166, "STRUCTURAL ENGINEERING AND DRAWING-II(STEEL)",branchToSem: {'CIVIL':['7']}),
    //*VERIFIED
    Subject(167, "ESTIMATION COSTING AND SPECIFICATIONS",branchToSem: {'CIVIL':['7']}),
    //*VERIFIED
    Subject(168, "FINITE ELEMENT TECHNIQUES",branchToSem: {'CIVIL':['7']}),
    //*VERIFIED
    Subject(169, "PRESTRESSED CONCRETE",branchToSem: {'CIVIL':['7']}),
    //*VERIFIED
    Subject(170, "FOUNDATION ENGINEERING",branchToSem: {"CIVIL":["6",'7']},),

    //8TH SEM
    //! DELETE [USELESS] 
    // Subject(171, "PROFESSIONAL ELECTIVE-IV", ),
    //! DELETE [USELESS] 
    // Subject(172, "PROFESSIONAL ELECTIVE-III", ),
    //! DELETE [USELESS] 
    // Subject(173, "PROFESSIONAL ELECTIVE-V", ),
    //! DELETE
    // Subject(174, "UTILISATION OF ELECTRICAL ENERGY",  ),
    //! DELETE [EXTRA]
    // Subject(175, "GENDER SENSITIZATION",  ),
    //* VERIFIED 
    // Subject(176, "CONSTRUCTION MANAGEMENT AND TECHNOLOGY",branchToSem: {"CIVIL":["8"]},subjectType: SubjectType.Elective),
    //! DELETE [USELESS] 
    // Subject(177, "PROFESSIONAL ELECTIVE-II",  ),
  ];


// @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SearchViewModel>.reactive(
//         builder: (context, model, child) => Scaffold(),
//         viewModelBuilder:() => SearchViewModel());
//   }

static List<Subject> allOldSubjects = [

    //1ST  SEM
    Subject(1, "ENVIRONMENTAL SCIENCE"),
    Subject(2, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE"),
    Subject(3, "MATHEMATICS-I",),
    Subject(4, "CHEMISTRY"),
    Subject(5, "PROGRAMMING FOR PROBLEM SOLVING", 
        ),
    Subject(6, "INDIAN CONSTITUTION", ),
    Subject(7, "PHYSICS", ),
    Subject(
        8, "BASIC ELECTRICAL ENGINEERING", ),

    //2ND SEM
    Subject(9, "MATHEMATICS-II",
        ),
    Subject(10, "ENGLISH",
        ),
    Subject(11, "INDIAN CONSTITUTION", ),
    Subject(12, "PHYSICS", ),
    Subject(13, "BASIC ELECTRICAL ENGINEERING",
        ),
    Subject(14, "ENVIRONMENTAL SCIENCE",),
    Subject(15, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE",
      ),
    Subject(16, "CHEMISTRY",),
    Subject(17, "PROGRAMMING AND PROBLEM SOLVING",
      ),

    //3RD SEM

    //COMMON SUBJECTS
    Subject(18, "INDIAN CONSTITUTION", ),
    Subject(19, "ENVIRONMENTAL SCIENCE", ),
    Subject(20, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE",
        ),
    Subject(21, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH",
        ),
    Subject(22, "FINANCE AND ACCOUNTING", ),
    Subject(23, "MATHEMATICS-III(PDE,PROB&STATS)",),
    Subject(24, "MATHEMATICS-III(PROB&STATS)", ),
    Subject(25, "BASIC ELECTRONICS", ),
    Subject(26, "BIOLOGY FOR ENGINEERS", ),
    Subject(27, "DIGITAL ELECTRONICS", ),
    Subject(28, "ENGINEERING MECHANICS", ),
    Subject(29, "INDUSTRIAL PSYCHOLOGY", ),
    Subject(30, "ENERGY SCIENCES AND ENGINEERING", ),
    //MECH
    Subject(31, "METALLURGY AND MATERIAL SCIENCE", ),
    Subject(32, "THERMODYNAMICS", ),
    //CSE
    Subject(33, "OPERATIONS RESEARCH", ),
    Subject(34, "DATA STRUCTURES AND ALGORITHMS", ),
    Subject(35, "DISCRETE MATHEMATICS", ),
    Subject(36, "PROGRAMMING LANGUAGES", ),
    //IT
    Subject(37, "DATA STRUCTURES", ),
    Subject(
        38, "MATHEMATICAL FOUNDATIONS OF INFORMATION TECHNOLOGY", ),
    //ECE
    Subject(39, "ELEMENTS OF MECHANICAL ENGINEERING", ),
    Subject(40, "ELECTRONIC DEVICES", ),
    Subject(41, "NETWORK THEORY", ),
    //CIVIL
    Subject(42, "SOLID MECHANICS", ),
    Subject(43, "ENGINEERING GEOLOGY", ),
    Subject(44, "SURVEYING AND GEOMATICS", ),
    //EEE
    Subject(45, "ANALOG ELECTRONICS", ),
    Subject(46, "ELECTRICAL CIRCUIT ANALYSIS", ),
    Subject(47, "ELECTROMAGNETIC FIELDS", ),

    //4TH SEM

    //COMMON SUBJECTS
    Subject(48, "INDIAN CONSTITUTION",  ),
    Subject(49, "ENVIRONMENTAL SCIENCE",  ),
    Subject(50, "ESSENCE OF INDIAN TRADITIONAL KNOWLEDGE", 
        ),
    Subject(51, "EFFECTIVE TECHNICAL COMMUNICATION IN ENGLISH", 
        ),
    Subject(52, "FINANCE AND ACCOUNTING",  ),
    Subject(53, "MATHEMATICS-III(PROB&STATS)", ),
    Subject(54, "MATHEMATICS-III(PDE,PROB&STATS)",  ),
    Subject(55, "BIOLOGY FOR ENGINEERS",  ),
    Subject(56, "INDUSTRIAL PSYCHOLOGY",  ),
    Subject(57, "ELEMENTS OF MECHANICAL ENGINEERING",  ),
    Subject(58, "SIGNALS AND SYSTEMS",  ),
    //MECH
    Subject(59, "ENERGY SCIENCES AND ENGINEERING",  ),
    Subject(60, "MECHANICS OF MATERIALS",  ),
    Subject(61, "APPLIED THERMODYNAMICS",  ),
    Subject(62, "KINEMATICS OF MACHINERY",  ),
    Subject(63, "MANUFACTURING PROCESS",  ),
    //CSE
    Subject(64, "OOP USING JAVA",  ),
    Subject(65, "COMPUTER ORGANISATION",  ),
    Subject(66, "DATABASE MANAGEMENT SYSTEMS",  ),
    //IT
    Subject(67, "OPERATIONS RESEARCH",  ),
    Subject(68, "JAVA PROGRAMMING",  ),
    Subject(69, "DATABASE SYSTEMS",  ),
    Subject(70, "COMPUTER ORGANISATION AND MICROPROCESSOR",  ),
    Subject(71, "DATA COMMUNICATIONS",  ),
    //ECE
    Subject(72, "ANALOG ELECTRONIC CIRCUITS",  ),
    Subject(73, "ELECTROMAGNETIC THEORY AND MAGNETIC LINES",  ),
    Subject(74, "PULSE AND LINEAR INTEGRATED CIRCUITS",  ),
    Subject(75, "COMPUTER ORGANISATION AND ARCHITECHTURE",  ),
    //CIVIL
    Subject(76, "MECHANISMS OF MATERIALS AND STRUCTURES",  ),
    Subject(77, "FLUID MECHANICS",  ),
    Subject(78, "MATERIALS:TESTING AND EVALUATION",  ),
    //EEE
    Subject(79, "ELECTRICAL MACHINES-I",  ),
    Subject(80, "DIGITAL ELECTRONICS AND LOGIC DESIGN",  ),
    Subject(81, "POWER ELECTRONICS",  ),

    //5TH SEM

    //COMMON SUBJECTS
    Subject(82, "GENDER SENSITIZATION",  ),
    Subject(83, "OPERATING SYSTEMS", ),
    //MECH
    Subject(84, "MANUFACTURING PROCESSES",  ),
    Subject(85, "DYNAMICS OF MACHINES",  ),
    Subject(86, "MACHINE DESIGN",  ),
    Subject(87, "HEAT TRANSFER",  ),
    Subject(88, "OPERATIONS RESEARCH",  ),
    Subject(89, "CAD/CAM",  ),
    //CSE
    Subject(90, "DATABASE MANAGEMENT SYSTEMS",  ),
    Subject(91, "DATA COMMUNICATIONS",  ),
    Subject(92, "AUTOMATA LANGUAGES AND COMPUTATION",  ),
    Subject(93, "COMPUTER GRAPHICS",  ),
    Subject(94, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",  ),
    Subject(95, "ARTIFICIAL INTELLIGENCE",  ),
    //IT
    Subject(96, "SOFTWARE ENGINEERING",  ),
    Subject(97, "DATABASE SYSTEMS",  ),
    Subject(98, "AUTOMATA THEORY",  ),
    Subject(99, "COMPUTER NETWORKS",  ),
    //ECE
    Subject(100, "ANALOG COMMUNICATION",  ),
    Subject(101, "DIGITAL SIGNAL PROCESSING",  ),
    Subject(102, "AUTOMATIC CONTROL SYSTEMS",  ),
    Subject(103, "LINEAR ICS AND APPLICATIONS",  ),
    Subject(104, "COMPUTER ORGANISATION AND ARCHITECHTURE",  ),
    Subject(105, "DIGITAL SYSTEM DESIGN WITH VERILOG HDL",  ),
    //CIVIL
    Subject(106, "REINFORCEMENT CEMENT CONCRETE",  ),
    Subject(107, "THEORY OF STRUCTURES-I",  ),
    Subject(108, "CONCRETE TECHNOLOGY",  ),
    Subject(109, "HYDRAULIC MACHINES",  ),
    Subject(110, "TRANSPORTATION ENGINEERING-I",  ),
    Subject(111, "ENVIRONMENTAL ENGINEERING",  ),
    Subject(112, "WATER RESOURCE ENGINEERING-I",  ),
    //EEE
    Subject(113, "POWER SYSTEMS-II",  ),
    Subject(114, "ELECTRICAL MACHINES-II",  ),
    Subject(115, "ELECTRICAL MEASUREMENTS AND INSTRUMENTATION",  ),
    Subject(116, "LINEAR CONTROL SYSTEMS",  ),
    Subject(117, "DIGITAL SIGNAL PROCESSING AND APPLICATIONS",  ),

    //6TH SEM

    //MECH
    Subject(118, "METAL CUTTING AND MACHINE TOOLS",  ),
    Subject(119, "REFRIGIRATOR AND AIR CONDITIONING",  ),
    Subject(120, "HYDRAULIC MACHINERY AND SYSTEMS",  ),
    Subject(121, "METROLOGY AND INSTRUMENTATION",  ),
    Subject(122, "AUTOMOBILE ENGINEERING",  ),
    //CSE
    Subject(123, "DESIGN AND ANALYSIS OF ALGORITHMS",  ),
    Subject(124, "SOFTWARE ENGINEERING",  ),
    Subject(125, "COMPUTER NETWORKS AND PROGRAMMING",  ),
    Subject(126, "WEB PROGRAMMING",  ),
    //IT
    Subject(127, "WEB APPLICATION DEVELOPMENT",  ),
    Subject(128, "COMPILER CONSTRUCTION",  ),
    Subject(129, "EMBEDDED SYSTEM",  ),
    Subject(130, "DESIGN AND ANALYSIS OF ALGORITHMS",  ),
    //ECE
    Subject(131, "DIGITAL COMMUNICATION",  ),
    Subject(132, "ANTENNAS AND WAVE PROPAGATION",  ),
    Subject(133, "MICROPROCESSOR AND MICROCONTROLLER",  ),
    Subject(134, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",  ),
    //CIVIL
    Subject(135, "STEEL STRUCTURES",  ),
    Subject(136, "STRUCTURAL ENGINEERING DESIGN AND DETAILING-I(CONCRETE)", 
        ),
    Subject(137, "THEORY OF STRUCTURES-II",  ),
    Subject(138, "WATER RESOURCE MANAGEMENT-II",  ),
    Subject(139, "SOIL MECHANICS",  ),
    Subject(140, "TRANSPORTATION ENGINEERING-II",  ),
    //EEE
    Subject(141, "ELECTRICAL MACHINES-III",  ),
    Subject(142, "MICROPROCESSOR AND MICROCONTROLLER",  ),
    Subject(143, "SWITCHGEAR AND PROTECTION",  ),
    Subject(144, "RENEWABLE ENERGY TECHNOLOGIES",  ),

    //7TH SEM

    //MECH
    Subject(145, "THERMAL TURBO MACHINES",),
    Subject(146, "FINITE ELEMENT ANALYSIS",),
    Subject(147, "INDUSTRIAL ENGINEERING",),
    Subject(148, "PRODUCTION AND OPERATIONS MANAGEMENT",),
    Subject(149, "MANAGERIAL ECONOMICS AND ACCOUNTANCY",),
    //CSE
    Subject(150, "COMPILER CONSTRUCTION",),
    Subject(151, "INFORMATION SECURITY",),
    Subject(152, "DISTRIBUTED SYSTEMS",),
    Subject(153, "DATA MINING",),
    //IT
    Subject(154, "VLSI DESIGN",),
    Subject(155, "BIG DATA ANALYTICS",),
    Subject(156, "WIRELESS MOBILE COMMUNICATION",),
    Subject(157, "NETWORK SECURITY AND CRYPTOGRAPHY",),
    //ECE
    Subject(158, "EMBEDDED SYSTEM",),
    Subject(159, "VLSI DESIGN",),
    Subject(160, "MICROWAVE TECHNIQUES",),
    Subject(161, "INDUSTRIAL ADMINISTRATION AND FINANCIAL MANAGEMENT"),
    Subject(162, "HUMAN VALUES AND PROFESSIONAL ETHICS",),
    //EEE
    Subject(163, "POWER SYSTEM OPERATION AND CONTROL",),
    Subject(164, "ELECTRIC DRIVES AND STATIC CONTROL",),
    Subject(165, "ELECTRICAL MACHINE DESIGN",),
    //CIVIL
    Subject(
        166, "STRUCTURAL ENGINEERING AND DRAWING-II(STEEL)",),
    Subject(167, "ESTIMATION COSTING AND SPECIFICATIONS",),
    Subject(168, "FINITE ELEMENT TECHNIQUES",),
    Subject(169, "PRESTRESSED CONCRETE",),
    Subject(170, "FOUNDATION ENGINEERING",),

    //8TH SEM
    Subject(171, "PROFESSIONAL ELECTIVE-IV", 
        ),
    Subject(172, "PROFESSIONAL ELECTIVE-III", 
        ),
    Subject(173, "PROFESSIONAL ELECTIVE-V", 
        ),
    Subject(174, "UTILISATION OF ELECTRICAL ENERGY",  ),
    Subject(175, "GENDER SENSITIZATION",  ),
    Subject(176, "CONSTRUCTION MANAGEMENT AND TECHNOLOGY",  ),
    Subject(177, "PROFESSIONAL ELECTIVE-II",  ),
  ];
}