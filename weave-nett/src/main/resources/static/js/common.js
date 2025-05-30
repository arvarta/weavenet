document.addEventListener('DOMContentLoaded', () => {
	/* component ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ */

	// 인풋 ------------------------------------------------------------
	const inputs = document.querySelectorAll('.inputBox .inpt');

	inputs.forEach(input => {
		const box = input.closest('.inputBox');
		const delBtn = box.querySelector('.btnDel');

		// 삭제 버튼 없거나 input 비활성화인 경우 무시
		if (!delBtn || input.disabled) return;

		// 초기 상태: 값이 없으면 삭제버튼 숨김
		if (input.value.trim() === '') {
			delBtn.style.display = 'none';
		} else {
			delBtn.style.display = 'inline-block';
		}

		// 입력 중: 삭제버튼 표시
		input.addEventListener('input', () => {
			if (input.value.trim() !== '') {
			delBtn.style.display = 'inline-block';
			} else {
			delBtn.style.display = 'none';
			}
		});

		// 포커스: on 클래스 추가
		input.addEventListener('focus', () => {
			box.classList.add('on');
		});

		// 포커스 아웃: on 제거
		input.addEventListener('blur', () => {
			setTimeout(() => {
			box.classList.remove('on');
			box.classList.add('done');
			if (input.value.trim() === '') {
				delBtn.style.display = 'none';
			}
			}, 100);
		});

		// 삭제 버튼 클릭: 인풋에 포커스
		delBtn.addEventListener('click', (e) => {
			e.preventDefault();
			input.value = '';
			delBtn.style.display = 'none';
			input.focus();
		});
	});

});