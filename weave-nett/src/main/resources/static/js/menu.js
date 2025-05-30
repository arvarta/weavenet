document.addEventListener("DOMContentLoaded", function () {
  // 전체 게시판 토글
  const allToggleBtn = document.querySelector('[data-role="toggle-all"]');
  const allMenu = document.querySelector('[data-role="all-menu"]');
  const adminMenu = document.querySelector('[data-role="admin-menu"]');

  if(allToggleBtn && allMenu) {	
	  allToggleBtn.addEventListener("click", function () {
	    const isActive = allMenu.classList.contains("active");
	
	    allMenu.classList.toggle("active", !isActive);
	    if (adminMenu) adminMenu.classList.toggle("active", !isActive);
	
	    this.classList.toggle("folded", isActive);
	  });
  }

  // 부서/프로젝트 토글
  document.querySelectorAll('[data-role="group-toggle"]').forEach(button => {
    const groupTree = button.closest(".groups").querySelector(".lnb_tree");
    button.addEventListener("click", function () {
      const isActive = groupTree.classList.contains("active");
      groupTree.classList.toggle("active", !isActive);
      button.classList.toggle("active", !isActive);

      button.classList.toggle("folded", isActive);
    });
  });

  // 메뉴 선택 시
  const menuLinks = document.querySelectorAll('.menu_item .item_txt');

  menuLinks.forEach(function (link) {
      link.addEventListener('click', function (e) {
          // 기본 링크 동작 방지 (필요 시 주석 해제)
          // e.preventDefault();

          // 모든 menu_item에서 selected 제거
          document.querySelectorAll('.menu_item').forEach(function (item) {
              item.classList.remove('selected');
          });

          // 현재 클릭한 a 태그의 부모(menu_item)에 selected 추가
          this.closest('.menu_item').classList.add('selected');
      });
  });
  
});