<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.sbs.untact.util.Util"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>

<script>
	const BoardModify_checkAndSubmitDone = false;

	let ModifyForm__validName = '';

	//중복체크 함수 ajax
	function ModifyForm__checkNameDup(obj) {

		const form = $('.formName').get(0);

		form.name.value = form.name.value.trim();

		if (form.name.value.length == 0) {
			return;
		}

		$.get('getNameDup', {
			name : form.name.value
		}, function(data) {

			let colorClass = 'text-green-500';

			if (data.fail) {
				colorClass = 'text-red-500';
			}

			$('.NameInputMsg').html("<span class='" + colorClass + "'>" + data.msg + "</span>");

			if (data.fail) {
				form.name.focus();
			}

			else {
				ModifyForm__validName = data.body.name;
			}

		},

		'json'

		);

	}

	function BoardModify_checkAndSubmit(form) {

		if (BoardModify_checkAndSubmitDone) {
			return;
		}

		form.name.value = form.name.value.trim();

		if (form.name.value.length == 0) {
			alert('이름을 입력해주세요.');
			form.name.focus();

			return;
		}

		if (form.name.value != ModifyForm__validName) {
			alert('이름 중복체크를 해주세요.');
			form.name.focus();

			return;
		}

		form.submit();
		BoardModify_checkAndSubmitDone = true;
	}

	$(function() {
		$('.inputName').change(function() {
			ModifyForm__checkNameDup();
		});

		$('.inputName').keyup(_.debounce(ModifyForm__checkNameDup, 1000));

	});
</script>

<section class="section-1">

	<div class="section-board-modify">
		<div class="container mx-auto">
			<div
				class="card bordered shadow-lg item-bt-1-not-last-child bg-white">

				<div class="card-title">
					<a href="javascript:history.back();" class="cursor-pointer">
						<i class="fas fa-chevron-left"></i>
					</a>
					<span>게시판 수정</span>
				</div>

				<div class="px-4 py-8">

					<form class="formName grid form-type-1"
						onsubmit="BoardModify_checkAndSubmit(this); return false;"
						action="doModify" method="POST" enctype="multipart/form-data">
						<input type="hidden" name="id" value="${board.id}" />
						<input type="hidden" name="redirectUrl"
							value="${param.redirectUrl}" />

						<!-- 번호 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 번호 </label>
							<div class="plain-text">${board.id}</div>
						</div>

						<!-- 등록날짜 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 등록날짜 </label>
							<div class="plain-text">${board.regDate}</div>
						</div>

						<!-- 수정날짜 -->
						<c:if test="${board.updateDate != board.regDate}">
							<div class="form-control">
								<label class="cursor-pointer label"> 수정날짜 </label>
								<div class="plain-text">${board.updateDate}</div>
							</div>
						</c:if>
						
						<!-- 코드 -->
						<div class="form-control">
							<label class="cursor-pointer label"> 코드 </label>
							<div class="plain-text">${board.code}</div>
						</div>

						<!-- 이름 -->
						<div class="form-control">
							<label class="label">
								<span class="label-text">이름</span>
							</label>
							<input type="text" name="name" placeholder="이름"
								class="inputName input input-bordered" maxlength="20"
								value="${board.name}">
						</div>

						<!-- 중복확인 -->
						<div class="form-control">
							<div class="NameInputMsg"></div>
						</div>

						<div>
							<button class="btn btn-ghost btn-sm mb-1 text-blue-500"
								type="submit">
								<i class="fas fa-edit mr-1"></i>
								<span>수정</span>
							</button>

							<button onclick="history.back();"
								class="btn btn-ghost btn-sm mb-1 text-red-500">
								<i class="fas fa-trash mr-1"></i>
								<span>취소</span>
							</button>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>

</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>
