```php
<?php

// 安装 GuzzleHttp 客户端，如果尚未安装，请使用以下命令安装：
// composer require guzzlehttp/guzzle
require 'vendor/autoload.php';

use GuzzleHttp\Client;

function translateText($text, $targetLanguage)
{
    // 替换为您的实际OpenAI API密钥
    $apiKey = 'YOUR_API_KEY';

    // 创建一个新的 GuzzleHttp 客户端
    $client = new Client([
        'base_uri' => 'https://api.openai.com',
        'headers' => [
            'Authorization' => "Bearer {$apiKey}",
            'Content-Type' => 'application/json'
        ]
    ]);

    // 设置请求的数据
    $requestData = [
        'model' => 'text-davinci-002', // 您可以使用其他模型，如 text-curie-002 等
        'prompt' => "Translate the following English text to {$targetLanguage}: '{$text}'",
        'temperature' => 0.5,
        'max_tokens' => 100,
        'top_p' => 1,
        'frequency_penalty' => 0,
        'presence_penalty' => 0
    ];

    // 发送请求
    $response = $client->post('/v1/engines/davinci-codex/completions', [
        'json' => $requestData
    ]);

    // 解析响应
    $responseData = json_decode($response->getBody(), true);

    // 获取翻译结果
    $translatedText = $responseData['choices'][0]['text'];

    // 返回翻译结果
    return trim($translatedText);
}

// 示例文本
$text = "Translate this text with variable {variable}.";

// 目标语言
$targetLanguage = "Korean";

// 调用翻译函数
$translatedText = translateText($text, $targetLanguage);

// 输出翻译结果
echo "Translated text: {$translatedText}\n";
```


用 ChatGPT 写报告
1. 写报告：我现在正在[报告的情境与目的]。报告主题是 [XX],请提供 [数字] 种开头方式，要简单到 [目标人群] 能听懂，同时要足够能吸引人，让他们愿意专心听下去。
2. 研究报告：写出一篇有关[行业]的[数字]字研究报告，报告中需引述最新的研究，并引用专家观点。
3. 报告总结：你是[某个主题]的专家，请总结以下内容，并针对以下内容提出未来能进一步研究的方向[附上内容]。
4. 搜集资料：给我[数字]篇，有关[领域]的文章
5. 内容总结：用分条的方式总结出这篇文章的[数字]个重点：[附上文章内容/网址]。


用 ChatGPT 准备面试

1. 修改简历：改写以下简历，为每一点加上量化的数据，改写时请维持列点的形式。[附上简历]。
2. 针对性修改简历：我要申请[公司]的职位]，改写以下简历，让我能更符合它的企业文化。[附上经历]。
3. STAR原则回答问题：我在准备[问题]这个面试题，请用STAR原则帮我回答这个题。针对这个问题，我有的经历如下[附上简历]。
4. 模拟面试：你现在是职位]面试官，而我是应征[职位]的面试者。你需要遵守以下规则：
    1. 你只能问我有关[职位]的面试问题。
    2. 不需要写解释。
    3. 你需要向面试官一样等我回答问题，再提问下一个问题。

我的第一句话是，你好。


用 ChatGPT 写代码

1. 写代码：你现在是[程序语言]专家，请帮我用[程序语言]写一个函式，它需要做到[某个功
能。
2. 解释代码：你现在是一个[程序语言]专家，请告诉我以下的程序在做什么。[附上程序]。
3. 重构代码：你现在是一个Clean Code专家，我有以下的程序，请用更干净简洁的方式改写让我的同事们可以更容易维护程序。另外，也解释为什么你要这样重构，让我能把重构的方式的说明加到Pull Request当中。[附上程序]。
4. 写正则：你现在是一个Regex专家，请帮我写一个Regex,它能够把[需求]

用 ChatGPT 写测试用例

1. 写测试用例：你现在是一个[程序语言]专家我有一段程序[附上程序]，请帮我写一个测试，请至少提供五个测试案例，同时要包含到极端的状况，让我能够确定这段程序的输出是正确的。
2. 解BUG:你现在是一个[程序语言]专家，我有段程序，我预期这段程序可以[做到某个功能]，只是它通过不了[测试案例列]这个测试案例。请帮我找出我哪里写错了，以及用正确的方式改写。[附上程序]


用 ChatGPT 学英语

1. 背单词辅助：用[中文/英文]解释以下英文单字：[填入一个或多个单字]。请用表格的方式呈现，并且表格内须包含单字、词性、解释与例句。
2. 模拟英语对话：Can we have a conversation about[话题]？
3. 英文语法修复：Can you check the spelling and grammar in the following text?[附上英文文字]


用 ChatGPT 替你工作

1. 回复邮件：你是一名职业]，我会给你一封电子邮件，你要回覆这封电子邮件。电子邮件：[附上内容]
2. 产品文案：将以下产品关键字生成[数字]句的产品文案。产品关键字：[附上关键字]
3. 活动清单：你扮演一位专业的活动企刻，请生成[活动]活动计划清单，包括重要任务和截止日期。
4. 提供创意点子：提供[数字]个[想法]的点子
5. 起标题：写出[数字]个有关[主题]的[社群平台]风格标题，要遵守以下规则：[规则1]、[规则2]、[其他规则]。
6. 写大纲：提供[某主题]主题的文章大纲

用 ChatGPT 搞创作

1. 写歌词：大家都说我写的歌词像[人名]，但我最近有点没灵感，请帮我用[人名]的风格写一首歌。歌中包含的元素要[关键字]。
2. 写故事：写出一篇有关[故事想法]，拥有[风格]风格的短篇故事
3. 写rap:你是现在最红的饶舌歌手，请创作一首 Rap,主题是[附上主题]。
4. 写文章：针对[主题]这个主题生成一篇文章
5. 生成食谱：提供给我一个食谱，食材包含[食材1]、[食材2]、[食材]。