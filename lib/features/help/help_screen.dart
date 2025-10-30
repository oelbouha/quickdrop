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


  List<Map<String, String>> getFaqs(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      {"question": t.faq_q1, "answer": t.faq_a1},
      {"question": t.faq_q2, "answer": t.faq_a2},
      {"question": t.faq_q3, "answer": t.faq_a3},
      {"question": t.faq_q4, "answer": t.faq_a4},
      {"question": t.faq_q5, "answer": t.faq_a5},
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title:  Text(
            t.help_title,
            style:const  TextStyle(
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
    final t = AppLocalizations.of(context)!;
    final faqs = getFaqs(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          t.faq_title,
          style:const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
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
    final t = AppLocalizations.of(context)!;

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
            t.success_add_question, AppColors.succes);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context, t.failed_add_question, AppColors.error);
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

    final t = AppLocalizations.of(context)!;
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
              Text(
                t.still_have_questions,
                style:const TextStyle(
                  fontSize: 16,
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
    final t = AppLocalizations.of(context)!;
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
         Text(
          t.success_add_question,
          style:const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
         Text(
          t.question_reply_time,
          style:const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionForm() {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(t.question_form_info,
          style:const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 24),
         Text(
          t.your_question_label,
          style:const TextStyle(
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
            hintText: t.question_hint,
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
                ?  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                     const  SizedBox(width: 8),
                      Text(t.sending_question),
                    ],
                  )
                :  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send, size: 16),
                      const SizedBox(width: 8),
                      Text(t.send_question),
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
    final t = AppLocalizations.of(context)!;
    final tips = [
      {
        'icon': Icons.inventory_2,
        'color': Colors.blue,
        'title': t.tip_1_title,
        'description':t.tip_1_description ,
        },
      {
        'icon': Icons.security,
        'color': Colors.green,
        'title': t.tip_2_title,
        'description':t.tip_2_description,      },
      {
        'icon': Icons.attach_money,
        'color': Colors.orange,
        'title': t.tip_3_title,
        'description':t.tip_3_description      },
      {
        'icon': Icons.group,
        'color': Colors.purple,
        'title': t.tip_4_title,
        'description': t.tip_4_description      },
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
             Text(
              t.helpful_tips,
              style:const TextStyle(
                fontSize: 16,
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

