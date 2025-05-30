document.addEventListener('DOMContentLoaded', () => {
	/* header ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ */
	
	// 검색 ------------------------------------------------------------
    const searchInput = document.querySelector('#header_search_id');
    const searchLayer = document.querySelector('.ly_simple_search');
    const keywordElements = document.querySelectorAll('.condition_list .keyword');

    // 검색 입력
    searchInput.addEventListener('input', function () {
    	const query = this.value.trim();

    	if (query) {
			// 입력값이 있을 경우 검색 레이어 보여주기
			searchLayer.style.display = 'block';

			// 모든 keyword 요소에 텍스트 삽입
			keywordElements.forEach(function (el) {
				el.textContent = query;
        	});
      	} else {
			// 입력값 없으면 레이어 숨기기
			searchLayer.style.display = 'none';
    	}
    });

	// 프로필 이미지 ------------------------------------------------------------
	const profileImage = document.querySelector('#profileImg');
	const gnbUserMenu = document.querySelector('.gnb_user');

	if (!profileImage || !gnbUserMenu) {
		console.warn('#profileImg 또는 .gnb_user 요소를 찾을 수 없습니다');
	} else {
		profileImage.addEventListener('click', function (event) {
			event.stopPropagation();
			console.log('프로필 클릭됨');
			gnbUserMenu.classList.toggle('active');
		});

		document.addEventListener('click', function (e) {
			if (!gnbUserMenu.contains(e.target) && e.target !== profileImage) {
				gnbUserMenu.classList.remove('active');
			}
		});
	}

});