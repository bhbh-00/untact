<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>
<%@ page import="com.sbs.untact.util.Util"%>


<!-- 첨부파일 갯수 조절 -->
<c:set var="fileInputMaxCount" value="10" />
<script>
	ArticleModify__fileInputMaxCount = parseInt("${fileInputMaxCount}");
	const articleId = parseInt("${article.id}");
</script>

<script>
	ArticleModify__submited = false;
	function ArticleModify__checkAndSubmit(form) {
		if (ArticleModify__submited) {
			alert('처리중입니다.');
			return;
		}

		form.title.value = form.title.value.trim();
		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return false;
		}
		form.body.value = form.body.value.trim();
		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}
		var maxSizeMb = 50;
		var maxSize = maxSizeMb * 1024 * 1024;
		for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
			const input = form["file__article__" + articleId + "__common__attachment__" + inputNo];

			if (input.value) {
				if (input.files[0].size > maxSize) {
					alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
					input.focus();

					return;
				}
			}
		}
		const startSubmitForm = function(data) {
			if (data && data.body && data.body.genFileIdsStr) {
				form.genFileIdsStr.value = data.body.genFileIdsStr;
			}

			for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
				const input = form["file__article__" + articleId + "__common__attachment__" + inputNo];
				input.value = '';
			}
			for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
				const input = form["deleteFile__article__" + articleId + "__common__attachment__" + inputNo];
				if (input) {
					input.checked = false;
				}
			}

			form.submit();
		};
		const startUploadFiles = function(onSuccess) {
			var needToUpload = false;
			for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
				const input = form["file__article__" + articleId + "__common__attachment__" + inputNo];
				if (input.value.length > 0) {
					needToUpload = true;
					break;
				}
			}
			if (needToUpload == false) {
				for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
					const input = form["deleteFile__article__" + articleId + "__common__attachment__" + inputNo];
					if (input && input.checked) {
						needToUpload = true;
						break;
					}
				}
			}

			if (needToUpload == false) {
				onSuccess();
				return;
			}

			var fileUploadFormData = new FormData(form);

			$.ajax({
				url : '/common/genFile/doUpload',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType : "json",
				type : 'POST',
				success : onSuccess
			});
		}
		ArticleModify__submited = true;
		startUploadFiles(startSubmitForm);
	}
</script>

<section class="section-1">

	<div class="section-article-write">
		<div class="container mx-auto">
			<div class="card bordered shadow-lg item-bt-1-not-last-child bg-white">
				<div class="card-title bg-gray-400 text-white">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>게시물 수정</span>
				</div>

				<div class="px-4 py-8">
					<form onsubmit="ArticleModify__checkAndSubmit(this); return false;"
						action="doModify" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="genFileIdsStr" value="" />
						<input type="hidden" name="id" value="${article.id}" />
						
						<div class="form-control">
							<label class="label">
								<span class="label-text">제목</span>
							</label>
							<input value="${article.title}" name="title" type="text" placeholder="제목 입력해주세요."
								class="input input-bordered">
						</div>
						
						<div class="form-control">
							<label class="label">
								<span class="label-text">본문</span>
							</label>
							<textarea name="body" placeholder="내용을 입력해주세요."
								class="h-80 textarea textarea-bordered">${article.body}</textarea>
						</div>
						
						<c:forEach begin="1" end="${fileInputMaxCount}" var="inputNo">
						
							<c:set var="fileNo" value="${String.valueOf(inputNo)}" />
							<c:set var="file" value="${article.extra.file__common__attachment[fileNo]}" />
							
							<div class="form-control">
								<label class="label">
									<span class="label-text">본문 이미지 ${inputNo}</span>
								</label>
							
								<div>
									<input class="thumb-available" type="file"
										name="file__article__${article.id}__common__attachment__${inputNo}"
										class="form-row-input w-full rounded-sm" placeholder="본문 이미지 ${inputNo}"/>
									<c:if test="${file != null}">
										<div>
											<a href="${file.downloadUrl}" target="_blank"
												class="text-blue-500 hover:underline" href="#">${file.originFileName}</a>
											( ${Util.numberFormat(file.fileSize)} Byte )
										</div>
										<div>
											<label>
												<input
													onclick="$(this).closest('.input-file-wrap').find(' > input[type=file]').val('')"
													type="checkbox"
													name="deleteFile__article__${article.id}__common__attachment__${fileNo}"
													value="Y" />
												<span>삭제</span>
											</label>
										</div>
										<c:if test="${file.fileExtTypeCode == 'img'}">
											<div class="img-box img-box-auto">
												<a class="inline-block" href="${file.forPrintUrl}"
													target="_blank" title="자세히 보기">
													<img class="max-w-sm" src="${file.forPrintUrl}">
												</a>
											</div>
										</c:if>
									</c:if>
								</div>
							</div>
						</c:forEach>

						<div class="flex flex-col my-3 md:flex-row">
							<div class="p-1 md:flex-grow">
								<div class="btns">
									<input type="submit" class="btn-primary bg-blue-500 text-white font-bold py-2 px-4 rounded"
										value="수정">
									<input onclick="history.back();" type="button" class="btn-info bg-red-600 text-white font-bold py-2 px-4 rounded"
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
