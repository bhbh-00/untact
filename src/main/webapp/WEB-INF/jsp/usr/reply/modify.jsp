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
				<div class="card-title bg-gray-400 text-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>댓글 수정</span>
				</div>

				<div class="px-4 py-8">
					<form onsubmit="ReplyModify_checkAndSubmit(this); return false;"
						action="doModify" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="id" value="${reply.id}" />
						<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
						
						<div class="form-control">
							<label class="label">
								<span class="label-text">댓글</span>
							</label>
							<textarea name="body" placeholder="내용을 입력해주세요."
								class="h-80 textarea textarea-bordered">${reply.body}</textarea>
						</div>

						<div class="flex flex-col my-3 md:flex-row">
							<div class="p-1 md:flex-grow">
								<div class="btns">
									<input type="submit"
										class="btn-primary bg-blue-500 text-white font-bold py-2 px-4 rounded"
										value="수정">
									<input onclick="history.back();" type="button"
										class="btn-info bg-red-600 text-white font-bold py-2 px-4 rounded"
										value="취소">
								</div>
							</div>
						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
