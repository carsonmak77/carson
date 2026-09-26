-- CARSON 博客系统 Cloudflare D1 初始化结构
-- 数据以 JSON 文档形式存放在 D1 中，便于从原本的 data/db.json 平滑迁移。

CREATE TABLE IF NOT EXISTS app_data (
  key TEXT PRIMARY KEY,
  data TEXT NOT NULL,
  updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_app_data_updated_at ON app_data(updated_at);

INSERT OR IGNORE INTO app_data (key, data, updated_at)
VALUES (
  'main',
  json_object(
    'posts', json_array(
      json_object(
        'id', '1',
        'title', '欢迎使用CARSON博客系统',
        'summary', '一个简洁优雅的博客系统，灵感来源于微信的经典设计语言。',
        'content', '<p>这是一个采用微信设计风格的博客系统。</p><h2>主要特性</h2><ul><li>简洁清新的界面设计</li><li>完整的后台管理系统</li><li>文章的增删改查</li><li>分类与标签管理</li><li>响应式布局，适配移动端</li></ul><p>微信风格的核心在于「克制」——用最少的视觉元素传达最清晰的信息。绿色主色调 #07C160 带来活力感，大面积留白让内容呼吸。</p><h2>使用方法</h2><p>1. 访问首页查看博客文章列表</p><p>2. 点击文章标题查看详情</p><p>3. 访问 /admin 进入后台管理</p><p>4. 默认管理员账号：admin / admin123</p><p>开始你的博客之旅吧！</p>',
        'cover', '',
        'author', 'Admin',
        'category', '公告',
        'tags', json_array('教程', '公告'),
        'createdAt', '2026-09-24T08:00:00.000Z',
        'updatedAt', '2026-09-24T08:00:00.000Z',
        'views', 128,
        'published', 1,
        'pinned', 0,
        'announcement', 0,
        'showOnHome', 1
      ),
      json_object(
        'id', '2',
        'title', '如何写出高质量的技术博客',
        'summary', '分享技术写作的方法论，从选题到结构到表达，让你的文章更专业。',
        'content', '<p>技术博客是开发者最好的名片。本文分享一些实用的写作技巧。</p><h2>选题策略</h2><p>好的选题是成功的一半。建议从以下角度切入：</p><ul><li>解决过的技术难题</li><li>新技术的实践总结</li><li>项目架构设计复盘</li><li>性能优化案例分析</li></ul><h2>结构设计</h2><p>一篇好的技术文章通常包含：问题背景、方案选型、实现细节、踩坑记录、总结展望。逻辑要清晰，让读者能够跟上你的思路。</p><h2>表达技巧</h2><p>多用图表和代码示例，少用大段文字。关键概念加粗强调，复杂流程配示意图。代码要可运行，附带注释说明。</p><p>坚持写作，量变终会引起质变。</p>',
        'cover', '',
        'author', 'Admin',
        'category', '技术',
        'tags', json_array('写作', '技术'),
        'createdAt', '2026-09-23T08:00:00.000Z',
        'updatedAt', '2026-09-23T08:00:00.000Z',
        'views', 56,
        'published', 1,
        'pinned', 0,
        'announcement', 0,
        'showOnHome', 1
      ),
      json_object(
        'id', '3',
        'title', '2024年前端开发趋势展望',
        'summary', '从框架演进到工具链变革，梳理前端生态的最新发展方向。',
        'content', '<p>前端领域瞬息万变，让我们一起看看当前的发展趋势。</p><h2>框架层面</h2><p>React、Vue、Angular 三足鼎立，但 Svelte 和 Solid 等编译时框架正在崛起。服务端组件（RSC）正在改变前端的开发范式。</p><h2>工具链</h2><p>Vite 已成为新一代构建工具的标准。Turbopack、Rspack 等 Rust/Go 编写的工具在性能上持续突破。</p><h2>AI 辅助开发</h2><p>AI 编程助手已从概念走向日常工具。代码生成、智能补全、自动化测试等场景正在被重新定义。</p><p>保持学习，拥抱变化，是前端开发者永恒的主题。</p>',
        'cover', '',
        'author', 'Admin',
        'category', '技术',
        'tags', json_array('前端', '趋势'),
        'createdAt', '2026-09-22T08:00:00.000Z',
        'updatedAt', '2026-09-22T08:00:00.000Z',
        'views', 89,
        'published', 1,
        'pinned', 0,
        'announcement', 0,
        'showOnHome', 1
      ),
      json_object(
        'id', '4',
        'title', '极简主义设计：少即是多',
        'summary', '探讨极简主义设计在网页与产品中的应用，如何用更少的元素传递更清晰的信息。',
        'content', '<p>极简主义设计并非简单地减少元素，而是通过精心的取舍，让每一个元素都发挥最大的作用。</p><h2>核心理念</h2><p>"少即是多"（Less is More）是极简主义的核心。在设计中，这意味着：</p><ul><li>去除一切不必要的装饰</li><li>让内容成为主角</li><li>用留白创造呼吸感</li><li>用有限的色彩建立秩序</li></ul><h2>实践原则</h2><p>1. 明确目标：每个页面只需完成一个核心任务。2. 层级清晰：通过字号、颜色、间距建立视觉层级。3. 一致的重复：复用相同的组件和样式，减少认知负担。4. 克制的动效：动效只为引导注意力，不为炫技。</p><h2>常见误区</h2><p>极简不等于空白。一个优秀的极简设计，每一个像素都经过深思熟虑。过度留白会让页面显得空洞，而恰到好处的留白则能让内容呼吸。</p><p>极简是一种态度，更是一种能力。</p>',
        'cover', '',
        'author', 'Admin',
        'category', '设计',
        'tags', json_array('设计', '极简', 'UI'),
        'createdAt', '2026-09-21T08:00:00.000Z',
        'updatedAt', '2026-09-21T08:00:00.000Z',
        'views', 73,
        'published', 1,
        'pinned', 0,
        'announcement', 0,
        'showOnHome', 1
      ),
      json_object(
        'id', '5',
        'title', '高效能人士的七个习惯',
        'summary', '重温史蒂芬·柯维的经典著作，将七个习惯融入日常工作与生活。',
        'content', '<p>《高效能人士的七个习惯》是一本经久不衰的自我管理经典。本文回顾这七个习惯，并探讨如何在日常中实践。</p><h2>个人领域的成功</h2><p><b>习惯一：积极主动</b>——对自己的人生负责，关注影响圈而非关注圈。</p><p><b>习惯二：以终为始</b>——先有目标，再行动。任何事物都经过两次创造：先在头脑中，再在现实中。</p><p><b>习惯三：要事第一</b>——把时间花在重要但不紧急的事情上，这是个人成长的关键。</p><h2>公众领域的成功</h2><p><b>习惯四：双赢思维</b>——寻求互利的解决方案，而非零和博弈。</p><p><b>习惯五：知彼解己</b>——先理解别人，再争取别人理解自己。倾听是沟通的基础。</p><p><b>习惯六：统合综效</b>——尊重差异，通过创造性合作实现 1+1>2。</p><h2>持续更新</h2><p><b>习惯七：不断更新</b>——在身体、精神、智力、社会/情感四个维度持续自我更新。</p><p>习惯的养成需要时间，但一旦形成，将受益终身。</p>',
        'cover', '',
        'author', 'Admin',
        'category', '生活',
        'tags', json_array('成长', '习惯', '阅读'),
        'createdAt', '2026-09-20T08:00:00.000Z',
        'updatedAt', '2026-09-20T08:00:00.000Z',
        'views', 95,
        'published', 1,
        'pinned', 0,
        'announcement', 0,
        'showOnHome', 1
      )
    ),
    'categories', json_array('公告', '技术', '设计', '生活', '随笔'),
    'tags', json_array('教程', '公告', '写作', '技术', '前端', '趋势', '设计', '极简', 'UI', '成长', '习惯', '阅读'),
    'friends', json_array(
      json_object('id', 'friend-1', 'name', '天真', 'url', 'https://bin.zmide.com/', 'description', '与君初识，宛如故人', 'avatar', '', 'status', 'approved', 'visible', 1, 'sortOrder', 1, 'createdAt', '2026-09-24T08:00:00.000Z', 'updatedAt', '2026-09-24T08:00:00.000Z'),
      json_object('id', 'friend-2', 'name', 'ligen131', 'url', 'https://ligen.life/', 'description', "Don't worry, be happy.", 'avatar', '', 'status', 'approved', 'visible', 1, 'sortOrder', 2, 'createdAt', '2026-09-24T08:00:00.000Z', 'updatedAt', '2026-09-24T08:00:00.000Z')
    ),
    'users', json_array(),
    'comments', json_array(),
    'likes', json_array(),
    'favorites', json_array(),
    'ads', json_array(),
    'settings', json_object(
      'siteName', 'CARSON',
      'siteSubtitle', '记录生活，分享思考',
      'description', 'CARSON——记录生活，分享思考。',
      'logo', '',
      'footerText', '',
      'navLinks', json_array(
        json_object('name', '主页', 'url', 'index.html', 'visible', 1),
        json_object('name', '文章', 'url', 'articles.html', 'visible', 1),
        json_object('name', '朋友们', 'url', 'friends.html', 'visible', 1),
        json_object('name', '关于', 'url', 'about.html', 'visible', 1)
      ),
      'tempAccessMode', 0,
      'tempAccessNotice', '',
      'maintenanceMode', 0,
      'maintenancePassword', '',
      'maintenanceMessage', '网站维护中，敬请谅解',
      'contact', json_object(
        'email', 'carson@family.com',
        'wechat', 'carson-family',
        'qq', '',
        'phone', '',
        'address', '广东'
      ),
      'sponsor', json_object(
        'description', 'CARSON博客系统由维护者共同运营，如果您觉得本站对您有帮助，欢迎赞助支持，您的支持将用于服务器运营。',
        'wechatQr', '',
        'alipayQr', '',
        'thirdQr', '',
        'code', 'CARSON2026'
      ),
      'about', json_object(
        'kicker', 'About',
        'title', '关于CARSON',
        'summary', 'CARSON博客系统——记录生活，分享思考。',
        'content', '<section class="about-card"><h2>CARSON</h2><p>CARSON博客系统是一处记录生活与分享思考的平台。</p></section><section class="about-card"><h2>联系方式</h2><p>邮箱：carson@family.com</p><p>微信：carson-family</p><p>地址：广东</p></section><section class="about-card"><h2>赞助支持</h2><p>CARSON博客系统由维护者共同运营，欢迎赞助支持，您的支持将用于服务器运营。赞助码：CARSON2026</p></section>'
      ),
      'commentSettings', json_object(
        'blockedKeywords', json_array(),
        'homepagePageSize', 5,
        'postPageSize', 10
      )
    )
  ),
  strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
);
