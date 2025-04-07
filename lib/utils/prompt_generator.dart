String buildHomeworkAnalysisPrompt({
  required String subject,
  required String language,
}) {
  final jsonSchemaExample = getSubjectJsonSchema(subject);

  if (language.toLowerCase() == 'chinese') {
    final subjectInChinese = _getChineseSubjectName(subject);
    return '''
你是一位 AI 家教，正在批改学生上传的$subjectInChinese作业照片。作业内容是中文的，你也应该用中文回复。

请按照以下步骤进行操作：

1. 识别图像中的每一道$subjectInChinese题目，逐题提取内容。

2. 对每一道题，返回一个结构化的 JSON 对象，格式如下：

```json
{
  "questions": [
    $jsonSchemaExample
  ]
}
```

额外要求说明：

- **只返回 JSON 对象，不要输出除 JSON 之外的任何文字或解释**。
- 如果某些字段信息缺失或该题无关，请保持字段为空字符串或空数组。
- 如果学生回答错误，请在 `"feedback"` 字段中简洁地说明错误原因，并给予正确的讲解或建议。
- 若题目为选择题或填空题等没有明显计算步骤的类型，`"steps"` 等字段可以为空数组。
- 请使用 OCR 与计算机视觉识别技术，理解图片内容，包括手写或打印的学生答案。
- 请妥善格式化JSON对象，不要出现任何编码错误。''';
  }

  // For non-Chinese languages, return the original English prompt
  return '''
You are an AI tutor reviewing a student's $subject worksheet from a photo. The content is written in $language, and you should respond in $language.

Please:

1. Identify and extract each individual $subject question shown in the image.

2. For each question, return a structured JSON object using the format below:

```json
{
  "questions": [
    $jsonSchemaExample
  ]
}
```

Additional guidelines:

Only return a JSON object. Do not include any explanation, commentary, or text outside the JSON. The response must be valid JSON.

Leave fields blank if data is missing or irrelevant for the question type.

If a student made a mistake, the "feedback" should explain what went wrong and how to correct it.

If the question has no visible steps (e.g. multiple choice or fill-in-the-blank), the "steps" array or similar may be empty.

Use OCR and computer vision techniques to understand the layout and student handwriting or typed responses.

Use $language for all field values and feedback messages.''';
}

String _getChineseSubjectName(String subject) {
  switch (subject.toLowerCase()) {
    case 'math':
      return '数学';
    case 'english':
      return '英语';
    case 'chinese literature':
      return '语文';
    default:
      return subject;
  }
}

String getSubjectJsonSchema(String subject) {
  switch (subject.toLowerCase()) {
    case 'math':
      return '''
{
  "question_number": "It could be 一, (2), 1, A, i, and etc.",
  "expression": "The question expression",
  "student_answer": "19/24",
  "steps": ["6/24 + 4/24 + 9/24", "19/24"],
  "correct": true,
  "feedback": "做得好！你正确地加了这些分数。"
}''';

    case 'english':
      return '''
{
  "question_number": "(1)",
  "question_text": "What is the main idea of the passage?",
  "student_answer": "The story is about friendship.",
  "grammar_errors": ["subject-verb agreement"],
  "spelling_errors": ["freindship"],
  "comprehension_score": 4,
  "feedback": "Good comprehension! Watch out for grammar and spelling mistakes."
}''';

    case 'chinese literature':
    case '语文':
      return '''
{
  "question_number": "一,(2),1,A,i",
  "question_text": "根据文章内容，说说作者对故乡的感情。",
  "student_answer": "做着很想念自己的故香。",
  "typos": ["做着 -> 作者", "故香 -> 故乡"],
  "expression_issues": ["句式不够完整"],
  "logic_issues": [],
  "comprehension_score": 3,
  "feedback": "回答基本正确，但表达不够完整。存在错别字，如"做着"应为"作者"，"故香"应为"故乡"。可以进一步说明作者为什么想念故乡，比如引用文章中的句子。"
}''';

    default:
      return '''
{
  "question_number": "一,(2),1,A,i",
  "question_text": "...",
  "student_answer": "...",
  "feedback": "..."
}''';
  }
}
