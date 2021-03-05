<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>


<!-- 첨부파일 갯수 조절 -->
<c:set var="fileInputMaxCount" value="5" />
<script>
	ArticleModify__fileInputMaxCount = parseInt("${fileInputMaxCount}");
</script>

<script>
	ArticleModify__submited = false;
	function ArticleModify__checkAndSubmit(form) {
		// 중복처리 안되게 하는
		if (ArticleModify__submited) {
			alert('처리중입니다.');
			return;
		}

		// 기본적인 처리
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

		// 파일 용량 처리
		var maxSizeMb = 50; // 용량
		var maxSize = maxSizeMb * 1024 * 1024; // 50MB

		for (let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++) {
			const input = form[file__article__0__common__attachment__" + inputNo];
			// form.file__article__0__common__attachment__1.files[0].size -> 사이즈 구하는 식
			
			if (input.value) {
				if (input.size > maxSize) {
					alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
					input.focus();

					return;
				}
			}

		}

		const startSubmitForm = function(data) {
			let genFileIdsStr = '';

			if (data && data.body && data.body.genFileIdsStr) {
				form.genFileIdsStr.value = data.body.genFileIdsStr;
			}

			form.genFileIdsStr.value = genFileIdsStr;

			for ( let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++ ) {
				const input = form["file__article__0__common__attachment__" + inputNo];
				input.value = '';
			}
			

			form.submit();
		};

		const startUploadFiles = function(onSuccess) {
			var needToUpload = false;
			
			for ( let inputNo = 1; inputNo <= ArticleModify__fileInputMaxCount; inputNo++ ) {
				const input = form["file__article__0__common__attachment__" + inputNo];
			
				if ( input.value.length > 0 ) {
					needToUpload = true;
					break;
				}
			}
			
			
			if (needToUpload == false) {
				onSuccess();
				return;
			}
			
			var fileUploadFormData = new FormData(form);

			// 파일 업로드 할게 있다. -실행-> ajax
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

		// 폼 전송 시작
		ArticleModify__submited = true;

		startUploadFiles(startSubmitForm);
	}
</script>

<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<span class="text-3xl text-black font-bold">게시물 추가</span>
		<form onsubmit="ArticleModify__checkAndSubmit(this); return false;" action="doModify" method="POST" enctype="multipart/form-data">
			<input type="hidden" name="genFileIdsStr" value="" />
			<input type="hidden" name="id" value="${ article.id }" />

			<div class="form-row flex flex-col lg:flex-row mt-8">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>제목</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<input value="${article.title}" class="shadow appearance-none border rounded w-full py-2 px-3 text-grey-darker"
						autofocus="autofocus" type="text" placeholder="제목을 입력해주세요." name="title" maxlength="20" />
				</div>
			</div>

			<div class="form-row flex flex-col lg:flex-row">
				<div class="lg:flex lg:items-center lg:w-28">
					<span>내용</span>
				</div>
				<div class="p-1 lg:flex-grow">
					<textarea name="body" class="shadow appearance-none border border-red rounded w-full py-2 px-3 text-grey-darker mb-3"
						autofocus="autofocus" placeholder="내용을 입력해주세요.">${article.body}</textarea>
				</div>
			</div>

			<c:forEach begin="1" end="${fileInputMaxCount}" var="inputNo">
			<c:set var="fileNo" value="${String.valueOf(inputNo)}" />
                <c:set var="file" value="${article.extra.file__common__attachment[fileNo]}" />
				<div class="form-row flex flex-col lg:flex-row">
					<div class="lg:flex lg:items-center lg:w-28">
						<span>첨부파일 ${inputNo}</span>
					</div>
					<div class="lg:flex-grow">
					
					<c:if test="${file != null && file.fileExtTypeCode == 'img'}">
					 <div class="img-box img-box-auto">
                                <img src="${file.forPrintUrl}">
                            </div>
                        </c:if>
                        
						<input type="file" name="file__article__0__common__attachment__${inputNo}" class="form-row-input w-full rounded-sm" />
					</div>
				</div>
			</c:forEach>

			<div class="form-row flex flex-col lg:flex-row">
				<div class="btus">
					<input type="submit"
						class="btn-primary bg-blue-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
						value="작성" />
					<input type="button"
						class="btn-info bg-red-500 hover:bg-blue-dark text-white font-bold py-1 px-4 rounded"
						value="취소" onclick="history.back();" />
				</div>
			</div>
		</form>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
