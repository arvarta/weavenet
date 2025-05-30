<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="overlay"></div>
<!-- 게시판 수정 모달 -->
<div id="boardEditModal" class="modal-box"
     style="display: none; position: fixed; z-index: 1000; background: white; padding: 20px; border-radius: 10px; width: 500px; top: 50%; left: 50%; transform: translate(-50%, -50%)">
    <h3 id="editModalTitle">게시판 수정</h3>
    <form id="boardEditForm" action="" method="post">
    	<input type="hidden" id="editBoardId" name="bNum" />
        <div class="radioBox">
            <p>구분</p>
            <div class="radioItem">
	            <input type="radio" id="check2_1_1" name="type" value="GENERAL" class="radio_box" onchange="onEditTypeChange(this.value)">
	            <label for="check2_1_1"><span>전체 게시판</span></label>
			</div>
			<div class="radioItem">
	            <input type="radio" id="check2_1_2" name="type" value="DEPARTMENT" class="radio_box" onchange="onEditTypeChange(this.value)">
	            <label for="check2_1_2"><span>부서 게시판</span></label>
            </div>
			<div class="radioItem">
	            <input type="radio" id="check2_1_3" name="type" value="PROJECT" class="radio_box" onchange="onEditTypeChange(this.value)">
	            <label for="check2_1_3"><span>프로젝트 게시판</span></label>
            </div>
        </div>

        <div class="boardTitleBox">
            <p>게시판명</p>
            <input class="inpt" type="text" id="editBoardName" name="title" placeholder="게시판명을 입력해 주세요." required maxlength="20" oninput="updateEditCharCount()" />
            <div class="rt" id="editCharCount">0 / 20</div>
        </div>

        <div id="editMemberSection" style="display: none;">
            <div class="selectContainer">
                <span class="btnBc outline small">
                    <button type="button" onclick="openEditMemberModal()">+ 인원 수정</button>
                </span>
                <p id="editSelectedMembersCount"></p>
            </div>
        </div>

        <div id="editDeptSelectBox" class="selectBox small" style="display: none;">
            <input type="text" class="txtBox" value="부서를 선택하세요" readonly id="editSelectDeptName">
            <ul class="option" id="editDeptOptionList"></ul>
        </div>

        <input type="hidden" name="deptNum" id="editDeptNumInput" />
        <input type="hidden" name="memberIds" id="editMemberIdsInput" />

        <div style="text-align: right;">
            <span class="btnBc cancel small">
                <button type="button" onclick="closeEditModal()">취소</button>
            </span>
            <span class="btnBc solid small">
                <button type="submit" id="editSubmitBtn">수정</button>
            </span>
        </div>
    </form>
</div>

<!-- 사원 선택 모달 (수정용) -->
<div id="editMemberModal" class="modal-box"
     style="display: none; position: fixed; z-index: 1050; background: white; padding: 20px; border-radius: 10px; width: 500px; top: 50%; left: 50%; transform: translate(-50%, -50%)">
    <h4>인원 수정</h4>
    <div class="editListContainer">
    	<div id="editDeptList"></div>
        <div id="editMemberList"></div>
    </div>
    <div id="editSelectedMembers"></div>

    <div style="text-align: right;">
        <span class="btnBc cancel small">
            <button type="button" onclick="closeEditMemberModal()">취소</button>
        </span>
        <span class="btnBc solid small">
            <button type="button" onclick="confirmEditMembers()">확인</button>
        </span>
    </div>
</div>

<script>
	let editSelectedUsers = {};
	let editRemovedUsers = new Set();
	let currentEditMemberList = [];
	let editCurrentType = null;
	const loginUserNumStr = String("${loginUser.uNum}");  // 기존 값 활용
	const loginUserENameStr = "${eName}";
	const userAuthStr = "${loginUser.uAuth}";
	const userDeptNumStr = String("${deptNum}");
	
	
	// 게시판 수정 모달 열기 (기존 게시판 데이터 넘김)
	function openEditModal(bNum) {
	    editCurrentType = "admin";
	    showModal("boardEditModal"); // 모달 먼저 띄우기
	    
	    const target = document.querySelector(".cmt_task .ly_context.active");
	    if (target) {
	    	target.style.display = "none";
	    }
	    
	    resetEditFormFields();
	
	    fetch("/api/admin/boards/" + bNum + "/data")
	        .then(res => {
	            if (!res.ok) throw new Error("접근 불가");
	            return res.json();
	        })
	        .then(boardData => {
	            console.log("boardData: ", boardData);
	
	            // 기본 값 세팅
	            document.getElementById("editBoardId").value = boardData.bNum || "";
	            document.getElementById("editBoardName").value = boardData.bTitle || "";
	            updateEditCharCount();
	
	            // 부서 선택 초기화
	            if (boardData.deptNum) {
	                document.getElementById("editDeptNumInput").value = boardData.deptNum;
	                document.getElementById("editSelectDeptName").value = boardData.deptName || "부서를 선택하세요";
	            } else {
	                document.getElementById("editDeptNumInput").value = "";
	                document.getElementById("editSelectDeptName").value = "부서를 선택하세요";
	            }
				
	            // 사원 선택 초기화
	            editSelectedUsers = {};
	            editRemovedUsers.clear();
	            if (Array.isArray(boardData.members) && boardData.members.length > 0) {
	            	console.log("members data: ", boardData.members);
	            	boardData.members.forEach(m => {
	            	    const name = m.name || '(이름없음)'; // 여기서 미리 fallback 처리
	            	    editSelectedUsers[String(m.id)] = name;
	            	});
	            }
	
	            updateEditSelectedUserDisplay();
	
	            setTimeout(() => {
	                if (boardData.bType) {
	                    const radios = document.querySelectorAll(`#boardEditForm input[name="type"]`);
	                    radios.forEach(radio => {
	                        const isMatch = radio.value === boardData.bType;
	                        radio.disabled = false;
	                        radio.checked = isMatch;
	                        if (!isMatch) radio.disabled = true;
	                    });
	                    onEditTypeChange(boardData.bType);
	                }
	            }, 0); // 모달 렌더링 이후 실행
	        })
	        .catch(err => {
	            alert(err.message);
	        });
	}

	
	// 구분 변경 이벤트 (수정 모달)
	function onEditTypeChange(type) {
	    editCurrentType = "admin"; // 관리자 모드 기준
	
	    const memberSection = document.getElementById("editMemberSection");
	
	    memberSection.style.display = (type === "PROJECT") ? "block" : "none";
	
	    // 부서 선택 초기화 (부서게시판일때만)
	    if (type === "DEPARTMENT") {
	        // 부서 직접 선택 모드
	        document.getElementById("editDeptNumInput").value = "";
	        document.getElementById("editSelectDeptName").value = "부서를 선택하세요";
	    } else {
	        document.getElementById("editDeptNumInput").value = "";
	        document.getElementById("editSelectDeptName").value = "부서를 선택하세요";
	    }
	
	}
	
	// 글자 수 카운트 (수정 모달)
	function updateEditCharCount() {
	    const input = document.getElementById("editBoardName");
	    const charCount = document.getElementById('editCharCount');
	
	    if (input.value.length > 20) {
	        input.value = input.value.slice(0, 20);
	    }
	    const count = input.value.length;
	
	    charCount.textContent = count + " / 20";
	    charCount.classList.toggle('char-over', count === 20);
	}
	
	// 부서 리스트 렌더링 (수정 모달)
	function renderEditDeptList(depts) {
	    const deptListEl = document.getElementById("editDeptList");
	    deptListEl.innerHTML = "";
	
	    const selectedType = document.querySelector('#boardEditForm input[name="type"]:checked').value;
	
	    depts.forEach(dept => {
	        // 권한 체크 - 관리자 아니고, 부서 게시판이면 본인 부서만 보이도록
	        if (userAuthStr !== "admin" && selectedType === "DEPARTMENT" && dept.deptId != userDeptNumStr) return;
	
	        const div = document.createElement("div");
	        div.innerText = dept.deptName;
	        div.dataset.deptId = dept.deptId;
	        div.style.cursor = "pointer";
	        div.onclick = () => {
	        	document.querySelectorAll("#editDeptList div").forEach(el => el.classList.remove("selected"));
	            div.classList.add("selected");
	            fetchMembersByDept(dept.deptId);
	        };
	        deptListEl.appendChild(div);
	    });
	    
	    if (deptListEl.firstChild) deptListEl.firstChild.click();
	    
	}
	
	// 선택된 부서에 따른 사원 목록 가져오기
	function fetchMembersByDept(deptId) {
		fetch("/api/departments/members?deptId=" + deptId)
	    .then(res => res.json())
	    .then(data => {
	        const members = Array.isArray(data) ? data : data.data || [];
	        renderEditMemberList(members);
	    });
	}
	
	// 사원 목록 렌더링 (수정 모달)
	function renderEditMemberList(members) {
		currentEditMemberList = members;
		
	    const memberListEl = document.getElementById("editMemberList");
	    memberListEl.innerHTML = "";
	
	    if (!Array.isArray(members) || members.length === 0) {
	        memberListEl.innerHTML = "<p style='color:#aaa;'>해당 부서에 등록된 사원이 없습니다.</p>";
	        return;
	    }
	
	    members.forEach(member => {
	        // 라벨 생성
	        const label = document.createElement("label");
	        label.htmlFor = "checkbox_" + member.uNum;
	
	        // 체크박스 생성
	        const checkbox = document.createElement("input");
	        checkbox.type = "checkbox";
	        checkbox.value = member.uNum;
	        checkbox.id = "checkbox_" + member.uNum;
	        checkbox.className = "check_box small";
	
	        const memNumStr = String(member.uNum);
	        const isLoginUser = (memNumStr === loginUserNumStr);
	
	        // 체크 상태 초기화 (권한 및 선택 상태 반영)
	        if (userAuthStr === "USER" && isLoginUser) {
	            checkbox.checked = true;
	            checkbox.disabled = true;
	            editSelectedUsers[memNumStr] = loginUserENameStr;
	        } else if (userAuthStr === "BOARD_MANAGER" && isLoginUser) {
	            if (!editRemovedUsers.has(memNumStr)) {
	                checkbox.checked = true;
	                editSelectedUsers[memNumStr] = loginUserENameStr;
	            } else {
	                checkbox.checked = false;
	            }
	        } else if (editSelectedUsers.hasOwnProperty(memNumStr)) {
	            checkbox.checked = true;
	        } else if (editRemovedUsers.has(memNumStr)) {
	            checkbox.checked = false;
	        } else {
	            checkbox.checked = false;
	        }
	
	        // 체크박스 상태 변경 시 이벤트
	        checkbox.addEventListener("change", () => {
	            if (checkbox.checked) {
	                editSelectedUsers[memNumStr] = member.eName;
	                editRemovedUsers.delete(memNumStr);
	            } else {
	                if (isLoginUser && userAuthStr === "USER") {
	                    checkbox.checked = true; // 본인 체크 해제 막기
	                    return;
	                }
	                delete editSelectedUsers[memNumStr];
	                editRemovedUsers.add(memNumStr);
	            }
	            updateEditSelectedUserDisplay();
	        });
	
	        // 이름, 직위 텍스트
	        const memberspan = document.createElement("span");
	        const positionspan = document.createElement("p");
	        memberspan.textContent = member.eName;
	        positionspan.textContent = member.ePosition || "";
	
	        label.appendChild(memberspan);
	        label.appendChild(positionspan);
	
	        memberListEl.appendChild(checkbox);
	        memberListEl.appendChild(label);
	        memberListEl.appendChild(document.createElement("br"));
	        
	    });
	
	    updateEditSelectedUserDisplay();
	}
	
	// 선택된 사원 리스트 업데이트 (수정 모달)
	function updateEditSelectedUserDisplay() {
	    
	    const container = document.getElementById("editSelectedMembers");
	    container.innerHTML = "";
	
	    const selectedCountEl = document.getElementById("editSelectedMembersCount");
	    const selectedMemberIdsInput = document.getElementById("editMemberIdsInput");
	
	    const entries = Object.entries(editSelectedUsers);
	    
	    if (selectedCountEl) {
	        selectedCountEl.textContent = entries.length;
	    }
	    if (selectedMemberIdsInput) {
	        selectedMemberIdsInput.value = entries.map(([id]) => id).join(",");
	    }
	
	    if (entries.length === 0) {
	        container.innerHTML = "<p style='color:#aaa;'>선택된 사원이 없습니다.</p>";
	        return;
	    }
	
	    const countSpan = document.createElement("div");
	    countSpan.style.margin = "10px 0px";
	    countSpan.innerHTML = "선택 <strong>" + entries.length + "</strong>";
	
	    const allDel = document.createElement("button");
	    allDel.innerText = "전체 삭제";
	    allDel.onclick = clearAllEditUsers;
	    countSpan.appendChild(allDel);
	    container.appendChild(countSpan);
	
	    entries.forEach(([uNum, eName]) => {
	        const span = document.createElement("span");
	        span.className = "member-chip";
	        const ifSelf = String(uNum) === loginUserNumStr;
	
	        const namePart = document.createElement("span");
	        namePart.textContent = (typeof eName === "string" && eName.trim() !== "") ? eName : '(이름없음)';
	        span.appendChild(namePart);
	
	        if (userAuthStr === "USER" && ifSelf) {
	            const placeholder = document.createElement("span");
	            placeholder.className = "button-placeholder";
	            span.appendChild(placeholder);
	        } else {
	            const btn = document.createElement("button");
	            btn.textContent = "x";
	            btn.onclick = () => removeEditUser(uNum);
	            span.appendChild(btn);
	        }
	
	        container.appendChild(span);
	    });
	}

	
	// 선택된 사원 모달 확인 버튼 클릭 (수정 모달)
	function confirmEditMembers() {
	    // 모달 닫기
	    closeEditMemberModal();
	    document.getElementById("overlay").style.display = "block";
	}
	
	// 모달 보여주기
	function showModal(modalId) {
		document.getElementById("overlay").style.display = "block";
	    document.getElementById(modalId).style.display = "block";
	}
	
	// 모달 닫기
	function closeEditModal() {
	    document.getElementById("boardEditModal").style.display = "none";
	    document.getElementById("overlay").style.display = "none";
	    const target = document.querySelector(".cmt_task .ly_context.active");
	    if (target) {
	    	target.style.display = "";
	    	target.classList.remove("active");
	    }
	}
	function closeEditMemberModal() {
	    document.getElementById("editMemberModal").style.display = "none";
	    document.getElementById("overlay").style.display = "block";
	}
	
	// 선택된 사원 모달 열기 (수정용)
	function openEditMemberModal() {
	    showModal("editMemberModal");
	    // 부서 리스트 불러오기
	    fetch("/api/departments")
	        .then(res => res.json())
	        .then(renderEditDeptList);
	}
	
	function removeEditUser(uNum) {
	    delete editSelectedUsers[uNum];
	    editRemovedUsers.add(uNum);
	    updateEditSelectedUserDisplay();
	    renderEditMemberList(currentEditMemberList);
	}
	
	// 사원 선택 초기화 (수정 모달)
	function clearAllEditUsers() {
	    editSelectedUsers = {};
	    editRemovedUsers.clear();
	    updateEditSelectedUserDisplay();
	    renderEditMemberList(currentEditMemberList);
	}
	
	// 본인 사원은 항상 선택해두기 (수정 모달)
	function ensureSelfSelectedEdit() {
	    editSelectedUsers[loginUserNumStr] = loginUserENameStr;
	    updateEditSelectedUserDisplay();
	}
	
	// 폼 제출 시 validation
	document.getElementById("boardEditForm").addEventListener("submit", (e) => {
	    e.preventDefault();
	
	    const boardId = document.getElementById("editBoardId").value;
	    const type = document.querySelector('#boardEditForm input[name="type"]:checked').value;
	    const boardName = document.getElementById("editBoardName").value.trim();
	    const deptNum = document.getElementById("editDeptNumInput").value;
	
	    if (!boardName) {
	        alert("게시판명을 입력해주세요.");
	        return;
	    }
	
	    if (type === "PROJECT") {
	        if (Object.keys(editSelectedUsers).length === 0) {
	            alert("사원을 한 명 이상 선택해주세요.");
	            return;
	        }
	    }
	    
	    const trimmedName = boardName.trim();
	    const forbiddenKeywords = ["공지", "관리자"].map(k => k.replace(/\s+/g, ""));
	    const normalizedName = trimmedName.replace(/\s+/g, "");
	    const hasForbiddenWord = forbiddenKeywords.some(keyword => normalizedName.includes(keyword));

	    if (hasForbiddenWord) {
	        alert("‘공지’, ‘관리자’가 포함된 게시판명은 수정할 수 없습니다.");
	        return false;
	    }
	
	    const payload = {
			boardName,
			type,
			deptNum,
			memberIds: Object.keys(editSelectedUsers).map(id => Number(id))
   		};
	    
	    // 실제 수정 요청 보내기
	    const formData = new FormData(e.target);
	    fetch('/api/admin/boards/' + boardId, {
	        method: "PUT",
	        headers: {
	        	"Content-Type": "application/json"
	        },
	        body: JSON.stringify(payload)
	    })
	    .then(res => res.json())
	    .then(data => {
	        if (data.success) {
	            alert("게시판이 수정되었습니다.");
	            location.reload();
	            closeEditModal();
	        } else {
	            alert("수정 중 오류가 발생했습니다.");
	        }
	    }).catch(() => {
	        alert("서버와 통신 중 오류가 발생했습니다.");
	    });
	});
	
	// 초기화 함수
	function resetEditFormFields() {
	    document.getElementById("editBoardId").value = "";
	    document.getElementById("editBoardName").value = "";
	    
	    updateEditCharCount();
	
	    document.querySelectorAll('#boardEditForm input[name="type"]').forEach(r => r.checked = false);
	
	    document.getElementById("editDeptNumInput").value = "";
	    document.getElementById("editSelectDeptName").value = "부서를 선택하세요";
	
	    clearAllEditUsers();
	}
	
</script>
