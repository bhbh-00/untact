<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<!-- lodash -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>

<script>
	const BoardAdd_checkAndSubmitDone = false;

	let BoardAdd__validCode = '';

	//조건 체크 함수 ajax
	function AddForm__checkCodeDup(obj) {

		const form = $('.formCode').get(0);

		form.code.value = form.code.value.trim();

		if (form.code.value.length == 0) {
			return;
		}

		$.get('getCodeDup', {
			code : form.code.value
		}, function(data) {

			let colorClass = 'text-green-500';

			if (data.fail) {
				colorClass = 'text-red-500';
			}

			$('.CodeInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");

			if (data.fail) {
				form.code.focus();
			}

			else {
				BoardAdd__validCode = data.body.code;
			}

		},

		'json'

		);

	}

	function BoardAdd__checkAndSubmit(form) {
		// 이게 끝나면 폼 전송완료

		// 중복처리 안되게 하는
		if (BoardAdd_checkAndSubmitDone) {
			return;
		}

		// 기본적인 처리
		form.code.value = form.code.value.trim();
		if (form.code.value.length == 0) {
			alert('코드을 입력해주세요.');
			form.code.focus();
			return false;
		}

		if (form.code.value != BoardAdd__validCode) {
			alert('코드 중복체크를 해주세요.');
			form.code.focus();

			return;
		}

		form.name.value = form.name.value.trim();

		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();

			return;
		}

		if (form.name.value != BoardAdd__validName) {
			alert('이름 중복체크를 해주세요.');
			form.name.focus();

			return;
		}

		form.submit();
		BoardAdd_checkAndSubmitDone = true;
	}

	$(function() {
		$('.inputCode').change(function() {
			AddForm__checkNameDup();
		});

		$('.inputCode').keyup(_.debounce(AddForm__checkCodeDup, 1000));

	});
</script>

<section class="section-board-add">

	<div class="section-board-add">
		<div class="container mx-auto mt-4 mb-5">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>게시판 작성</span>
				</div>

				<div class="px-4 py-8">

					<form class="formCode" action="doAdd" method="POST"
						onsubmit="BoardAdd__checkAndSubmit(this); return false;">
						
						<input type="hidden" name="memberId" value="${loginedMember.id}" />

						<!-- 코드 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">코드</span>
							</label>
							<input type="text" name="code" placeholder="코드을 입력해주세요."
								autofocus="autofocus" class="inputCode input input-bordered">
						</div>

						<!-- 중복확인 -->
						<div class="form-control ml-1 mt-1">
							<div class="CodeInputMsg"></div>
						</div>


						<!-- 이름 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">이름</span>
							</label>
							<input type="text" name="name" placeholder="이름을 입력해주세요."
								autofocus="autofocus" class="input input-bordered">
						</div>

						<div class="mt-2">
							<button class="btn btn-ghost btn-sm mb-1 text-blue-500"
								type="submit">
								<i class="fas fa-edit mr-1"></i>
								<span>작성</span>
							</button>

							<a href="list?" class="btn btn-ghost btn-sm mb-1" title="리스트 보기">
								<span>
									<i class="fas fa-list"></i>
								</span>
								&nbsp;
								<span>리스트</span>
							</a>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>