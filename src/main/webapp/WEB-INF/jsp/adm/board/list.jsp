<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<section class="section-1">

	<div class="component-title-bar container mx-auto pt-1 pb-1 ">
		<span class="text-2xl font-bold text-center">게시판 관리</span>
	</div>

	<div class="section-board-list">

		<div class="container mx-auto mt-4 mb-4">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white mb-4">

				<div class="flex py-2 px-4">
				
				<div></div>
				
				<div class="flex-grow"></div>
				
				<a class="btn btn-sm mb-1 h-full" href="add?id=${ board.id }">글쓰기</a>
					
				</div>
				
				<div class="flex items-center px-4 py-2">
				
				<span>Total : ${Util.numberFormat(totleItemsCount)}</span>

					<div class="flex-grow"></div>

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

						<input class="appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder="검색어를 입력해주세요"
							name="searchKeyword" maxlength="20"
							value="${param.searchKeyword}" />
						<input class="btn-primary bg-gray-400 text-white font-bold py-2 px-4 rounded"
							type="submit" value="검색" />
							
					</form>
					
				</div>
			</div>

			<div class="container mx-auto">
				<div
					class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

					<c:forEach items="${boards}" var="board">

						<div class="px-4 py-8">

							<c:set var="listUrl" value="list?" />

							<div
								class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
								<a href="#" class="row-span-3 order-1">
									<img class="rounded-full"
										src="https://i.pravatar.cc/100?img=37" alt="">
								</a>

								<!-- 번호 -->
								<a href="${listUrl}" class="order-2">
									<span class="badge badge-warning">번호</span>
									<span>${board.id}</span>
								</a>

								<!-- boardName 공지사항/자유 -->
								<a href="list?boardName=${board.name}"
									class="cursor-pointer order-3">
									<span class="badge badge-info">타입</span>
									<span>${board.name}</span>
								</a>

								<!-- 등록날짜 -->
								<a href="${listUrl}" class="order-4">
									<span class="badge">등록날짜</span>
									<span class="text-gray-600 text-light">${board.regDate}</span>
								</a>

								<!-- 수정날짜 -->
								<a href="${listUrl}" class="order-5">
									<span class="badge">수정날짜</span>
									<span class="text-gray-600 text-light">${board.updateDate}</span>
								</a>

								<!-- 코드 -->
								<a href="${listUrl}" class="order-6">
									<span class="badge">코드</span>
									<span class="text-gray-600">${board.code}</span>
								</a>

								<!-- 이름 -->
								<a href="${listUrl}" class="order-7">
									<span class="badge">이름</span>
									<span class="text-gray-600">${board.name}</span>
								</a>

								<!-- 작성자 -->
								<a href="${listUrl}" class="order-8 sm:order-4 md:order-8">
									<span class="badge">작성자</span>
									<span class="text-gray-600">${board.extra__writer}</span>
								</a>
							</div>

							<div class="grid grid-item-float gap-3 mt-4">
								<a href="modify?id=${board.id}" class="text-blue-500 ">
									<span>
										<i class="fas fa-edit"></i>
										<span>수정</span>
									</span>
								</a>
								<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
									href="doDelete?id=${board.id}" class="text-blue-500 ">
									<span>
										<i class="fas fa-trash"></i>
										<span>삭제</span>
									</span>
								</a>
							</div>
						</div>
					</c:forEach>

					<!-- 페이징 -->
					<c:set var="pageBtnAddiQueryStr"
						value="&searchKeywordType=${param.searchKeywordType}&searchKeyword=${param.searchKeyword}" />
					<nav class="flex justify-center py-5 rounded-md shadow-sm"
						aria-label="Pagination">

						<!-- 시작 페이지 -->
						<c:if test="${pageMenuStart != 1}">
							<a href="?page=1"
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

							<a href="?page=${i}${pageBtnAddiQueryStr}" class="${aClassStr}">${i}</a>
						</c:forEach>

						<!-- 마지막 페이지 -->
						<c:if test="${pageMenuEnd != totalPage}">
							<a href="?page=${totlePage}"
								class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
								<span class="sr-only">Next</span>
								<i class="fas fa-chevron-right"></i>
							</a>
						</c:if>
					</nav>

				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>