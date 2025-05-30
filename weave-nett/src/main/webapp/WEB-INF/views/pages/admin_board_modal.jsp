<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<div id="overlay"></div>
<!-- 게시판 추가/요청 모달 -->
<div id="boardModal" class="modal-box"
	style="display: none; position: fixed; z-index: 1000; background: white; padding: 20px; border-radius: 10px; width: 500px; top: 50%; left: 50%; transform: translate(-50%, -50%)">
	<h3 id="modalTitle"></h3>
	<form id="boardForm" action="/api/boards" method="post">
		<input type="hidden" name="fromAdminPage" value="true" />
		<div class="radioBox">
			<p>구분</p>
			<input type="radio" id="check2_1_1" name="type" value="GENERAL" class="radio_box" checked onchange="onTypeChange(this.value)">
			<label for="check2_1_1">
				<span>전체 게시판</span>
			</label>
			<input type="radio" id="check2_1_2" name="type" value="DEPARTMENT" class="radio_box" onchange="onTypeChange(this.value)">
			<label for="check2_1_2">
				<span>부서 게시판</span>
			</label>
			<input type="radio" id="check2_1_3" name="type" value="PROJECT" class="radio_box" onchange="onTypeChange(this.value)">
			<label for="check2_1_3">
				<span>프로젝트 게시판</span>
			</label>
		</div>
		
		<div class="boardTitleBox">
			<p>게시판명</p>	
			<label for="boardName"></label>
			<input class="inpt" type="text" id="boardName" name="title" placeholder="게시판명을 입력해 주세요." required maxlength="20" oninput="updateCharCount()" />
			<div class="rt" id="charCount">0 / 20</div>
		</div>

		<div id="memberSection" style="display: none;">
			<div class="selectContainer">			
				<span class="btnBc outline small">			
					<button type="button" onclick="openMemberModal()">+ 사원 선택</button>
				</span>
				<p id="selectedMembersCount"></p>
			</div>
		</div>
		
		<!-- 관리자 부서 선택 UI -->
		<div id="deptSelectBox" class="selectBox small" style="display: none;">
		    <input type="text" class="txtBox" value="부서를 선택하세요" readonly id="select-name1">
		    <ul class="option" id="deptOptionList">
		        <!-- JS에서 부서 항목 렌더링 -->
		    </ul>
		</div>

		<input type="hidden" name="deptNum" id="deptNumInput" />
		<input type="hidden" name="memberIds" id="memberIdsInput" />

		<div style="text-align: right;">
			<span class="btnBc cancel small">			
				<button type="button" onclick="closeAllModal()">취소</button>
			</span>
			<span class="btnBc solid small">
				<button type="submit" id="submitBtn">요청</button>
			</span>
		</div>
	</form>
</div>

<!-- 사원 선택 모달 -->
<div id="memberModal" class="modal-box"
	style="display: none; position: fixed; z-index: 1050; background: white; padding: 20px; border-radius: 10px; width: 500px; top: 50%; left: 50%; transform: translate(-50%, -50%)">
	<h4>사원 선택</h4>
	<div class="listContainer">
		<!-- 왼쪽: 부서 목록 -->
		<div id="deptList">
			<!-- JS에서 부서 항목 렌더링 -->
		</div>
		<!-- 오른쪽: 사원 목록 -->
		<div id="memberList">
			<!-- 선택된 부서의 사원들 체크박스 렌더링 -->
		</div>
	</div>
	<div id="selectedMembers"></div>

	<div style="text-align: right;">
		<span class="btnBc cancel small">			
			<button onclick="closeMemberModal()">취소</button>
		</span>
		<span class="btnBc solid small">
			<button onclick="confirmMembers()">확인</button>
		</span>
	</div>
</div>

<script>
	const isAdmin = ${loginUser.uAuth eq 'SUPER_ADMIN' || loginUser.uAuth eq 'BOARD_MANAGER'};
	const userDeptNum = "${deptNum}";
	const loginUserNum = "${loginUser.uNum}";
	const loginUserName = "${eName}";
	const userAuth = "${loginUser.uAuth}";
	let currentType = null;
	let selectedUsers = {};
	let removedUsers = new Set();

	// 모달 열기
	function openModal(type) {
	    currentType = type;
	    const isAdminMode = (type === "admin");

	    document.getElementById("modalTitle").innerText = isAdminMode ? "게시판 추가" : "게시판 추가 요청";
	    document.getElementById("submitBtn").innerText = isAdminMode ? "등록" : "요청";
	    document.getElementById("boardForm").action = isAdminMode ? "/api/admin/boards" : "/api/boards";
	    
	    resetFormFields();
	    showModal("boardModal");
	}

	// 모달 닫기
	function closeAllModal() {
	    hideModal("boardModal");
	    hideModal("memberModal");
	    hideOverlay();
	}

	function closeMemberModal() {
	    hideModal("memberModal");
	}

	function showModal(id) {
	    document.getElementById("overlay").style.display = "block";
	    document.getElementById(id).style.display = "block";
	}

	function hideModal(id) {
	    document.getElementById(id).style.display = "none";
	}

	function hideOverlay() {
	    document.getElementById("overlay").style.display = "none";
	}

	// 폼 필드 초기화
	function resetFormFields() {
	    document.getElementById("boardName").value = "";
	    document.getElementById("charCount").textContent = "0 / 20";
	    document.getElementById("memberIdsInput").value = "";
	    document.getElementById("deptNumInput").value = "";

	    document.querySelector('input[name=type][value=GENERAL]').checked = true;
	    onTypeChange("GENERAL");

	    Object.keys(selectedUsers).forEach(key => delete selectedUsers[key]);
	    updateCharCount();
	    updateSelectedUserDisplay();
	    removedUsers.clear();
	}
	
	function ensureSelfSelected() {
	    const ifSelfMissing = !selectedUsers.hasOwnProperty(String(loginUserNum));
	    if ((userAuth === "BOARD_MANAGER" || userAuth === "USER") && ifSelfMissing) {
	        selectedUsers[String(loginUserNum)] = loginUserName;
	        updateSelectedUserDisplay();
	    }
	}

	// 게시판 구분 변경
	function onTypeChange(type) {
	    const isUser = currentType === "user";
	    const memberSection = document.getElementById("memberSection");
	    const deptSection = document.getElementById("deptSelectBox");

	    memberSection.style.display = (type === "PROJECT") ? "block" : "none";
	    deptSection.style.display = (type === "DEPARTMENT" && !isUser) ? "block" : "none"; // 관리자만 부서 선택 가능
	    
	    if (type === "DEPARTMENT") {
	        if (isUser) {
	            // 사용자면 자신의 부서번호 자동 설정
	            document.getElementById("deptNumInput").value = userDeptNum;
	        } else {
	            // 관리자는 직접 선택해야 하므로 초기화
	            document.getElementById("deptNumInput").value = "";
	            openDeptModal(); // 자동으로 부서선택 모달 열기 (선택적)
	        }
	    } else {
	        // 다른 타입일 경우 초기화
	        document.getElementById("deptNumInput").value = "";
	    }
	    
	    if (type === "DEPARTMENT" || type === "PROJECT") {
	        clearAllUsers();
	        ensureSelfSelected();
	    }

	}
	
	function openDeptModal() {
	    // 관리자일 경우에만 부서 선택 UI를 보여줌
	    if (currentType === "admin") {
	        document.getElementById("deptSelectBox").style.display = "block";
	        renderDeptSelectBox();  // 부서 목록 드롭다운 렌더링
	    }
	}
	
	// 부서 선택 모달 열기
	function renderDeptSelectBox() {
	    fetch("/api/departments")
	        .then(res => res.json())
	        .then(depts => {
	            const ul = document.getElementById("deptOptionList");
	            const input = document.getElementById("select-name1");
	            ul.innerHTML = "";
	
	            depts.forEach(dept => {
	                const li = document.createElement("li");
	                const a = document.createElement("a");
	                a.href = "#";
	                a.textContent = dept.deptName;
	                a.onclick = (e) => {
	                    e.preventDefault();
	                    input.value = dept.deptName;
	                    document.getElementById("deptNumInput").value = dept.deptId;
	                    ul.style.display = "none";
	                    
	                    input.style.border = "";
	                };
	                li.appendChild(a);
	                ul.appendChild(li);
	            });
	
	            // 기본값 초기화
	            input.value = "부서를 선택하세요";
	            document.getElementById("deptNumInput").value = "";
	
	            // ▼ 드롭다운 열고 닫기 이벤트 연결
	            input.addEventListener("click", function () {
	                const isVisible = ul.style.display === "block" || getComputedStyle(ul).display === "block";
	                ul.style.display = isVisible ? "none" : "block";
	            });
	        });
	}
	
	document.getElementById("boardForm").addEventListener("submit", function (e) {
	    e.preventDefault();

	    const selectedType = document.querySelector('input[name="type"]:checked').value;
	    const deptNum = document.getElementById("deptNumInput").value;
	    const selectInput = document.getElementById("select-name1");
	    const boardName = document.getElementById("boardName").value;
	    const trimmedName = boardName.trim();

	    if (!trimmedName) {
	        alert("게시판명을 입력해 주세요.");
	        return false;
	    }

	    // 클라이언트 금지어 체크도 공백 제거 후 하는 게 좋음 (선택)
	    const forbiddenKeywords = ["공지", "관리자", "행사"].map(k => k.replace(/\s+/g, ""));
	    const normalizedName = trimmedName.replace(/\s+/g, "");
	    const hasForbiddenWord = forbiddenKeywords.some(keyword => normalizedName.includes(keyword));

	    if (hasForbiddenWord) {
	        alert("‘공지’, ‘관리자’, '행사'가 포함된 게시판명은 추가할 수 없습니다.");
	        return false;
	    }

	    if (selectedType === "DEPARTMENT" && !deptNum) {
	        alert("부서를 선택해야 게시판을 추가할 수 있습니다.");
	        selectInput.style.border = "1px solid red";
	        selectInput.focus();
	        return false;
	    }
	    selectInput.style.border = "";

	    const encodedTitle = encodeURIComponent(trimmedName);
	    fetch("/api/boards/check-name?title=" + encodedTitle)
	        .then(res => res.json())
	        .then(result => {
	            if (result.forbidden) {
	                alert("‘공지’, ‘관리자’, '행사'가 포함된 게시판명은 추가할 수 없습니다.");
	            } else if (result.exists) {
	                alert("사용할 수 없는 게시판명입니다. 다른 이름을 입력해주세요.");
	            } else {
	                document.getElementById("boardForm").submit();
	            }
	        });
	});

	// 사원 선택 모달 열기
	function openMemberModal() {
	    fetch("/api/departments")
	        .then(res => res.json())
	        .then(renderDeptList);
	}

	// 부서 리스트 렌더링
	function renderDeptList(depts) {
	    const deptListEl = document.getElementById("deptList");
	    deptListEl.innerHTML = "";

	    const selectedType = document.querySelector('input[name="type"]:checked').value;

	    depts.forEach(dept => {
	        if (!isAdmin && selectedType === "DEPARTMENT" && dept.deptId != userDeptNum) return;

	        const div = document.createElement("div");
	        div.innerText = dept.deptName;
	        div.dataset.deptId = dept.deptId;
	        div.onclick = () => {
	            document.querySelectorAll("#deptList div").forEach(el => el.classList.remove("selected"));
	            div.classList.add("selected");
	            loadMembers(dept.deptId);
	        };
	        deptListEl.appendChild(div);
	    });

	    if (deptListEl.firstChild) deptListEl.firstChild.click();
	    showModal("memberModal");
	}

	// 부서별 사원 로딩
	function loadMembers(deptId) {
		fetch("/api/departments/members?deptId=" + deptId)
	    .then(res => res.json())
	    .then(data => {
	        const members = Array.isArray(data) ? data : data.data || [];
	        renderMemberList(members);
	    });
	}

	// 사원 목록 렌더링
	function renderMemberList(members) {
	    const memberList = document.getElementById("memberList");
	    memberList.innerHTML = "";

	    if (members.length === 0) {
	        memberList.innerHTML = "<p style='color:#aaa;'>해당 부서에 등록된 사원이 없습니다.</p>";
	        return;
	    }

	    members.forEach(member => {
	        const label = document.createElement("label");
	        label.htmlFor = "checkbox_" + member.uNum;

	        const checkbox = document.createElement("input");
	        checkbox.type = "checkbox";
	        checkbox.value = member.uNum;
	        checkbox.id = "checkbox_" + member.uNum;
	        checkbox.className = "check_box small";
	        
	        const ifSelf = String(member.uNum) == String(loginUserNum);
	        
	        if(userAuth === "USER" && ifSelf) {
	        	checkbox.checked = true;
	        	checkbox.disabled = true;
	        	selectedUsers[String(member.uNum)] = loginUserName;
	        } else if(userAuth === "BOARD_MANAGER" && ifSelf) {
	        	if(!removedUsers.has(String(member.uNum))) {	        		
		        	checkbox.checked = true;
		        	selectedUsers[String(member.uNum)] = loginUserName;
	        	} else {
	        		checkbox.checked = false;
	        	}
	        } else if(selectedUsers.hasOwnProperty(String(member.uNum))) {
	        	checkbox.checked = true;
	        } else if(removedUsers.has(String(member.uNum))) {
	        	checkbox.checked = false;
	        } else {
	        	checkbox.checked = false;
	        }
	        
	        checkbox.addEventListener("change", () => {
	            if (checkbox.checked) {
	                selectedUsers[String(member.uNum)] = member.eName;
	                removedUsers.delete(String(member.uNum));
	            } else {
	                delete selectedUsers[String(member.uNum)];
	                removedUsers.add(String(member.uNum));
	            }
	            updateSelectedUserDisplay();
	        });
	        const memberspan = document.createElement("span");
	        const positionspan = document.createElement("p");
	        memberspan.innerHTML = member.eName;
	        positionspan.innerHTML = member.ePosition;
	        
	        label.appendChild(memberspan);
	        label.appendChild(positionspan);
	        
	        memberList.appendChild(checkbox);
	        memberList.appendChild(label);
	        memberList.appendChild(document.createElement("br"));
	    });
	    
	    updateSelectedUserDisplay(); 
	}

	// 사원 선택 확정
	function confirmMembers() {
	    const ids = Object.keys(selectedUsers);
	    document.getElementById("memberIdsInput").value = ids.join(",");
	    updateSelectedUserDisplay();
	    closeMemberModal();
	}

	// 글자 수 카운트
	function updateCharCount() {
	    const input = document.getElementById("boardName");
	    const charCount = document.getElementById('charCount');
	    
	    if (input.value.length > 20) {
	    	input.value = input.value.slice(0, 20);
	    }
	    const count = input.value.length;
	    
	    charCount.textContent = count + " / 20";
	    
	    charCount.classList.toggle('char-over', count == 20);
	}
	

	// 선택된 사원 목록 UI 갱신
	function updateSelectedUserDisplay() {
	    const container = document.getElementById("selectedMembers");
	    container.innerHTML = "";

	    const entries = Object.entries(selectedUsers);
	    const countBox = document.getElementById("selectedMembersCount");
	    if (countBox) {
	        countBox.textContent = entries.length;
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
	    allDel.onclick = clearAllUsers;
	    countSpan.appendChild(allDel);
	    container.appendChild(countSpan);
	    
	    entries.forEach(([uNum, eName]) => {
	        const span = document.createElement("span");
	        span.className = "member-chip";
	        const ifSelf = String(uNum) === String(loginUserNum);

	        const namePart = document.createElement("span");
	        namePart.textContent = eName || '(이름없음)';
	        span.appendChild(namePart);

	        if(userAuth === "USER" && ifSelf) {
	            // 버튼 없이 placeholder 추가
	            const placeholder = document.createElement("span");
	            placeholder.className = "button-placeholder";
	            span.appendChild(placeholder);
	        } else {
	            const btn = document.createElement("button");
	            btn.textContent = "x";
	            btn.onclick = () => removeUser(uNum);
	            span.appendChild(btn);
	        }

	        container.appendChild(span);
	    });
	}

	function removeUser(uNum) {
		if (userAuth === "USER" && String(uNum) === String(loginUserNum)) {
	        return;
	    }
		
	    delete selectedUsers[String(uNum)];
	    removedUsers.add(String(uNum));
	    updateSelectedUserDisplay();

	    const selectedDept = document.querySelector("#deptList .selected")?.dataset.deptId;
	    if (selectedDept) loadMembers(selectedDept);
	}

	function clearAllUsers() {
	    Object.keys(selectedUsers).forEach(key => {
	    	if(userAuth === "USER" && key === String(loginUserNum)) return;
	    	delete selectedUsers[key];
	    	removedUsers.add(String(key));
	    });
	    updateSelectedUserDisplay();

	    const selectedDept = document.querySelector("#deptList .selected")?.dataset.deptId;
	    if (selectedDept) loadMembers(selectedDept);
	}
</script>

