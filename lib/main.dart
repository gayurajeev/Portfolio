import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<_HomePageState> homeKey = GlobalKey<_HomePageState>();

void main() => runApp(MyPortfolioApp());

class MyPortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gayathry Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.pink[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[400],
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return HomePage(key: homeKey, args: args);
        },
        '/about': (context) => AboutPage(),
        '/projects': (context) => ProjectsPage(),
        '/contact': (context) => ContactPage(),
      },
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  CustomAppBar(this.context);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Gayathry Rajeev'),
      actions: [
        _navButton(context, '/', 'Home'),
        _navButton(context, '/about', 'About Me'),
        _navButton(context, '/', 'Projects', isProjectButton: true),
        _navButton(context, '/contact', 'Contact'),
      ],
    );
  }

  Widget _navButton(BuildContext context, String route, String label, {bool isProjectButton = false}) {
    return TextButton(
      onPressed: () {
        if (isProjectButton) {
          if (ModalRoute.of(context)?.settings.name != '/') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
                  (route) => false,
              arguments: {'scrollToProjects': true},
            );
          } else {
            if (homeKey.currentState != null) {
              homeKey.currentState!.scrollToProjects();
            }
          }
        } else {
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        }
      },
      child: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? args;
  HomePage({Key? key, this.args}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = widget.args ?? ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['scrollToProjects'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToProjects();
      });
    }
  }

  void scrollToProjects() {
    final context = _projectsKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget sectionTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink[300]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6),
        Container(width: 80, height: 3, color: Colors.pink[300]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Hi, I'm Gayathry Rajeev",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink[300]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Industrial Engineering student and an Aspiring Data Analyst",
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),

            sectionTitle("My Tools"),
            SizedBox(height: 10),
            Text(
              "These are the keys to unlock the power of data",
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                ToolCard(title: 'Python', icon: Icons.code),
                ToolCard(title: 'SQL', icon: Icons.storage),
                ToolCard(title: 'Excel', icon: Icons.grid_on),
                ToolCard(title: 'Power BI', icon: Icons.bar_chart),
              ],
            ),

            SizedBox(height: 50),
            sectionTitle("Professional Certificates"),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CertificateCard(imagePath: 'assets/certificate1.png', title: 'Data Analysis with Python'),
                SizedBox(width: 20),
                CertificateCard(imagePath: 'assets/certificate2.png', title: 'Python 101 for Data Science'),
              ],
            ),

            SizedBox(height: 50),

            Container(
              key: _projectsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sectionTitle("Portfolio Projects"),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      ProjectCard(
                        title: 'EDA on US Accidents dataset',
                        tools: 'Python, Pandas',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/projects',
                          arguments: {
                            'title': '📊 Exploratory Data Analysis on US Accidents Dataset',
                            'description':
                            'To explore and analyze the US Accidents dataset to uncover patterns, trends, and insights related to road accidents across the United States from 2016 to 2021.',
                            'toolsUsed': 'Python, Pandas, NumPy, Matplotlib, Seaborn, Plotly',
                            'methodology': '''• Cleaned and preprocessed over 2.8 million rows of accident data including handling missing values, feature engineering, and converting timestamps.\n
• Analyzed accident severity distribution, finding that the majority were of severity level 2, indicating moderate impact.\n
• Discovered peak accident hours to be during rush hours (7–9 AM and 4–6 PM), indicating the influence of work commute on accident rates.\n
• Identified California, Florida, and Texas as the states with the highest number of accidents.\n
• Visualized weather impact, revealing that rain, fog, and snow conditions correlate with increased accident severity and frequency.\n
• Created interactive visualizations using Plotly to showcase spatial patterns and time-series trends in accident data.\n
• Provided actionable insights for traffic safety improvements and emergency response planning.''',
                            'summary':
                            'This project helped build my confidence in working with large real-world datasets, strengthened my data cleaning and visualization skills, and showcased my ability to draw meaningful conclusions from data.',
                            'githubLink': 'https://github.com/gayurajeev/Python-EDA',
                          },
                        ),
                      ),
                      ProjectCard(
                        title: 'Retail Sales Analysis',
                        tools: 'SQL, Pandas',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/projects',
                          arguments: {
                            'title': '🛒 Retail Sales Analysis Using SQL and Pandas',
                            'description': '''
To analyze retail sales data to understand customer buying behavior, sales trends, and product performance, helping businesses make data-driven decisions.

Tools Used:
SQL for data extraction and aggregation, Python (Pandas, Matplotlib, Seaborn) for data manipulation and visualization.
''',
                            'methodology': '''

- Extracted and joined multiple tables from a relational database using complex SQL queries to gather sales, customer, and product data.

- Performed data cleaning and transformation in Pandas to prepare the dataset for analysis.

- Analyzed sales trends over time, identifying peak sales periods and seasonal variations.

- Conducted customer segmentation based on purchase patterns to highlight high-value customers.

- Evaluated product category performance and identified top-selling and underperforming products.

- Created clear visualizations to communicate insights and support strategic retail decisions.
''',
                            'summary': '''
Enhanced skills in SQL querying and data manipulation with Pandas, and gained practical experience in translating raw sales data into actionable business insights.

GitHub Repository:
https://github.com/gayurajeev/Retail-Sales-SQL
''',
                            'githubLink': 'https://github.com/gayurajeev/Retail-Sales-SQL',
                          },
                        ),
                      ),
                      ProjectCard(
                        title: 'Coffee Sales Dashboard',
                        tools: 'Excel',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/projects',
                          arguments: {
                            'title':  '☕ Coffee Sales Dashboard (Excel Project)',
                            'description': '''
This project involves building an interactive Excel dashboard to analyze coffee sales data across multiple countries. It demonstrates proficiency in data cleaning, advanced Excel functions like XLOOKUP, pivot tables, and interactive visualizations using slicers and charts. The goal was to derive insights into regional sales trends and product performance.
''',
                            'toolsUsed': 'Microsoft Excel (XLOOKUP, Pivot Tables, Pivot Charts, Slicers)',
                            'methodology': '''
• Data Cleaning:
  - Removed duplicates, standardized column headers, and formatted data types for consistency
  - Split and combined fields where necessary to support further analysis

• Data Enrichment with XLOOKUP:
  - Used XLOOKUP function to merge additional fields like region/customer details
  - Created dynamic references for flexible data analysis

• Exploratory Data Analysis:
  - Built pivot tables to summarize sales by country, product, and date
  - Designed visualizations showing total sales by country and top performers

• Interactive Dashboard:
  - Implemented slicers for intuitive data filtering
  - Used conditional formatting to highlight key metrics
  - Organized layout for optimal user experience
''',
                            'summary': '''
This Excel dashboard provides actionable insights into coffee sales performance across different regions. The interactive features allow stakeholders to explore data dynamically and identify business opportunities. The project showcases advanced Excel skills in data transformation, analysis, and visual presentation - valuable for any data-driven business role.
''',
                            'githubLink': 'https://github.com/gayurajeev/Excel-Dashboard',
                          },
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ToolCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 60,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.pink.shade200, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.pink[400], size: 24),
          SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.pink[400], fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const CertificateCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            boxShadow: [BoxShadow(color: Colors.pink.shade200, blurRadius: 10, offset: Offset(0, 4))],
          ),
        ),
        SizedBox(height: 10),
        Text(title, style: TextStyle(color: Colors.pink[300], fontSize: 14)),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String tools;
  final VoidCallback onTap;

  const ProjectCard({required this.title, required this.tools, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 220,
          height: 140,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.pink.shade200, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.pink[400], fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 6),
              Text("Tools: $tools", style: TextStyle(color: Colors.grey[700], fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    Future<void> _launchURL(String url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the URL')),
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(context),
      backgroundColor: Colors.pink[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: args == null
            ? Center(child: Text("No project selected.", style: TextStyle(fontSize: 16, color: Colors.pink[300])))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(args['title'] ?? '', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink[300])),
            SizedBox(height: 16),
            _section("Description", args['description']),
            _section("Methodology", args['methodology']),
            _section("Summary", args['summary']),
            if (args['githubLink'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(args['githubLink']),
                  icon: Icon(Icons.link),
                  label: Text('View on GitHub'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.pink[300])),
        SizedBox(height: 8),
        Text(content ?? '', style: TextStyle(fontSize: 16, color: Colors.white, height: 1.6)),
        SizedBox(height: 20),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      backgroundColor: Colors.pink[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _sectionHeader("About Me"),
            SizedBox(height: 30),
            Text(
              "I'm Gayathry Rajeev, a passionate learner and aspiring Data Analyst currently pursuing B.Tech in Industrial Engineering.\n\n"
                  "I thrive at the intersection of technology and insight, and I believe data has the power to transform industries and improve lives. "
                  "I'm always eager to explore new tools, technologies, and meaningful projects that drive positive impact.",
              style: TextStyle(fontSize: 16, color: Colors.white, height: 1.6),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            _infoBlock(
              icon: Icons.school,
              title: "🎓 Education",
              content: "- College of Engineering Trivandrum\n- B.Tech in Industrial Engineering (2023–2027)\n- Current CGPA: 9.0",
            ),
            _infoBlock(
              icon: Icons.code,
              title: "🛠 Technical Skills",
              content: "• Python\n• SQL\n• Excel\n• Power BI\n• Exploratory Data Analysis",
            ),
            _infoBlock(
              icon: Icons.star,
              title: "💡 Personal Strengths",
              content: "• Leadership\n• Communication\n• Writing Skills",
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink[300]), textAlign: TextAlign.center),
        SizedBox(height: 6),
        Container(width: 60, height: 3, color: Colors.pink[300]),
      ],
    );
  }

  Widget _infoBlock({required IconData icon, required String title, required String content}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.pink[300], size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style
                    : TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.pink[300])),
                SizedBox(height: 6),
                Text(content, style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context),
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Text(
          "Contact Page Coming Soon",
          style: TextStyle(fontSize: 22, color: Colors.pink[300]),
        ),
      ),
    );
  }
}