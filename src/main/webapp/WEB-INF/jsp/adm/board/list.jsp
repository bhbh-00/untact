<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-board-list">

	<div
		class="container mx-auto bg-white card bordered shadow-lg p-5 mb-5 relative">
		<!-- 검색 -->
		<form class="flex">
			<select name="searchKeywordType">
				<option value="codeAndName">전체</option>
				<option value="code">코드</option>
				<option value="name">이름</option>
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
					<i class="far fa-clipboard"></i>
					<span>게시판 관리</span>
				</span>
			</div>

			<div class="flex-grow"></div>

			<div class="flex items-center text-2xl text-gray-500">

				<!-- 게시판 생성 -->
				<a href="add?boardId=${ board.id }" class="mr-2">
					<i class="fas fa-plus-circle"></i>
				</a>

			</div>
		</div>

		<div>
			<c:forEach items="${boards}" var="board">

				<div class="p-4">

					<!-- 게시물 번호 -->
					<a class="hover:underline">
						<span class="badge badge-outline">No.${board.id}</span>
					</a>

					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-2">
						
						<!-- 썸네일 -->
						<a class="row-span-7">
							<img class="w-full h-40 object-cover rounded" src="${thumbUrl}"
								alt="" onerror="${board.codeProfileFallbackImgOnErrorHtmlAttr}">
						</a>


						<!-- 코드 -->
						<a class="hover:underline cursor-pointer">
							<span class="badge badge-outline mb-1">코드</span>
							<span class="line-clamp-3 ml-1"> ${board.code} </span>
						</a>

						<!-- 이름 -->
						<a
							class="mt-3 hover:underline cursor-pointer col-span-1 sm:col-span-2 xl:col-span-3">
							<span class="badge badge-outline mb-1">이름</span>
							<span class="line-clamp-3 ml-1"> ${board.name} </span>
						</a>

						<!-- 작성자 -->
						<a class="cursor-pointer hover:underline">
							<span class="badge badge-accent">작성자</span>
							<span>${board.extra__writer}</span>
						</a>

						<!-- 등록날짜 -->
						<a class="hover:underline">
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${board.regDate}</span>
						</a>

						<!-- 수정날짜 -->
						<c:if test="${board.updateDate != board.regDate}">
							<a class="hover:underline">
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${board.updateDate}</span>
							</a>
						</c:if>

					</div>

					<div class="ml-1">
						<!-- 수정 -->
						<a href="../board/modify?id=${board.id}"
							class="text-blue-500 mr-2">
							<span>
								<i class="fas fa-edit"></i>
								<span>수정</span>
							</span>
						</a>

						<!-- 삭제 -->
						<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
							href="doDelete?id=${board.id}" class="text-red-500">
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