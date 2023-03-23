const dwellChat = {
  _autoload: ['init'],
  config: {
    isActive: true,
    timer: 0,
    openChatTimer: ACC.config.dwellChatOpenTimer * 1000,
    closeChatTimer: ACC.config.dwellChatCloseTimer * 1000,
    clickTimer: 0,
    removalTimer: false,
    webChatUrl: 'https://webchat.mitel.io/bootstrapper.js?',
    minIdleAgents: ACC.config.dwellChatMinimumIdleAgents,
    brakesId: 'accountid%3DMGNjOGQxMmUtM2EzOS00OWEzLTg1ZWMtY2I4YzgzMDY4NmNj%26chatname%3DRHdlbGwgQ2hhdCAtIEJyYWtlcyAoV0lOQV9Ed2VsbEFwcCk%3D',
    ccId: 'accountid%3DMGNjOGQxMmUtM2EzOS00OWEzLTg1ZWMtY2I4YzgzMDY4NmNj%26chatname%3DRHdlbGwgQ2hhdCAtIENvdW50cnkgQ2hvaWNlIChXQ0NBX0R3ZWxsQXBwKQ%3D%3D'
  },
  init: function () {
    var pageClassNames = ['register', 'checkCustomerEligilityPage'];
    var containsClass = pageClassNames.some(function (className) {
      return document.body.classList.contains('page-' + className);
    });

    containsClass && this.userInteraction(this.resetTimer.bind(this, this.getIdleAgents));
  },
  userInteraction: function (timer) {
    window.onmousedown = timer;
    window.onclick = timer;
    window.onscroll = timer;
    window.onkeypress = timer;
    window.onblur = timer;
  },
  resetTimer: function (funct) {
    clearTimeout(this.config.timer);
    this.config.timer = setTimeout(funct, this.config.openChatTimer);
  },
  loadDwellScript: function (dwellId) {
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = this.config.webChatUrl + dwellId;
    document.head.appendChild(script);
  },
  getIdleAgents: function () {
    if (ACC.dwellChat.config.isActive) {
      $.ajax({
        url: '/dwell-chat/queue/status',
        type: 'GET',
        dataType: 'json',
        success: function (response) {
          ACC.dwellChat.successRequest(response);
        },
        error: function () {
          console.log('Error getting response for Dwell Chat');
        }
      });
    }
  },
  successRequest: function (response) {
    console.log(response);
    if (response && response.agentsIdle >= this.config.minIdleAgents) {
      var clickToChatButton = document.getElementById('cloudlink-chat-overlay-buttons');
      clickToChatButton && document.body.removeChild(clickToChatButton.parentElement);

      this.openChat();
      this.config.isActive = false;
    }
  },
  openChat: function () {
    var body = document.body;
    var getBodyClassList = body.classList;
    var isBrakes = getBodyClassList.contains('site-brakes');
    var dwellId = this.config.brakesId;
    var chatObserver = new MutationObserver(function (mutations) {
      ACC.dwellChat.mutatedElements(mutations, chatObserver);
    });

    // If not Brakes then use country choice (cc)
    if (!isBrakes) dwellId = this.config.ccId;

    // Inject Dwell Script
    ACC.dwellChat.loadDwellScript(dwellId);

    chatObserver.observe(body, { childList: true, subtree: true });
  },
  mutatedElements: function (mutations, observer) {
    return mutations.forEach(function (mutation) {
      for (var i = 0; i < mutation.addedNodes.length; i++) {
        var addedNode = mutation.addedNodes[i];
        if (addedNode.id === 'iframemaindiv') {
          observer.disconnect();

          var chatButton = addedNode.querySelector('#cloudlink-chat-overlay-contact-us-button');
          chatButton && chatButton.click();

          // Start Click Timer
          ACC.dwellChat.clickTimer = setInterval(ACC.dwellChat.removeInActiveChat, ACC.dwellChat.config.closeChatTimer);
          // Add user interactions
          ACC.dwellChat.userInteraction(ACC.dwellChat.interaction);
        }
      }
    });
  },
  interaction: function () {
    ACC.dwellChat.config.removalTimer = true;

    if (document.activeElement.id === 'cloudlink-chat-overlay-iframe') {
      // Stop clickTimer
      clearInterval(ACC.dwellChat.clickTimer);
    } else {
      // Reset clickTimer
      clearInterval(ACC.dwellChat.clickTimer);
      ACC.dwellChat.clickTimer = setInterval(ACC.dwellChat.removeInActiveChat, ACC.dwellChat.config.closeChatTimer);
    }
  },
  removeInActiveChat: function () {
    var dwellChatPopup = document.getElementById('cloudlink-chat-overlay-buttons');
    if (dwellChatPopup) {
      if (ACC.dwellChat.config.removalTimer) {
        var closeButton = dwellChatPopup.querySelector('#cloudlink-chat-overlay-close-button');
        // Close button displayed & visible means chatbox opened
        if (closeButton && closeButton.offsetParent) {
          // Trigger user click to close Chat Popup
          closeButton.click();
        } else {
          // Remove Chat Popup and interactions
          clearInterval(ACC.dwellChat.clickTimer);
          document.body.removeChild(dwellChatPopup.parentElement);
          ACC.dwellChat.userInteraction(null);
        }
      } else {
        ACC.dwellChat.config.removalTimer = true;
      }
    }
  }
};

export default dwellChat;
