// boardModal.js
document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById('boardSelectModal');
    const openModalBtn = document.getElementById('boardSelectBtn');
    const closeBtn = modal.querySelector('.close');
    const confirmButtonWrapper = document.getElementById('confirmButtonWrapper');

    openModalBtn.addEventListener('click', () => {
        modal.classList.add('show');
    });

    closeBtn.addEventListener('click', () => {
        modal.classList.remove('show');
    });

    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.classList.remove('show');
        }
    });

    // 라디오 버튼 선택 시 확인 버튼 활성화
    document.querySelectorAll('input[name="boardRadio"]').forEach((radio) => {
        radio.addEventListener('change', () => {
            confirmButtonWrapper.innerHTML = `
                <span class="btnBc solid small" id="confirmButtonSpan">
                    <button type="button" id="confirmBoardBtn">확인</button>
                </span>
            `;
            document.getElementById('confirmBoardBtn').addEventListener('click', handleConfirmClick);
        });
    });

    function handleConfirmClick() {
        const selectedRadio = document.querySelector('input[name="boardRadio"]:checked');
        if (!selectedRadio) {
            alert('게시판을 선택해 주세요.');
            return;
        }

        const title = document.getElementById('titleInput')?.value.trim() || '';
        const content = $('#summernote').summernote('code');

        sessionStorage.setItem('postTitle', title);
        sessionStorage.setItem('postContent', content);

        const selectedBNum = selectedRadio.getAttribute('data-bnum');
        modal.classList.remove('show');
		
		let baseUrl = isAdminPage ? '/api/admin/posts/postWrite' : '/api/posts/postWrite';

        if (!selectedBNum) {
            location.href = baseUrl;
        } else {
            location.href = `${baseUrl}?bNum=${selectedBNum}`;
        }
    }
});
