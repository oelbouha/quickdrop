import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/help_model.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  int? expandedFaqIndex;

  final List<Map<String, String>> faqs = [
    {
      "question": "How does QuickDrop ensure package safety?",
      "answer":
          "All couriers are verified through ID checks and background screening. Every package is insured, tracked in real-time, and handled with care by trusted travelers."
    },
    {
      "question": "What can I ship with QuickDrop?",
      "answer":
          "You can ship documents, electronics, clothing, gifts, and most personal items. Prohibited items include hazardous materials, illegal substances, and fragile items without proper packaging."
    },
    {
      "question": "How much can I save compared to traditional shipping?",
      "answer":
          "Users typically save 50-70% compared to major carriers like FedEx or UPS, especially for international shipments. Prices vary based on size, weight, and destination."
    },
    {
      "question": "How do I become a courier?",
      "answer":
          "Simply Go to your profile click on become driver, fill your informtion and wait for approval,  and start requesting delivery requests on routes you're already traveling. You set your own prices and schedule."
    },
    {
      "question": "What if something goes wrong with my shipment?",
      "answer":
          "We provide 24/7 customer support . If there's any issue, our team will resolve it quickly."
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Help',
            style: TextStyle(
                color: AppColors.appBarText, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.appBarIcons),
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              const SizedBox(height: 24),
              const HelpfulTipsWidget(),
              const SizedBox(height: 24),
              _buildFAQSection(),
              const SizedBox(height: 24),
              AskQuestionWidget(),
              const SizedBox(height: 24),
            ])));
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Frequently Asked Questions",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            final isExpanded = expandedFaqIndex == index;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        expandedFaqIndex = isExpanded ? null : index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq["question"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF6B7280),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq["answer"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class AskQuestionWidget extends StatefulWidget {
  const AskQuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AskQuestionWidget> createState() => _AskQuestionWidgetState();
}

class _AskQuestionWidgetState extends State<AskQuestionWidget> {
  final TextEditingController _questionController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitSuccess = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    HelpModel question = HelpModel(
      senderId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      message: _questionController.text.trim(),
    );

    try {
      await FirebaseFirestore.instance
          .collection('questions')
          .add(question.toMap());

      if (mounted) {
        AppUtils.showDialog(context,
            "Your question has been added successfully!", AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context, "Failed to submit your question", AppColors.error);
      }
    }
    setState(() {
      _submitSuccess = true;
      _questionController.clear();
      _isSubmitting = false;
    });

    // Hide success message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _submitSuccess = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.green.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Still Have Questions?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:
                _submitSuccess ? _buildSuccessMessage() : _buildQuestionForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Icon(
            Icons.check,
            color: Colors.green.shade600,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Question Sent Successfully!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'We\'ll get back to you within 24 hours.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Can\'t find what you\'re looking for? Send us your question and our support team will help you out.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Your Question',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _questionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'What would you like to know about QuickDrop?',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleSubmitQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              disabledBackgroundColor: const Color(0xFF9CA3AF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Sending Question...'),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send, size: 16),
                      SizedBox(width: 8),
                      Text('Send Question'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}



// Helpful Tips Widget
class HelpfulTipsWidget extends StatelessWidget {
  const HelpfulTipsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'icon': Icons.inventory_2,
        'color': Colors.blue,
        'title': 'Package Smart',
        'description':
            'Use sturdy boxes and bubble wrap for fragile items. Label clearly with both sender and recipient information.'
      },
      {
        'icon': Icons.security,
        'color': Colors.green,
        'title': 'Stay Safe',
        'description':
            'Always verify courier profiles and ratings before booking. Meet in public places for handoffs when possible.'
      },
      {
        'icon': Icons.attach_money,
        'color': Colors.orange,
        'title': 'Save More',
        'description':
            'Book in advance and be flexible with delivery dates to get the best rates from our courier network.'
      },
      {
        'icon': Icons.group,
        'color': Colors.purple,
        'title': 'Build Trust',
        'description':
            'Leave honest reviews and maintain good communication with your courier throughout the delivery process.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.lightbulb,
                color: Colors.yellow.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Helpful Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tips List
        ListView.builder(
          itemCount: tips.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final tip = tips[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (tip['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tip['icon'] as IconData,
                      color: tip['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tip['description'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

