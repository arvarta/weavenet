document.addEventListener('DOMContentLoaded', () => {
	/* header ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ */
	
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