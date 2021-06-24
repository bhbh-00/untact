<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-member-list">

	<div
		class="container mx-auto bg-white card bordered shadow-lg p-5 mb-5 relative">
		<!-- 검색 -->
		<form class="flex">
			<select name="searchKeywordType">
				<option value="loginIdAndNameAndNicknameAndCellphoneNoAndEmail">전체</option>
				<option value="loginId">아이디</option>
				<option value="name">이름</option>
				<option value="nickname">닉네임</option>
				<option value="cellphoneNo">핸드폰번호</option>
				<option value="email">이메일</option>
			</select>

			<script>
				if (param.searchKeywordType) {
					$('.section-1 select[name="searchKeywordType"]').val(param.searchKeywordType);
				}
			</script>

			<input autofocus="autofocus" type="text" style="border-radius: 25px"
				placeholder="검색어를 입력해주세요" name="searchKeyword" maxlength="20"
				autocomplete="off" value="${param.searchKeyword}"
				class="w-full py-2 pl-4 pr-10 text-sm bg-gray-100 border border-transparent appearance-none rounded-tg placeholder-gray-400
								focus:bg-white focus:outline-none focus:border-blue-500 focus:text-gray-900 focus:shadow-outline-blue" />

			<button type="submit" class="absolute top-7 right-9">
				<i class="fas fa-pen"></i>
			</button>

		</form>
	</div>

	<div
		class="container mx-auto bg-white card bordered shadow-lg px-5 pt-5 pb-3">

		<div class="flex">

			<div class="items-center ml-2">

				<span class="text-xl font-bold">
					<i class="fas fa-user"></i>
					<span>회원 관리</span>
				</span>
			</div>

			<div class="flex-grow"></div>

			<!-- 권한별로 보기 -->
			<div class="flex items-center">
				<!-- 권한별로 보기 -->
				<select class="select-auth-level mr-4 py-1">
					<option value="">권한전체</option>
					<option value="3">일반회원</option>
					<option value="7">관리자</option>
					<!-- selected="selected" : 기본적으로 이 친구로 되어있다. -->
				</select>
				<script>
					if (!param.authLevel) {
						param.authLevel = '';
					}
					$('.section-member-list .select-auth-level').val(param.authLevel);
					$('.section-member-list .select-auth-level').change(function() {
						location.href = "?authLevel=" + this.value;
					});
					/* change 바뀔 때 마다 뭔가 실행된다.*/
				</script>
			</div>
		</div>

		<div>
			<c:forEach items="${members}" var="member">

				<div class="p-4">

					<!-- 회원타입 -->
					<a href="list?authLevel=${member.authLevel}"
						class="cursor-pointer hover:underline">
						<span class="badge ${member.authLevelNameColor}">${member.authLevelName}</span>
					</a>

					<!-- 번호 -->
					<a href="#" class="hover:underline">
						<span class="text-base">No.${member.id}</span>
					</a>

					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-2">
						<!-- 프로필 -->
						<a href="#" class="row-span-7">
							<img class="w-40 h-40 object-cover rounded-full"
								onerror="${member.profileFallbackImgOnErrorHtmlAttr}"
								src="${member.profileImgUrl}">
						</a>

						<!-- 아이디 -->
						<a href="#" class="cursor-pointer hover:underline">
							<span class="badge badge-outline mb-1">아이디</span>
							<span>${member.loginId}</span>
						</a>

						<!-- 이름 -->
						<a href="#" class="cursor-pointer hover:underline">
							<span class="badge badge-outline mb-1">이름</span>
							<span>${member.name}</span>
						</a>

						<!-- 닉네임 -->
						<a href="#" class="cursor-pointer hover:underline">
							<span class="badge badge-outline mb-1">닉네임</span>
							<span>${member.nickname}</span>
						</a>

						<!-- 핸드폰번호 -->
						<a href="#" class="cursor-pointer hover:underline">
							<span class="badge badge-outline mb-1">핸드폰번호</span>
							<span>${member.cellphoneNo}</span>
						</a>

						<!-- 이메일 -->
						<a href="#" class="cursor-pointer hover:underline">
							<span class="badge badge-outline mb-1">닉네임</span>
							<span>${member.email}</span>
						</a>

						<!--  -->
						<a href="#">
							<span></span>
							<span></span>
						</a>

						<!-- 등록날짜 -->
						<a href="#" class="hover:underline">
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${member.regDate}</span>
						</a>

						<!-- 수정날짜 -->
						<c:if test="${member.updateDate != member.regDate}">
							<a href="#" class="hover:underline">
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${member.updateDate}</span>
							</a>
						</c:if>

					</div>

					<div class="grid grid-item-float gap-3 mt-4">
						<!-- 수정 -->
						<a href="modify?id=${member.id}" class="text-blue-500">
							<span>
								<i class="fas fa-edit"></i>
								<span>수정</span>
							</span>
						</a>

						<!-- 삭제 -->
						<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
							href="doDelete?id=${member.id}" class="text-red-500">
							<span>
								<i class="fas fa-trash"></i>
								<span>삭제</span>
							</span>
						</a>
					</div>

				</div>
				<hr>
			</c:forEach>
		</div>

		<!-- 페이징 -->
		<nav class="flex justify-center pt-3" aria-label="Pagination">

			<!-- 시작 페이지 -->
			<!-- 내가 보고 있는 페이지 챕터가 첫번째이면 < 표시 안보이게 -->
			<c:if test="${pageMenuStart != 1}">
				<a href="${Util.getNewUrl(requestUrl, 'page', 1)}"
					class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
					<span class="sr-only">Previous</span>
					<i class="fas fa-chevron-left"></i>
				</a>
			</c:if>

			<!-- 페이지 번호 -->
			<c:forEach var="i" begin="${pageMenuStrat}" end="${pageMenuEnd}">
				<c:set var="aClassStr"
					value="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium" />

				<c:set var="aClassStr" value="${aClassStr} active" />

				<!-- 현재 페이지 -->
				<c:if test="${i == page}">
					<c:set var="aClassStr"
						value="${aClassStr} text-red-700 hover:bg-red-50" />
				</c:if>

				<!-- 현재 페이지가 아닌 -->
				<c:if test="${i != page}">
					<c:set var="aClassStr"
						value="${aClassStr} text-gray-700 hover:bg-gray-50" />
				</c:if>

				<a href="${Util.getNewUrl(requestUrl, 'page', i)}"
					class="${aClassStr}">${i}</a>
			</c:forEach>

			<!-- 마지막 페이지 -->
			<!-- 내가 보고 있는 페이지 챕터가 마지막이면 > 표시 안보이게 -->
			<c:if test="${pageMenuEnd != totalPage}">
				<a href="${Util.getNewUrl(requestUrl, 'page', totalPage)}"
					class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
					<span class="sr-only">Next</span>
					<i class="fas fa-chevron-right"></i>
				</a>
			</c:if>
		</nav>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>