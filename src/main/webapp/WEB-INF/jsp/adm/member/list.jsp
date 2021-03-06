<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="../part/mainLayoutHead.jspf"%>


<section class="section-1">
	<div class="bg-white shadow-md rounded container mx-auto p-8 mt-8">
		<span class="text-3xl text-black font-bold">멤버 관리</span>
		<hr>

		<div class="flex justify-between items-center mt-3">
			<div>NO. ${member.id}</div>
			<div>등록날짜 ${member.regDate}</div>
			<div>아이디 ${member.loginId}</div>
			<div>이름 ${member.name}</div>
			<div>
				<a class="flex items-center">
					<img
						src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=crop&amp;w=731&amp;q=80"
						alt="avatar" class="mx-4 w-10 h-10 object-cover rounded-full">
					<span class="text-gray-700 font-bold hover:underline">${member.nickname}</span>
				</a>
			</div>
			<div>${member.cellphoneNo}</div>
			<div>${member.email}</div>
		</div>
	</div>
</section>

<%@ include file="../part/mainLayoutFoot.jspf"%>