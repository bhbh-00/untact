<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div class="flex items-center mb-5">
			<span class="text-3xl text-black font-bold">게시판 관리</span>
		</div>
		<hr>

		<!-- 총 게시물 수 -->
		<div class="flex items-center my-3">
			<span>총 게시물 수 : ${Util.numberFormat(totleItemsCount)}</span>

			<div class="flex-grow"></div>

			<!-- 검색 -->
			<form class="flex">
				<select name="searchKeywordType">
					<option value="codeAndName">전체</option>
					<option value="code">코드</option>
					<option value="name">이름</option>
				</select>

				<script>
					if (param.searchKeywordType) {
						$('.section-1 select[name="searchKeywordType"]').val(
								param.searchKeywordType);
					}
				</script>

				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
					autofocus="autofocus" type="text" placeholder="검색어를 입력해주세요"
					name="searchKeyword" maxlength="20" value="${param.searchKeyword}" />
				<input
					class="btn-primary bg-gray-400 text-white font-bold py-2 px-4 rounded"
					type="submit" value="검색" />

			</form>
		</div>
		<hr>

		<div>
			<c:forEach items="${boards}" var="board">

				<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
				<c:set var="detailUrl" value="detail?id=${board.id}" />

				<div class="flex justify-between items-center mt-3">

					<!-- 게시판 번호 -->
					<a href="${detailUrl}" class="font-bold mr-5">
						<span
							class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-gray-500 text-white">NO.
							${board.id}</span>
						<span></span>
					</a>

					<!-- 등록날짜 -->
					<span class="font-light text-gray-600">${board.regDate}</span>

					<div class="flex-grow"></div>

					<!-- boardName 공지사항/자유-->
					<a href="list?boardName=${board.name}"
						class="px-2 py-1 bg-gray-600 text-gray-100 font-bold rounded hover:bg-gray-500">
						${board.name} </a>
				</div>

				<!-- 코드 -->
				<div class="mt-2">
					<span
						class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-gray-500 text-white">코드</span>
					<span>${board.code}</span>
				</div>

				<!-- 이름 -->
				<div class="mt-2">
					<span
						class="inline-flex justify-center items-center px-3 py-1 rounded-full bg-gray-500 text-white">이름</span>
					<span>${board.name}</span>
				</div>

				<div class="flex items-center mt-4 mb-4">
					<!-- 자세히 보기 -->

					<a href="${detailUrl}" class="text-gray-700 mr-2 hover:underline">
						<span>
							<i class="fas fa-info"></i>
							<span class="hidden sm:inline">자세히 보기</span>
						</span>
					</a>

					<!-- 수정 -->
					<a href="modify?id=${board.id}" class="text-blue-500 mr-2 hover:underline">
						<span>
							<i class="fas fa-edit"></i>
							<span class="hidden sm:inline">수정</span>
						</span>
					</a>

					<!-- 삭제 -->
					<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;" href="doDelete?id=${board.id}" class="text-red-500 hover:underline">
						<span>
							<i class="fas fa-trash"></i>
							<span class="hidden sm:inline">삭제</span>
						</span>
					</a>

					<div class="flex-grow"></div>

					<!-- 작성자 -->
					<div>
						<a class="flex items-center">
							<img
								src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=731&amp;q=80"
								alt="avatar" class="mx-4 w-10 h-10 object-cover rounded-full">
							<span class="text-gray-700 font-bold hover:underline">${board.extra__writer}</span>
						</a>
					</div>
				</div>
				<hr>
			</c:forEach>
		</div>

		<!-- 페이징 -->
		<c:set var="pageBtnAddiQueryStr" value="&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
		<nav class="flex justify-center py-5 rounded-md shadow-sm" aria-label="Pagination">

			<!-- 시작 페이지 -->
			<c:if test="${pageMenuStart != 1}">
				<a href="?page=1" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
					<span class="sr-only">Previous</span>
					<i class="fas fa-chevron-left"></i>
				</a>
			</c:if>

			<!-- 페이지 번호 -->
			<c:forEach var="i" begin="${pageMenuStrat}" end="${pageMenuEnd}">
				<c:set var="aClassStr" value="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium" />

				<c:set var="aClassStr" value="${aClassStr} active" />
				
				<!-- 현재 페이지 -->	
				<c:if test="${i == page}">
					<c:set var="aClassStr"
						value="${aClassStr} text-red-700 hover:bg-red-50" />
				</c:if>

				<!-- 현재 페이지가 아닌 -->
				<c:if test="${i != page}">
					<c:set var="aClassStr" value="${aClassStr} text-gray-700 hover:bg-gray-50" />
				</c:if>

				<a href="?page=${i}${pageBtnAddiQueryStr}" class="${aClassStr}">${i}</a>
			</c:forEach>

			<!-- 마지막 페이지 -->
			<c:if test="${pageMenuEnd != totalPage}">
				<a href="?page=${totlePage}" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
					<span class="sr-only">Next</span>
					<i class="fas fa-chevron-right"></i>
				</a>
			</c:if>
		</nav>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>