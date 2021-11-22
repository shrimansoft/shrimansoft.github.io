(function () {
  var burger = document.querySelector('.burger');
  var menu = document.querySelector('#' + burger.dataset.target);
  burger.addEventListener('click', function () {
    burger.classList.toggle('is-active');
    menu.classList.toggle('is-active');
  });
})();

(function () {
  var navbarItem = document.querySelectorAll('.navbar-item');
  var burger = document.querySelector('.burger');
  var menu = document.querySelector('#' + burger.dataset.target);

  for (i = 0; i < navbarItem.length; i++) {
    navbarItem[i].addEventListener('click', function () {
      burger.classList.remove('is-active');
      menu.classList.remove('is-active');
    });
  };
})();
;

//---------------------------* notification *------------------------------------------------------
document.addEventListener('DOMContentLoaded', () => {
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    const $notification = $delete.parentNode;

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });
});

//-------------------------* module *-----------------------------------------------------------

document.addEventListener('DOMContentLoaded', function () {

  // Modals

  var rootEl = document.documentElement;
  var $modals = getAll('.modal');
  var $modalButtons = getAll('.modal-button');
  var $modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button');

  if ($modalButtons.length > 0) {
    $modalButtons.forEach(function ($el) {
      $el.addEventListener('click', function () {
        var target = $el.dataset.target;
        var $target = document.getElementById(target);
        rootEl.classList.add('is-clipped');
        $target.classList.add('is-active');
      });
    });
  }

  if ($modalCloses.length > 0) {
    $modalCloses.forEach(function ($el) {
      $el.addEventListener('click', function () {
        closeModals();
      });
    });
  }

  document.addEventListener('keydown', function (event) {
    var e = event || window.event;
    if (e.keyCode === 27) {
      closeModals();
    }
  });

  function closeModals() {
    rootEl.classList.remove('is-clipped');
    $modals.forEach(function ($el) {
      $el.classList.remove('is-active');
    });
  }

  // Functions

  function getAll(selector) {
    return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
  }

});
//-----------------------------------* on scroling navigation bar *----------------------------
var prevScrollpos = window.pageYOffset;
var navSize = 0;
var navHight = document.getElementById("navbar").offsetHeight;

window.onscroll = function () {
  var currentScrollPos = window.pageYOffset;

  if (prevScrollpos > currentScrollPos && navSize < 0) {
    console.log("up");
      navSize = prevScrollpos - currentScrollPos + navSize;
  }
  if (prevScrollpos < currentScrollPos && navSize > -(navHight+2)) {
    console.log("down");
    navSize = prevScrollpos - currentScrollPos + navSize;
  }
  prevScrollpos = currentScrollPos;
  if (navSize > 0) {
    navSize = 0;
  }
  if (navSize < -(navHight+2)) {
    navSize = -(navHight+2);
  }
  
  console.log(navSize);
  console.log(navHight)
  document.getElementById("navbar").style.top = navSize.toString() + "px";
}