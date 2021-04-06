<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-1">

	<div class="section-article-list">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title bg-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>공지사항 게시판</span>
				</div>

				<div class="flex px-4 py-2">

					<!-- 게시판별로 보기 -->
					<select class="select-board-id">
						<option value="1">공지사항</option>
						<option value="2">자유</option>
						<!-- selected="selected" : 기본적으로 이 친구로 되어있다. -->
					</select>
					<script>
						$('.section-1 .select-board-id').val(param.boardId);
						$('.section-1 .select-board-id').change(function() {
							location.href = "?boardId=" + this.value;
						});
						/* change 바뀔 때 마다 뭔가 실행된다.*/
					</script>

					<div class="flex-grow"></div>

					<a class="btn btn-sm mb-1" href="add?boardId=${ board.id }">글쓰기</a>

				</div>

				<!-- 총 게시물 수 -->
				<div class="flex items-center py-2 px-4">

					<span>총 게시물 수 : ${Util.numberFormat(totleItemsCount)}</span>

					<div class="flex-grow"></div>

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

						<input
							class="appearance-none border rounded w-full py-2 px-3 text-grey-darker"
							autofocus="autofocus" type="text" placeholder="검색어를 입력해주세요"
							name="searchKeyword" maxlength="20"
							value="${param.searchKeyword}" />
						<input
							class="btn-primary bg-gray-400 text-white font-bold py-2 px-4 rounded"
							type="submit" value="검색" />
					</form>

				</div>



				<c:forEach items="${articles}" var="article">

					<!-- 반복문 안에 임시변수를 넣어둘 수 있음! c:set -->
					<c:set var="detailUrl" value="detail?id=${article.id}" />
					<c:set var="thumbFileNo" value="${String.valueOf(1)}" />
					<c:set var="thumbFile" value="${article.extra.file__common__attachment[thumbFileNo]}" />
					<c:set var="thumbUrl" value="${thumbFile.getForPrintUrl()}" />

					<div class="px-5 py-8">

						<!-- 제목 -->
						<a class="hover:underline cursor-pointer">
							<span class="badge badge-outline mb-1">제목</span>
							<span class="line-clamp-3 ml-1"> ${article.title} </span>
						</a>

						<!-- 썸네일 -->
						<div
							class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
							<a href="${detailUrl}" class="row-span-7">
								<img class="rounded" src="${thumbUrl}" alt="">
							</a>

							<!-- 게시물 번호 -->
							<a href="${detailUrl}" class="hover:underline">
								<span class="badge badge-primary">번호</span>
								<span>${article.id}</span>
							</a>

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
							<a href="${detailUrl}" class="hover:underline">
								<span class="badge">수정날짜</span>
								<span class="text-gray-600 text-light">${article.updateDate}</span>
							</a>

							<!-- 본문 -->
							<a
								class="mt-3 hover:underline cursor-pointer col-span-1 sm:col-span-2 xl:col-span-3">
								<span class="badge badge-outline mb-1">본문</span>
								<span class="line-clamp-3 ml-1"> ${article.body} </span>
							</a>
						</div>

						<div class="plain-link-wrap gap-3 mt-4">
							<!-- 자세히 보기 -->
							<a href="${detailUrl}" class="plain-link" title="자세히 보기">
								<span>
									<i class="fas fa-info"></i>
								</span>
								<span>자세히 보기</span>
							</a>

							<!-- 수정 -->
							<a href="modify?id=${article.id}" class="plain-link">
								<span>
									<i class="fas fa-edit"></i>
								</span>
								<span>수정</span>
							</a>

							<!-- 삭제 -->
							<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
								href="doDelete?id=${article.id}" class="plain-link">
								<span>
									<i class="fas fa-trash"></i>
									<span>삭제</span>
								</span>
							</a>

						</div>
					</div>
				</c:forEach>

				<!-- 페이징 -->
				<nav class="flex justify-center py-3 rounded-md shadow-sm"
					aria-label="Pagination">

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
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>