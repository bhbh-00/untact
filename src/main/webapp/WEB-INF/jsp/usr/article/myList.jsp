<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-article-Mylist">

	<div
		class="container mx-auto bg-white card bordered shadow-lg p-5 mb-5 relative">
		<!-- 검색 -->
		<form class="flex">
			<select name="searchKeywordType">
				<option value="titleAndBody">전체</option>
				<option value="title">제목</option>
				<option value="body">내용</option>
			</select>

			<script>
				/* 값이 있다면 */
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
					<i class="far fa-newspaper"></i>
					<span>내 게시물</span>
				</span>
				
				<!-- 게시판별로 -->
				<select class="py-2 select-board-id">
					<option value="1">공지사항</option>
					<option value="2">자유게시판</option>
				</select>
				<script>
					$('.section-article-Mylist .select-board-id').val(param.boardId);
					$('.section-article-Mylist .select-board-id').change(function() {
						location.href = '?boardId=' + this.value;
					});
				</script>
			</div>

			<div class="flex-grow"></div>

			<div class="flex items-center">
			
				<!-- 글쓰기 -->
				<a class="btn btn-ghost btn-sm mb-1"
					href="add?boardId=${ board.id }">
					<i class="fas fa-pen text-xl"></i>
				</a>
			</div>
		</div>

		<div>
			<c:forEach items="${articles}" var="article">

				<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
				<c:set var="detailUrl" value="detail?id=${article.id}" />
				<c:set var="thumbFileNo" value="${String.valueOf(1)}" />
				<c:set var="thumbFile"
					value="${article.extra.file__common__attachment[thumbFileNo]}" />
				<c:set var="thumbUrl" value="${thumbFile.getForPrintUrl()}" />

				<div class="p-4">

					<!-- 게시판 번호 -->
					<c:if test="${board.id == 1}">
						<a href="${detailUrl}" class="cursor-pointer hover:underline">
							<span class="badge badge-info">${article.extra__boardName}</span>
						</a>
					</c:if>

					<c:if test="${board.id == 2}">
						<a href="${detailUrl}" class="cursor-pointer hover:underline">
							<span class="badge badge-warning">${article.extra__boardName}</span>
						</a>
					</c:if>

					<!-- 게시물 번호 -->
					<a href="${detailUrl}" class="hover:underline">
						<span class="text-base">No.${article.id}</span>
					</a>

					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
						<!-- 썸네일 -->
						<a href="${detailUrl}" class="row-span-7">
							<img class="w-full h-40 object-cover rounded" src="${thumbUrl}"
								alt=""
								onerror="${article.writerProfileFallbackImgOnErrorHtmlAttr}">
						</a>


						<!-- 제목 -->
						<a class="hover:underline cursor-pointer">
							<span class="badge badge-outline mb-1">제목</span>
							<span class="line-clamp-3 ml-1"> ${article.title} </span>
						</a>

						<!-- 본문 -->
						<a
							class="mt-3 hover:underline cursor-pointer col-span-1 sm:col-span-2 xl:col-span-3">
							<span class="badge badge-outline mb-1">본문</span>
							<span class="line-clamp-3 ml-1"> ${article.body} </span>
						</a>

						<!-- 작성자 -->
						<a href="${detailUrl}" class="cursor-pointer hover:underline">
							<span class="badge badge-accent">작성자</span>
							<span>${article.extra__writer}</span>
						</a>

						<!-- 등록날짜 -->
						<a href="${detailUrl}" class="hover:underline">
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${article.regDate}</span>
						</a>

						<!-- 수정날짜 -->
						<c:if test="${article.updateDate != article.regDate}">
							<a href="${detailUrl}" class="hover:underline">
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${article.updateDate}</span>
							</a>
						</c:if>

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