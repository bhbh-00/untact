<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<c:set var="fileInputMaxCount" value="10" />

<section class="section-1">

	<div class="section-article-detail">

		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title bg-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>${article.id}번 게시물</span>
				</div>

				<div class="p-5">

					<div class="flex">
						<div class="flex-grow"></div>
						<span>
							<span class="text-gray-600">Likes :</span>
							<span class="text-gray-400 text-light">120k</span>
						</span>
					</div>

					<!-- 제목 -->
					<div class="mt-7">
						<span class="badge badge-outline">제목</span>
						<div class="break-all mt-1 ml-1">${article.title}</div>
					</div>

					<!-- 번호 -->
					<div
						class="mt-3 grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3">
						<div>
							<span class="badge badge-primary">번호</span>
							<span>${article.id}</span>
						</div>

						<!-- 작성자 -->
						<div>
							<span class="badge badge-accent">작성자</span>
							<span>${article.extra__writer}</span>
						</div>

						<!-- 등록날짜 -->
						<div>
							<span class="badge">등록날짜</span>
							<span class="text-gray-600 text-light">${article.regDate}</span>
						</div>

						<!-- 수정날짜 -->
						<div>
							<span class="badge">수정날짜</span>
							<span class="text-gray-600 text-light">${article.updateDate}</span>
						</div>
					</div>

					<!-- 본문 -->
					<div class="mt-6">
						<span class="badge badge-outline">본문</span>
						<div class="mt-3">
							<c:forEach begin="1" end="${fileInputMaxCount}" var="inputNo">
								<c:set var="fileNo" value="${String.valueOf(inputNo)}" />
								<c:set var="file"
									value="${article.extra.file__common__attachment[fileNo]}" />
									${file.mediaHtml}
							</c:forEach>
						</div>
						<div class="mt-3 break-all ml-1">${article.body}</div>
					</div>

					<div class="flex plain-link-wrap gap-3 mt-4">

						<div class="flex"></div>

						<div class="flex-grow"></div>

						<c:choose>
							<c:when test="${article.memberId == loginMemberId}">
								
								<!-- 좋아요 -->
								<a href="#" class="flex plain-link">
									<span class="text-pink-500">
										<i class="far fa-heart"></i>
										<span>좋아요</span>
									</span>
								</a>
								
								<!-- 수정 -->
								<a href="modify?id=${article.id}" class="flex plain-link">
									<span>
										<i class="fas fa-edit"></i>
									</span>
									<span>수정</span>
								</a>
								
								<!-- 삭제 -->
								<a onclick="if ( !confirm('삭제하시겠습니까?') ) return false;"
									href="doDelete?id=${article.id}" class="flex plain-link">
									<span class="text-red-500">
										<i class="fas fa-trash"></i>
										<span>삭제</span>
									</span>
								</a>
								
							</c:when>
							<c:otherwise>
								<!-- 좋아요 -->
								<a href="#" class="flex plain-link">
									<span class="text-pink-500">
										<i class="far fa-heart"></i>
										<span>좋아요</span>
									</span>
								</a>
							</c:otherwise>
						</c:choose>

					</div>
				</div>
			</div>
		</div>
	</div>


</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>