<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<%@ page import="com.sbs.untact.util.Util"%>

<script>
	ReplyModify_checkAndSubmitDone = false;

	function ReplyModify_checkAndSubmit(form) {

		if (ReplyModify_checkAndSubmitDone) {
			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('댓글을 입력해주세요.');
			form.body.focus();

			return;
		}

		form.submit();
		ReplyModify_checkAndSubmitDone = true;
	}
</script>

<section class="section-1">

	<div class="section-reply-modify">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="px-4 py-4">
					<form onsubmit="ReplyModify_checkAndSubmit(this); return false;"
						action="doModify" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="id" value="${reply.id}" />
						<input type="hidden" name="redirectUrl"
							value="/usr/article/detail?id=${article.id}" />

						<div class="form-control">
							<label class="label">
								<span class="label-text">댓글</span>
							</label>
							<textarea name="body" placeholder="내용을 입력해주세요."
								class="h-80 textarea textarea-bordered">${reply.body}</textarea>
						</div>

						<div class="flex">

							<div class="flex-grow"></div>

							<div class="mt-3">
								<button type="submit" class="btn btn-ghost btn-sm text-blue-600"
									value="수정">
									<i class="fas fa-edit"></i>
									<span class="hidden md:block">수정</span>
								</button>
								<button onclick="history.back();" type="button"
									class="btn btn-ghost btn-sm text-red-600" value="취소">
									<i class="fas fa-trash"></i>
									<span class="">삭제</span>
								</button>

							</div>

						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
