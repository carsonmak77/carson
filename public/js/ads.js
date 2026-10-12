/**
 * 广告位加载与渲染
 * 功能：
 *   1. 自动扫描页面上所有 .ad-slot 元素，根据 data-position 请求广告并渲染
 *   2. 同位置多广告自动轮播（间隔可配置）
 *   3. 悬浮浮漂广告：fixed 定位，带关闭按钮
 */
(function () {
  'use strict';

  var AD_CACHE = null;
  var AD_CACHE_TIME = 0;
  var ROTATION_TIMERS = [];

  /**
   * 获取广告数据（带缓存，5分钟有效）
   */
  function getAds() {
    var now = Date.now();
    if (AD_CACHE && (now - AD_CACHE_TIME) < 5 * 60 * 1000) {
      return Promise.resolve(AD_CACHE);
    }
    return fetch('/api/ads')
      .then(function (r) { return r.ok ? r.json() : []; })
      .then(function (data) {
        AD_CACHE = data || [];
        AD_CACHE_TIME = now;
        return AD_CACHE;
      })
      .catch(function () { return []; });
  }

  /**
   * 获取页面名称
   */
  function getPageName() {
    var path = window.location.pathname;
    if (path.endsWith('index.html') || path === '/' || path === '') return 'home';
    if (path.endsWith('friends.html')) return 'friends';
    if (path.endsWith('about.html')) return 'about';
    if (path.endsWith('post.html')) return 'post';
    return 'other';
  }

  function escapeHtml(str) {
    if (!str) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  /**
   * 匹配指定位置的所有广告（支持叠加多条）
   */
  function getMatchingAds(ads, position, pageName) {
    var matched = [];
    for (var i = 0; i < ads.length; i++) {
      var ad = ads[i];
      if (!ad.active) continue;
      // 精确匹配位置、通配符 all、或页面级通配
      if (ad.position === position || ad.position === 'all' || ad.position === pageName + '_all') {
        matched.push(ad);
      }
    }
    return matched;
  }

  /**
   * 渲染单条广告到 slot
   */
  function renderAd(slot, ad) {
    if (!ad || !ad.content && !ad.imageUrl) {
      slot.style.display = 'none';
      slot.innerHTML = '';
      return;
    }

    slot.style.display = 'flex';

    var inner = '<div class="ad-slot-inner">';
    if (ad.link) {
      inner += '<a href="' + escapeHtml(ad.link) + '" target="_blank" rel="noopener noreferrer nofollow">';
    }
    if (ad.type === 'image' && ad.imageUrl) {
      inner += '<img src="' + escapeHtml(ad.imageUrl) + '" alt="' + escapeHtml(ad.title || '广告') + '">';
    } else if (ad.type === 'html') {
      inner += ad.content;
    } else {
      inner += '<div class="ad-slot-text">' + escapeHtml(ad.content) + '</div>';
    }
    if (ad.link) {
      inner += '</a>';
    }
    if (ad.title && ad.type !== 'html') {
      inner += '<div class="ad-slot-text">' + escapeHtml(ad.title) + '</div>';
    }
    inner += '</div>';
    inner += '<span class="ad-slot-label">广告</span>';

    slot.innerHTML = inner;
  }

  /**
   * 启动广告轮播
   */
  function startAdRotation(slot, ads) {
    if (!ads.length) {
      slot.style.display = 'none';
      return;
    }

    var currentIndex = 0;
    var intervalSec = ads[0].interval || 6;
    // 取所有广告中最小的间隔作为轮播间隔
    for (var i = 1; i < ads.length; i++) {
      var v = ads[i].interval || 6;
      if (v < intervalSec) intervalSec = v;
    }
    var intervalMs = intervalSec * 1000;

    // 渲染第一条
    renderAd(slot, ads[0]);

    // 只有一条广告时不需要轮播
    if (ads.length <= 1) return;

    var timer = setInterval(function () {
      currentIndex = (currentIndex + 1) % ads.length;
      // 淡出 → 切换 → 淡入
      slot.style.opacity = '0';
      setTimeout(function () {
        renderAd(slot, ads[currentIndex]);
        slot.style.opacity = '1';
      }, 350);
    }, intervalMs);

    ROTATION_TIMERS.push(timer);
  }

  /**
   * 创建悬浮浮漂广告
   */
  function createFloatingAd(ads) {
    if (!ads.length) return;

    // 用户已关闭则不再显示
    var dismissed = sessionStorage.getItem('ad_floating_closed');
    if (dismissed === '1') return;

    // 避免重复创建
    if (document.getElementById('adFloating')) return;

    var container = document.createElement('div');
    container.className = 'ad-floating';
    container.id = 'adFloating';
    container.setAttribute('data-side', ads[0].floatingSide || 'right');

    // 关闭按钮
    var closeBtn = document.createElement('button');
    closeBtn.className = 'ad-floating-close';
    closeBtn.innerHTML = '&times;';
    closeBtn.title = '关闭广告';
    closeBtn.onclick = function () {
      container.style.opacity = '0';
      setTimeout(function () {
        container.remove();
      }, 300);
      sessionStorage.setItem('ad_floating_closed', '1');
    };
    container.appendChild(closeBtn);

    // 广告内容容器
    var content = document.createElement('div');
    content.className = 'ad-floating-content';
    container.appendChild(content);

    document.body.appendChild(container);

    // 轮播逻辑
    var currentIndex = 0;
    var intervalSec = ads[0].interval || 6;
    for (var i = 1; i < ads.length; i++) {
      var v = ads[i].interval || 6;
      if (v < intervalSec) intervalSec = v;
    }
    var intervalMs = intervalSec * 1000;

    function renderFloating(ad) {
      var html = '';
      if (ad.link) {
        html += '<a href="' + escapeHtml(ad.link) + '" target="_blank" rel="noopener noreferrer nofollow">';
      }
      if (ad.type === 'image' && ad.imageUrl) {
        html += '<img src="' + escapeHtml(ad.imageUrl) + '" alt="' + escapeHtml(ad.title || '广告') + '">';
      } else if (ad.type === 'html') {
        html += ad.content;
      } else {
        html += '<div class="ad-floating-text">' + escapeHtml(ad.content || ad.title || '') + '</div>';
      }
      if (ad.link) {
        html += '</a>';
      }
      content.innerHTML = html;
    }

    renderFloating(ads[0]);

    if (ads.length > 1) {
      var timer = setInterval(function () {
        currentIndex = (currentIndex + 1) % ads.length;
        content.style.opacity = '0';
        setTimeout(function () {
          renderFloating(ads[currentIndex]);
          content.style.opacity = '1';
        }, 300);
      }, intervalMs);
      ROTATION_TIMERS.push(timer);
    }

    // 入场动画
    requestAnimationFrame(function () {
      container.classList.add('ad-floating-show');
    });
  }

  /**
   * 初始化所有广告位
   */
  function initAds() {
    // 清理旧的定时器
    ROTATION_TIMERS.forEach(function (t) { clearInterval(t); });
    ROTATION_TIMERS = [];

    var slots = document.querySelectorAll('.ad-slot[data-position]');
    var pageName = getPageName();

    getAds().then(function (ads) {
      // 渲染固定广告位
      slots.forEach(function (slot) {
        var position = slot.getAttribute('data-position');
        var matched = getMatchingAds(ads, position, pageName);
        if (matched.length > 0) {
          startAdRotation(slot, matched);
        } else {
          slot.style.display = 'none';
        }
      });

      // 渲染悬浮浮漂广告
      var floatingAds = getMatchingAds(ads, 'floating', pageName);
      if (floatingAds.length > 0) {
        createFloatingAd(floatingAds);
      }
    });
  }

  // DOM 加载完成后初始化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAds);
  } else {
    initAds();
  }

  // 暴露给外部调用
  window.AdSlots = {
    init: initAds,
    render: renderAd
  };
})();
