<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	param.boardId = parseInt("${board.id}");
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<div class="flex items-center mb-5">
			<span class="text-3xl text-black font-bold">게시물 상세보기</span>

			<div class="flex-grow"></div>

			<a
				class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-1 px-2 rounded mb-5"
				href="add?boardId=${ board.id }">글쓰기</a>
		</div>
		<hr>

		<div>
			<c:set var="detailUrl" value="detail?id=${article.id}" />
			<c:set var="thumbFileNo" value="${String.valueOf(1)}" />
			<c:set var="thumbFile"
				value="${article.extra.file__common__attachment[thumbFileNo]}" />
			<c:set var="thumbUrl" value="${thumbFile.getForPrintUrl()}" />

			<div class="flex justify-between items-center mt-3">

				<!-- 게시물 번호 -->
				<a href="${detailUrl}" class="font-bold mr-5">NO. ${article.id}</a>

				<!-- 등록날짜 -->
				<a class="font-light text-gray-600">${article.regDate}</a>

				<div class="flex-grow"></div>

				<!-- 작성자 -->
				<div>
					<a class="flex items-center">
						<img
							src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=731&amp;q=80"
							alt="avatar" class="mx-4 w-10 h-10 object-cover rounded-full">
						<span class="text-gray-700 font-bold hover:underline">${article.extra__writer}</span>
					</a>
				</div>
			</div>

			<!-- 제목 -->
			<div class="mt-2">
				<span class="text-2xl text-gray-700 font-bold">${article.title}</span>
			</div>

			<!-- 내용 -->
			<div class="mt-2">
				<span class="text-gray-700 font-bold">${article.body}</span>
			</div>

			<!-- 첨부파일 -->
			<div class="mt-2">
				<c:if test="${thumbUrl != null}">
					<a class="block" href="${detailUrl}">
						<img class="max-w-sm" src="${thumbUrl}" alt="" />
					</a>
				</c:if>
			</div>


			<div class="flex flex-col mt-7 md:flex-row">
				<div class="p-1 md:flex-grow">
					<!-- 수정 -->
					<a href="modify?id=${article.id}"
						class="btn-primary bg-blue-400 text-white font-bold py-2 px-4 rounded mr-">수정</a>

					<!-- 삭제 -->
					<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
						href="doDelete?id=${article.id}"
						class="btn-info bg-red-600 text-white font-bold py-2 px-4 rounded">삭제</a>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>