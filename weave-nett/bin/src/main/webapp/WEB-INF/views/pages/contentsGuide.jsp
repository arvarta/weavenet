<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>컨텐츠 가이드</title>
	<style>
			h1{font-size:30px;font-weight:700;}
			h2{margin-bottom:20px;padding:0 20px; font-size:22px;line-height:50px;font-weight:700;background-color: var(--color-gray-100);}
			.guide_wrap{margin-bottom:50px;padding:0 20px;}
			.guide_box h3{margin-bottom:10px;font-size:18px;font-weight:700}
			.guide_box h4{margin:0 0 10px;font-size:14px;font-weight:500}
			.guide_wrap.con1 h4{margin-bottom:-15px}
			.tab_Con{padding:20px}

			.flex_w1{display: flex;margin-bottom: 20px;}
			.flex_w1 > div{flex: 1;padding-right:20px;width: fit-content;}
			.mt10{margin-top: 10px;}
			.mb10{margin-bottom: 10px;}
			.mb20{margin-bottom: 20px;}
			.mb30{margin-bottom: 30px;}

			#wrapper{padding:0}
			#container{padding:0}
		</style>
</head>
<body>
	<h1 class="mb30">CONTENTS GUIDE</h1>
	<!-- 버튼 가이드 -->
	<h2>BUTTON GUIDE</h2>
	<div class="guide_wrap con1">
		<div class="guide_box">
			<h3>Solid button</h3>
			<div class="flex_w1">
				<div>
					<p class="mb10">Large</u></p>
					<span class="btnBc solid large"><input type="button" value="확인"></span> 
					<span class="btnBc solid large radius"><input type="button" value="확인"></span>
				</div>
				<div>
					<p class="mb10">Medium</u></p>
					<span class="btnBc solid medium"><a href="#">목록</a></span> 
					<span class="btnBc solid medium radius"><a href="#">목록</a></span>
				</div>
				<div>
					<p class="mb10">Small</u></p>
					<span class="btnBc solid small"><button type="button">목록</button></span>
					<span class="btnBc solid small radius"><button type="button">목록</button></span>
				</div>
				<div>
					<p class="mb10">Xsmall</u></p>
					<span class="btnBc solid xsmall"><input type="button" value="확인"></span>
					<span class="btnBc solid xsmall radius"><input type="button" value="확인"></span>
				</div>
			</div>
			<p class="mb30">class="btnBc"에 <u>solid</u> 추가</p>
			<h3>Outline button</h3>
			<div class="flex_w1">
				<div>
					<p class="mb10">Large</u></p>
					<span class="btnBc outline large"><input type="button" value="확인"></span> 
					<span class="btnBc outline large radius"><input type="button" value="확인"></span>
				</div>
				<div>
					<p class="mb10">Medium</u></p>
					<span class="btnBc outline medium"><a href="#">목록</a></span> 
					<span class="btnBc outline medium radius"><a href="#">목록</a></span>
				</div>
				<div>
					<p class="mb10">Small</u></p>
					<span class="btnBc outline small"><button type="button">목록</button></span>
					<span class="btnBc outline small radius"><button type="button">목록</button></span>
				</div>
				<div>
					<p class="mb10">Xsmall</u></p>
					<span class="btnBc outline xsmall"><input type="button" value="확인"></span>
					<span class="btnBc outline xsmall radius"><input type="button" value="확인"></span>
				</div>
			</div>
			<p class="mb30">class="btnBc"에 <u>outline</u> 추가</p>
			<h3>Cancel button</h3>
			<div class="flex_w1">
				<div>
					<p class="mb10">Large</u></p>
					<span class="btnBc cancel large"><input type="button" value="취소"></span> 
					<span class="btnBc cancel large radius"><input type="button" value="취소"></span>
				</div>
				<div>
					<p class="mb10">Medium</u></p>
					<span class="btnBc cancel medium"><input type="button" value="취소"></span> 
					<span class="btnBc cancel medium radius"><input type="button" value="취소"></span>
				</div>
				<div>
					<p class="mb10">Small</u></p>
					<span class="btnBc cancel small"><input type="button" value="취소"></span>
					<span class="btnBc cancel small radius"><input type="button" value="취소"></span>
				</div>
				<div>
					<p class="mb10">Xsmall</u></p>
					<span class="btnBc cancel xsmall"><input type="button" value="취소"></span>
					<span class="btnBc cancel xsmall radius"><input type="button" value="취소"></span>
				</div>
			</div>
			<p class="mb30">class="btnBc"에 <u>cancel</u> 추가</p>
			<h3>Disabled button</h3>
			<div class="flex_w1">
				<div>
					<p class="mb10">Large</u></p>
					<span class="btnBc disabled large"><input type="button" value="확인"></span> 
					<span class="btnBc disabled large radius"><input type="button" value="확인"></span>
				</div>
				<div>
					<p class="mb10">Medium</u></p>
					<span class="btnBc disabled medium"><input type="button" value="확인"></span> 
					<span class="btnBc disabled medium radius"><input type="button" value="확인"></span>
				</div>
				<div>
					<p class="mb10">Small</u></p>
					<span class="btnBc disabled small"><input type="button" value="확인"></span>
					<span class="btnBc disabled small radius"><input type="button" value="확인"></span>
				</div>
				<div>
					<p class="mb10">Xsmall</u></p>
					<span class="btnBc disabled xsmall"><input type="button" value="확인"></span>
					<span class="btnBc disabled xsmall radius"><input type="button" value="확인"></span>
				</div>
			</div>
			<p class="mb30">class="btnBc"에 <u>disabled</u> 추가</p>
		</div>
		<p class="mb10">※ 버튼 사이즈별 class="large", class="medium", class="small", class="small2", class="xsmall" 추가</p>
		<p>※ 라운드버튼 class="radius" 추가</p>
	</div>
	<!-- // 버튼 가이드 -->
	<!-- 체크박스 가이드 -->
	<h2>CHECKBOX GUIDE</h2>
	<div class="guide_wrap">
		<div class="guide_box">
			<h3>Check Button</h3>
			<div class="flex_w1 mb20">
				<div>
					<h4>Large</h4>
					<input type="checkbox" id="check1_1_4" name="check1_1" class="check_box"><label for="check1_1_4"></label>
					<input type="checkbox" id="check1_1_1" name="check1_1" class="check_box"><label for="check1_1_1"><span>Defalt</span></label>
					<input type="checkbox" id="check1_1_2" name="check1_1" class="check_box" checked><label for="check1_1_2"><span>Focuced</span></label>
					<input type="checkbox" id="check1_1_3" name="check1_1" class="check_box" disabled><label for="check1_1_3"><span>Disabled</span></label>
					<p class="mt10">* 체크박스 <u>class="check_box"</u> 사용</p>
				</div>
				<div>
					<h4>Small</h4>
					<input type="checkbox" id="check1_2_4" name="check1_2" class="check_box small"><label for="check1_2_4"></label>
					<input type="checkbox" id="check1_2_1" name="check1_2" class="check_box small"><label for="check1_2_1"><span>Defalt</span></label>
					<input type="checkbox" id="check1_2_2" name="check1_2" class="check_box small" checked><label for="check1_2_2"><span>Focuced</span></label>
					<input type="checkbox" id="check1_2_3" name="check1_2" class="check_box small" disabled><label for="check1_2_3"><span>Disabled</span></label>
					<p class="mt10">* 체크박스 class="check_box <u>small</u>" 사용</p>
				</div>
			</div>
			<div class="flex_w1 mb40">
				<div>
					<input type="checkbox" id="check1_3_1" name="check1_3" class="check_box2"><label for="check1_3_1"><span>Defalt</span></label>
					<input type="checkbox" id="check1_3_2" name="check1_3" class="check_box2" checked><label for="check1_3_2"><span>Focuced</span></label>
					<input type="checkbox" id="check1_3_3" name="check1_3" class="check_box2" disabled><label for="check1_3_3"><span>Disabled</span></label>
					<p class="mt10">* 체크박스 <u>class="check_box2"</u> 사용</p>
				</div>
				<div>
					<input type="checkbox" id="check1_4_1" name="check1_4" class="check_box2 small"><label for="check1_4_1"><span>Defalt</span></label>
					<input type="checkbox" id="check1_4_2" name="check1_4" class="check_box2 small" checked><label for="check1_4_2"><span>Focuced</span></label>
					<input type="checkbox" id="check1_4_3" name="check1_4" class="check_box2 small" disabled><label for="check1_4_3"><span>Disabled</span></label>
					<p class="mt10">* 체크박스 class="check_box2 <u>small</u>" 사용</p>
				</div>
			</div>
			<h3>Radio Button</h3>
			<div class="flex_w1 mb20">
				<div>
					<h4>Large</h4>
					<input type="radio" id="check2_1_1" name="check2_1" class="radio_box"><label for="check2_1_1"><span>Defalt</span></label>
					<input type="radio" id="check2_1_2" name="check2_1" class="radio_box" checked><label for="check2_1_2"><span>Focuced</span></label>
					<input type="radio" id="check2_1_3" name="check2_1" class="radio_box" disabled><label for="check2_1_3"><span>Disabled</span></label>
					<p class="mt10">* 라디오체크박스 <u>class="radio_box"</u> 사용</p>
				</div>
				<div>
					<h4>Small</h4>
					<input type="radio" id="check2_2_1" name="check2_2" class="radio_box small"><label for="check2_2_1"><span>Defalt</span></label>
					<input type="radio" id="check2_2_2" name="check2_2" class="radio_box small" checked><label for="check2_2_2"><span>Focuced</span></label>
					<input type="radio" id="check2_2_3" name="check2_2" class="radio_box small" disabled><label for="check2_2_3"><span>Disabled</span></label>
					<p class="mt10">* 라디오체크박스 class="radio_box <u>small</u>" 사용</p>
				</div>
			</div>
			<h3>Toggle Button</h3>
			<div class="flex_w1">
				<div>
					<h4>Large</h4>
					<span class="togg_check"><input type="checkbox" name="check4_1" id="check4_1_1"><label for="check4_1_1"></label></span>
					<span class="togg_check"><input type="checkbox" name="check4_1" id="check4_1_2" checked><label for="check4_1_2"></label></span>
					<span class="togg_check"><input type="checkbox" name="check4_1" id="check4_1_3" disabled><label for="check4_1_3"><span>텍스트</span></label></span>
					<p class="mt10">* 체크박스 Toggle <u>class="togg_check"</u> 사용</p>
				</div>
				<div>
					<h4>Small</h4>
					<span class="togg_check small"><input type="checkbox" name="check4_2" id="check4_2_1"><label for="check4_2_1"></label></span>
					<span class="togg_check small"><input type="checkbox" name="check4_2" id="check4_2_2" checked><label for="check4_2_2"></label></span>
					<span class="togg_check small"><input type="checkbox" name="check4_2" id="check4_2_3" disabled><label for="check4_2_3"><span>텍스트</span></label></span>
					<p class="mt10">* 체크박스 Toggle class="togg_check <u>small</u>" 사용</p>
				</div>
			</div>
		</div>
	</div>
	<!-- // 체크박스 가이드 -->
	<!-- 인풋 가이드 -->
	<h2>INPUT GUIDE</h2>
	<div class="guide_wrap">
		<div class="guide_box flex_w1">
			<div>
				<h4>Large</h4>
				<p class="mb20">* class="inputBox"</p>
				<h3>입력전</h3>
				<div class="inputBox">
					<div class="input_set">
						<input class="inpt" type="text" value="" id="input-large-name1" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력중</h3>
				<div class="inputBox on"><!-- 입력중 on추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-large-name2" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력완료</h3>
				<div class="inputBox done"><!-- 입력완료시 done추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-large-name3" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력오류</h3>
				<div class="inputBox err"><!-- 입력오류 err추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-large-name4" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button><span class="err">!</span></div>
					</div>
					<p>항목에 대한 오류 메세지</p>
				</div>
				<h3>입력불가</h3>
				<div class="inputBox on disabled"><!-- 입력불가 disabled추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-large-name5" disabled placeholder="항목명">
					</div>
				</div>
			</div>
			<div>
				<h4>Small</h4>
				<p class="mb20">* class="inputBox <u>small</u>" 사용</p>
				<h3>입력전</h3>
				<div class="inputBox small">
					<div class="input_set">
						<input class="inpt" type="text" value="" id="input-small-name1" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력중</h3>
				<div class="inputBox small on"><!-- 입력중 on추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-small-name2" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력완료</h3>
				<div class="inputBox small done"><!-- 입력완료시 done추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-small-name3" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button></div>
					</div>
				</div>
				<h3>입력오류</h3>
				<div class="inputBox small err"><!-- 입력오류 err추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-small-name4" placeholder="항목명">
						<div class="rt"><button type="button" class="btnDel">삭제</button><span class="err">!</span></div>
					</div>
					<p>항목에 대한 오류 메세지</p>
				</div>
				<h3>입력불가</h3>
				<div class="inputBox small on disabled"><!-- 입력불가 disabled추가 -->
					<div class="input_set">
						<input class="inpt" type="text" value="입력내용" id="input-small-name5" disabled placeholder="항목명">
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- // 인풋 가이드-->
	<!-- 셀렉트 가이드 -->
	<h2>Select GUIDE</h2>
	<div class="guide_wrap">
		<div class="guide_box flex_w1">
			<div>
				<h4>Large</h4>
				<p class="mt40 mb20">[높이 48px] class="selectBox"</p>
				<h3 class="mb20">선택전</h3>
				<div class="selectBox">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
				<h3 class="mb20">선택중</h3>
				<div class="selectBox on">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option" style="display: block !important;">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
				<h3 class="mb20" style="margin-top:150px;">선택완료</h3>
				<div class="selectBox done">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
			</div>
			<div>
				<h4>Small</h4>
				<p class="mt45 mb20">[높이 40px]  class="selectBox"에 <u>small</u> 추가</p>
				<h3 class="mb20">선택전</h3>
				<div class="selectBox small">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
				<h3 class="mb20">선택중</h3>
				<div class="selectBox small on">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option" style="display: block !important;">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
				<h3 class="mb20" style="margin-top:150px;">선택완료</h3>
				<div class="selectBox small done">
					<input type="text" class="txtBox" value="항목명1" readonly id="select-name1">
					<ul class="option">
						<li><a href="#">항목명1</a></li>
						<li><a href="#">항목명2</a></li>
						<li><a href="#">항목명3</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- // 셀렉트 가이드 -->
	<!-- 테이블 가이드 -->
	<h2>TABLE GUIDE</h2>
	<h1 class="title">전체 게시판</h1>
	<div class="listTop">
		<p>총 게시물 <b>100</b></p>
	</div>
	<table class="listTypeA">
		<colgroup>
			<col style="width: 124px;">
			<col>
			<col style="width: 124px;">
			<col style="width: 124px;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">분류</th>
				<th scope="col">제목</th>
				<th scope="col">작성일</th>
				<th scope="col">답변여부</th>
			</tr>
		</thead>
		<tbody>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#"><em class="noti_badge">필독</em>게시판 추가 요청 문의 드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#"><em class="noti_badge">필독</em>프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#">프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
		</tbody>
		<tbody>
			<tr>
				<td>게시판</td>
				<td class="subject"><a href="#">게시판 추가 요청 문의 드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr>
				<td>게시판</td>
				<td class="subject"><a href="#">프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr>
				<td>사원</td>
				<td class="subject"><a href="#">사원 등급 관련 문의</a></td>
				<td class="date">25.06.28</td>
				<td class="ans done">답변완료</td>
			</tr>
			<tr>
				<td>사원</td>
				<td class="subject"><a href="#">사원 등급 관련 문의</a></td>
				<td class="date">25.06.28</td>
				<td class="ans done">답변완료</td>
			</tr>
		</tbody>
	</table>
	<!-- 페이지네이션 -->
	<div class="pagenation">
		<a href="#"><img src="img/ico_page_first.svg" alt="처음페이지"></a>
		<a href="#"><img src="img/ico_page_before.svg" alt="이전"></a>
		<a href="#">1</a>
		<a href="#">2</a>
		<a href="#" class="on">3</a>
		<a href="#">4</a>
		<a href="#">5</a>
		<a href="#">6</a>
		<a href="#">7</a>
		<a href="#">8</a>
		<a href="#">9</a>
		<a href="#">10</a>
		<a href="#"><img src="img/ico_page_next.svg" alt="다음"></a>
		<a href="#"><img src="img/ico_page_last.svg" alt="끝페이지"></a>
	</div>
	<!-- //페이지네이션 -->
	<!-- // 테이블 가이드 -->
</div>
</body>
</html>