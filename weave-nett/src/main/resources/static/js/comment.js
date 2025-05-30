document.addEventListener('DOMContentLoaded', () => {

    const form = document.getElementById("commentForm");
    const commentList = document.getElementById("cmt_content_wrap");
    const pNum = document.querySelector("input[name='pNum']").value;
	//console.log("게시글 번호:", pNum);
		
    /* ======================== 댓글 등록 ======================== */
    form.addEventListener("submit", function (e) {
        e.preventDefault();
        const formData = new FormData(form);
        const jsonData = Object.fromEntries(formData.entries());

        fetch(`/api/posts/${jsonData.pNum}/comments`, {
            method: "POST",
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(jsonData)
        })
        .then(res => {
			console.log("data: " + res);
            if (!res.ok) throw new Error("댓글 저장 실패");
            return res.json();
        })
        .then(() => {
            loadComments(jsonData.pNum);
            document.getElementById("cContent").value = "";
        })
        .catch(err => {
            alert("댓글 등록 중 오류가 발생했습니다.");
            console.error(err);
        });
    });

    /* =================== 댓글 목록 불러오기 =================== */
    function loadComments(pNum) {
        fetch(`/api/posts/${pNum}/comments`)
            .then(res => res.json())
            .then(updateCommentList)
            .catch(err => console.error('댓글 불러오기 실패:', err));
    }

    /* =================== 댓글 목록 렌더링  =================== */
	function updateCommentList(comments) {
	    commentList.innerHTML = '';

	    if (comments.length === 0) {
	        const ul = document.createElement('ul');
	        ul.className = "cmt_list";

	        const noDataLi = document.createElement('li');
	        noDataLi.className = "nodata img";
	        noDataLi.innerHTML = `
	            <p class="cmt_no">
	                <b>아직 등록된 댓글이 없습니다.</b>
	                해당 게시글에 댓글을 남겨보세요.
	            </p>
	        `;
	        ul.appendChild(noDataLi);
	        commentList.appendChild(ul);
	        return;
	    }

	    // 댓글과 답글 분리
	    const rootComments = comments.filter(c => c.parentId == null); // 댓글
	    const replyMap = {}; // 답글 그룹핑용
		
		// 답글 등록순 정렬
	    comments
	        .filter(c => c.parentId)
	        .sort((a, b) => new Date(a.cRegDate) - new Date(b.cRegDate))
	        .forEach(reply => {
	            if (!replyMap[reply.parentId]) replyMap[reply.parentId] = [];
	            replyMap[reply.parentId].push(reply);
	        });

	    const ul = document.createElement('ul');
	    ul.className = "cmt_list";

	    rootComments.forEach(comment => {
	        // 댓글 렌더링
	        const commentLi = renderComment(comment);
	        ul.appendChild(commentLi);

	        // 답글 있으면 바로 뒤에 붙이기
	        const replies = replyMap[comment.cNum] || [];
	        replies.forEach(reply => {
	            const replyLi = renderReply(reply);
	            ul.appendChild(replyLi);
	        });
	    });

	    commentList.appendChild(ul);
	    bindCommentEvents();
		updateMoreButtonVisibility(); // 더보기 버튼 보이기 제어
	}
	
	function updateMoreButtonVisibility() {
	    document.querySelectorAll('.cmt_set').forEach(li => {
	        const writerId = li.dataset.writerId;
	        const isAuthor = writerId == loginUserId;
	        const isAdmin = ['SUPER_ADMIN', 'BOARD_MANAGER', 'EMPLOYEE_MANAGER'].includes(loginUserAuth);

	        const moreBtn = li.querySelector('.btn_more');
	        if (moreBtn) {
	            if (!(isAuthor || isAdmin)) {
	                moreBtn.style.display = 'none';  // 권한 없으면 숨김
	            }
	        }
	    });
	}

    /* ========== 일반 댓글 렌더링 ========== */
	function renderComment(comment) {
	    const li = document.createElement('li');
	    li.className = "cmt_set";
	    li.dataset.commentId = comment.cNum;
	    li.dataset.writerId = comment.writerId;

	    const profileImgSrc = comment.writerProfile ? contextPath + comment.writerProfile : contextPath + "/img/profile_default.png";

	    li.innerHTML = `
	        <div class="photo">
	            <div class="thumb">
	                <span class="initial_profile">
	                    <img class="img_thumb" alt="프로필" src="${profileImgSrc}">
	                </span>
	            </div>
	        </div>
	        <div class="cmt_box">
	            <div class="user">
	                <div href="#"><strong class="name">${comment.writerName}</strong></div>
	                <span class="date">
	                    ${new Date(comment.cRegDate).toLocaleString("sv-SE", { hour12: false }).replace("T", " ").slice(0, 16)}
	                </span>
	                <div class="cmt_task">
	                    <button type="button" class="btn_more"><span class="blind">메뉴 더보기</span></button>
	                    <div class="ly_context">
	                        <ul></ul>
	                    </div>
	                </div>
	            </div>
	            <p class="cmt_area"><span>${comment.cContent}</span></p>
	            <div class="cmt_reply_area">
	                <span class="btnBc outline small btn_reply">
	                    <input type="button" value="답글">
	                </span>  
	            </div>
	        </div>
	    `;

	    return li;
	}


    /* ========== 답글 렌더링 ========== */
    function renderReply(reply) {
        const li = document.createElement('li');
        li.className = "cmt_set reply";
		li.dataset.commentId = reply.cNum;
		li.dataset.writerId = reply.writerId;
        li.dataset.parentId = reply.parentId;
		
		const profileImgSrc = reply.writerProfile ? contextPath + reply.writerProfile : contextPath + "/img/profile_default.png";

        li.innerHTML = `
            <div class="photo">
                <div class="thumb">
					<span class="initial_profile">
	                    <img class="img_thumb" alt="프로필" src="${profileImgSrc}">
	                </span>
                </div>
            </div>
            <div class="cmt_box">
                <div class="user">
                    <div><strong class="name">${reply.writerName}</strong></div>
                    <span class="date">${new Date(reply.cRegDate).toLocaleString("sv-SE", { hour12: false }).replace("T", " ").substring(0, 16)}</span>
                    <div class="cmt_task">
                        <button type="button" class="btn_more"><span class="blind">메뉴 더보기</span></button>
                        <div class="ly_context">
                            <ul>
                                
                            </ul>
                        </div>
                    </div>
                </div>
                <p class="cmt_area"><span>${reply.cContent}</span></p>
                
            </div>
        `;

        return li;
    }
	
    /* =================== 댓글 정렬 (최신순/등록순) =================== */
    const sortSelect = document.getElementById('sortOption');
    if (sortSelect) {
        sortSelect.addEventListener('change', function () {
            const sortValue = sortSelect.value;
            fetch(`/api/posts/${pNum}/comments?sort=${sortValue}`)
                .then(res => res.json())
                .then(updateCommentList)
                .catch(error => console.error('정렬 오류:', error));
        });
    }

    document.querySelectorAll('input[name="sortOption"]').forEach(radio => {
        radio.addEventListener('change', function () {
            if (this.checked) {
                const sortValue = this.value;
                fetch(`/api/posts/${pNum}/comments?sort=${sortValue}`)
                    .then(res => res.json())
                    .then(updateCommentList)
                    .catch(error => console.error('정렬 오류:', error));
            }
        });
    });

    /* =================== 댓글 이벤트 바인딩 =================== */
    function bindCommentEvents() {
        // 메뉴 더보기 토글
        document.querySelectorAll('.btn_more').forEach(btn => {
            const menu = btn.nextElementSibling;
            if (!menu) return;

            btn.onclick = e => {
                e.stopPropagation();
				const commentLi = btn.closest('.cmt_set');
				if (!commentLi) {
			        console.warn("댓글 LI 요소를 찾을 수 없습니다.");
			        return;
			    }
				
				buildMenu(commentLi);
                menu.classList.toggle('active');
				
				// 다른 메뉴 닫기
                document.querySelectorAll('.ly_context').forEach(ctx => {
                    if (ctx !== menu) ctx.classList.remove('active');
                });
            };
        });
		
		// 문서 클릭 시 열린 메뉴 닫기
		document.addEventListener('click', e => {
		    document.querySelectorAll('.ly_context.active').forEach(menu => {
		        menu.classList.remove('active');
		    });
		});

		// 답글 버튼 클릭 시 답글 입력 폼 표시
		document.querySelectorAll('.btn_reply input[type="button"]').forEach(button => {
		    button.addEventListener("click", (e) => {
		        const currentLi = e.currentTarget.closest('.cmt_set');
		        if (!currentLi) return;

		        // 기존 답글 입력 폼 제거
		        document.querySelectorAll('.cmt_set.write_ver').forEach(el => el.remove());

		        const commentId = currentLi.dataset.commentId;
		        const writerName = loginUserName;

		        const replyForm = document.createElement('li');
		        replyForm.className = 'cmt_set write_ver';
		        replyForm.innerHTML = `
		            <div class="cmt_box">
		                
		                <div class="register_box">
		                    <div class="cmt_write_wrap">
		                        <form>
		                            <input type="hidden" name="parentId" value="${commentId}">
		                            <div class="cmt_text_area">
		                                <textarea name="replyContent" placeholder="답글을 입력해 주세요."></textarea>		
		                            </div>
		                            <div class="cmt_btn_area">
		                                <span class="btnBc cancel small"><input type="button" value="취소"></span>
		                                <span class="btnBc solid small"><input type="button" value="입력"></span>
		                            </div>
		                        </form>
		                    </div>
		                </div>
		            </div>
		        `;

		        // 모든 댓글 li 리스트 가져오기
		        const allLis = Array.from(document.querySelectorAll('.cmt_list > .cmt_set'));
		        
		        // 현재 댓글에 달린 답글 목록 가져오기
		        const replies = allLis.filter(li => 
		            li.classList.contains('reply') && 
		            li.previousElementSibling && 
		            li.previousElementSibling.dataset.commentId === commentId
		        );

		        // 실제로 parentId가 같은 reply들 가져오기
		        const sameParentReplies = allLis.filter(li => 
		            li.classList.contains('reply') && 
		            li.dataset.commentId !== commentId && 
		            li.dataset.parentId === commentId
		        );

		        // 답글이 하나도 없으면 댓글 바로 뒤에 삽입
		        if (sameParentReplies.length === 0) {
		            currentLi.insertAdjacentElement('afterend', replyForm);
		        } else {
		            // 가장 마지막 답글 뒤에 삽입
		            const lastReply = sameParentReplies[sameParentReplies.length - 1];
		            lastReply.insertAdjacentElement('afterend', replyForm);
		        }

		        bindReplyActions(replyForm);
		    });
		});

    }
	
	/* =================== 댓글 삭제 =================== */
	function deleteComment(commentId) {
		
		//console.log("삭제할 댓글 번호:", commentId);
	    if (!confirm("정말 삭제하시겠습니까?")) return;

		fetch(`/api/comments/${commentId}`, {
		    method: 'DELETE'
		})
		.then(async res => {
		    const text = await res.text(); // 응답 바디 출력
		    if (!res.ok) throw new Error(`삭제 실패: ${res.status} - ${text}`);
		    return res;
		})
		.then(() => loadComments(pNum))  // 목록 새로고침
		.catch(err => console.error("삭제 실패:", err));
	}
	
	/* =================== 댓글 수정 =================== */
	function editComment(commentId, originalContent) {
	    const targetLi = document.querySelector(`.cmt_set[data-comment-id='${commentId}']`);
	    if (!targetLi) return;

	    // 원래 내용 백업 (취소 시 복구용)
	    const originalHTML = targetLi.innerHTML;
		
		// 기존 프로필 이미지 src 추출
		const profileImgElement = targetLi.querySelector('.img_thumb');
		const profileImgSrc = profileImgElement ? profileImgElement.getAttribute('src') : contextPath + "/img/profile_default.png";

	    // 수정 폼으로 대체
	    targetLi.innerHTML = `
			<div class="photo">
                <div class="thumb">
                    <span class="initial_profile">
                        <img class="img_thumb" alt="프로필" src="${profileImgSrc}">
                    </span>
                </div>
            </div>
	        <div class="cmt_box">
	            <div class="register_box">
	                <div class="cmt_write_wrap">
	                    <form>
	                        <input type="hidden" name="commentId" value="${commentId}">
	                        <div class="cmt_text_area">
	                            <textarea name="editContent">${originalContent}</textarea>
	                        </div>
	                        <div class="cmt_btn_area">
	                            <span class="btnBc cancel small"><input type="button" value="취소"></span>
	                            <span class="btnBc solid small"><input type="button" value="수정"></span>
	                        </div>
	                    </form>
	                </div>
	            </div>
	        </div>
	    `;

	    // 수정 이벤트 바인딩
	    const cancelBtn = targetLi.querySelector('.btnBc.cancel input');
	    const submitBtn = targetLi.querySelector('.btnBc.solid input');
	    const textarea = targetLi.querySelector('textarea');

	    cancelBtn.onclick = () => {
	        targetLi.innerHTML = originalHTML; // 원래 내용 복구
			
			// 더보기 버튼 다시 활성화
		    const moreBtn = targetLi.querySelector('.btn_more');
		    if (moreBtn) {
		        moreBtn.onclick = (e) => {
		            e.preventDefault();
		            buildMenu(targetLi);
		            const menu = targetLi.querySelector('.ly_context');
		            menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
		        };
		    }
	    };
		
	    submitBtn.onclick = () => {
	        const updatedContent = textarea.value.trim();
	        if (!updatedContent) {
	            alert("수정할 내용을 입력해주세요.");
	            return;
	        }

	        fetch(`/api/comments/${commentId}`, {
	            method: "PUT",
	            headers: { 'Content-Type': 'application/json' },
	            body: JSON.stringify({ cContent: updatedContent })
	        })
	        .then(res => {
	            if (!res.ok) throw new Error("댓글 수정 실패");
	            return res.json();
	        })
	        .then(() => {
	            loadComments(pNum); // 댓글 새로고침
	        })
	        .catch(err => {
	            alert("댓글 수정 중 오류 발생");
	            console.error(err);
	        });
	    };
	}

	
	/* =================== 더보기 메뉴 분기 =================== */
	function buildMenu(li) {
	    const menuList = li.querySelector('.ly_context ul');
		console.log('menuList:', menuList);
		    if (!menuList) {
		        console.error('메뉴 리스트 ul 요소를 찾을 수 없습니다!');
		        return;
		    }
	    menuList.innerHTML = ''; // 기존 메뉴 제거
		
		const commentWriterId = li.dataset.writerId;		
		const isAuthor = commentWriterId == loginUserId;
		const isAdmin = ['SUPER_ADMIN', 'BOARD_MANAGER', 'EMPLOYEE_MANAGER'].includes(loginUserAuth);
		const isPostOwner = postWriterId == loginUserId;
		//console.log('작성자 ID:', commentWriterId);
	    //console.log('로그인 사용자 ID:', loginUserId);
	    //console.log('사용자 권한:', loginUserAuth);
	    console.log('포스트 작성자:', isPostOwner);
		const moreBtn = li.querySelector('.btn_more');
        if (moreBtn) {
            moreBtn.style.display = (isAuthor || isAdmin) ? '' : 'none';
        }

	    function add(label, callback) {
			//console.log('메뉴 추가:', label);
	        const item = document.createElement('li');
	        const btn = document.createElement('button');
	        btn.type = 'button';
	        btn.textContent = label;
	        btn.onclick = callback;
	        item.appendChild(btn);
	        menuList.appendChild(item);
	    }

	    // 기본 메뉴
    	//add('고정', () => {
        //console.log(`고정 요청: ${li.dataset.commentId}`);
    	//});

	  // 수정: 작성자 본인 또는 관리자만 가능
      if (isAuthor) {
          add('수정', () => {
              const originalContent = li.querySelector('.cmt_area span')?.textContent || "";
              editComment(li.dataset.commentId, originalContent);
          });
      }

      // 삭제: 작성자 본인 또는 관리자만 가능
	  if (isAuthor || isAdmin || isPostOwner) {
          add('삭제', () => deleteComment(li.dataset.commentId));
      }
	}

	
    /* =================== 답글 폼 이벤트 처리 =================== */
    function bindReplyActions(formLi) {
        const cancelBtn = formLi.querySelector('.btnBc.cancel input');
        const submitBtn = formLi.querySelector('.btnBc.solid input');
        const textarea = formLi.querySelector('textarea');

        cancelBtn.onclick = () => formLi.remove();

        submitBtn.onclick = () => {
            const parentIdInput = formLi.querySelector('input[name="parentId"]');
            const parentId = parentIdInput?.value;

            if (!parentId || parentId === "undefined") {
                alert("답글 부모 ID가 없습니다.");
                return;
            }

            const replyContent = textarea.value.trim();
            if (!replyContent) {
                alert("답글 내용을 입력하세요.");
                return;
            }

            const replyData = {
                pNum: pNum,
                parentId: parentId,
                cContent: replyContent,
                writerName: loginUserName 
            };

            fetch(`/api/posts/${pNum}/comments`, {
                method: "POST",
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(replyData)
            })
            .then(res => {
                if (!res.ok) throw new Error("답글 저장 실패");
                return res.json();
            })
            .then(() => {
                loadComments(pNum);
            })
            .catch(err => {
                alert("답글 등록 중 오류가 발생했습니다.");
                console.error(err);
            });

            formLi.remove();
        };
    }

	/* =================== 페이지 초기 댓글 로드 =================== */
	loadComments(pNum);

});
