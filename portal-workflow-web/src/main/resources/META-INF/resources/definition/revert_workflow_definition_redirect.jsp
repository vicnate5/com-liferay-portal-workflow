<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/definition/init.jsp" %>

<%
String redirect = ParamUtil.getString(request, "redirect");

Portlet portlet = PortletLocalServiceUtil.getPortletById(company.getCompanyId(), portletDisplay.getId());
%>

<aui:script use="aui-base">
	Liferay.fire(
		'closeWindow',
		{
			id: '<portlet:namespace />previewBeforeRevert',
			portletAjaxable: <%= portlet.isAjaxable() %>,
			redirect: '<%= HtmlUtil.escape(redirect) %>',
			refresh: '<%= portletDisplay.getId() %>'
		}
	);
</aui:script>