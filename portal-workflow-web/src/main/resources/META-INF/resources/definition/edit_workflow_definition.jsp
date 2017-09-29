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

WorkflowDefinition workflowDefinition = (WorkflowDefinition)request.getAttribute(WebKeys.WORKFLOW_DEFINITION);

String name = BeanParamUtil.getString(workflowDefinition, request, "name");
int version = BeanParamUtil.getInteger(workflowDefinition, request, "version");
String content = BeanParamUtil.getString(workflowDefinition, request, "content");

portletDisplay.setShowBackIcon(true);
portletDisplay.setURLBack(redirect);

renderResponse.setTitle((workflowDefinition == null) ? LanguageUtil.get(request, "new-workflow") : workflowDefinition.getName());
%>

<liferay-portlet:actionURL name='<%= (workflowDefinition == null) ? "addWorkflowDefinition" : "updateWorkflowDefinition" %>' var="editWorkflowDefinitionURL">
	<portlet:param name="mvcPath" value="/definition/edit_workflow_definition.jsp" />
</liferay-portlet:actionURL>

<c:if test="<%= workflowDefinition != null %>">
	<liferay-frontend:info-bar>
		<div class="container-fluid-1280">
			<div class="info-bar-item">
				<c:choose>
					<c:when test="<%= workflowDefinition.isActive() %>">
						<span class="label label-info"><%= LanguageUtil.get(request, "published") %></span>
					</c:when>
					<c:otherwise>
						<span class="label label-secondary"><%= LanguageUtil.get(request, "not-published") %></span>
					</c:otherwise>
				</c:choose>
			</div>

			<%
			String userName = workflowDefinitionDisplayContext.getUserName(workflowDefinition);
			%>

			<span>
				<c:choose>
					<c:when test="<%= userName == null %>">
						<%= dateFormatTime.format(workflowDefinition.getModifiedDate()) %>
					</c:when>
					<c:otherwise>
						<liferay-ui:message arguments="<%= new String[] {dateFormatTime.format(workflowDefinition.getModifiedDate()), userName} %>" key="x-by-x" translateArguments="<%= false %>" />
					</c:otherwise>
				</c:choose>
			</span>
		</div>

		<liferay-frontend:info-bar-buttons>
			<liferay-frontend:info-bar-sidenav-toggler-button
				icon="info-circle"
				label="info"
			/>
		</liferay-frontend:info-bar-buttons>
	</liferay-frontend:info-bar>
</c:if>

<div class="closed container-fluid-1280 sidenav-container sidenav-right" id="<portlet:namespace />infoPanelId">
	<c:if test="<%= workflowDefinition != null %>">
		<div class="sidenav-menu-slider">
			<div class="sidebar sidebar-default sidenav-menu">
				<div class="sidebar-header">
					<aui:icon cssClass="icon-monospaced sidenav-close text-default visible-xs-inline-block" image="times" markupView="lexicon" url="javascript:;" />
				</div>

				<liferay-ui:tabs cssClass="navbar-no-collapse" names="details,versions" refresh="<%= false %>" type="dropdown">
					<liferay-ui:section>
						<div class="sidebar-body">
							<h3 class="version">
								<liferay-ui:message key="version" /> <%= workflowDefinition.getVersion() %>
							</h3>

							<aui:model-context bean="<%= workflowDefinition %>" model="<%= WorkflowDefinition.class %>" />

							<aui:workflow-status model="<%= WorkflowDefinition.class %>" status="<%= WorkflowConstants.STATUS_APPROVED %>" />
						</div>
					</liferay-ui:section>

					<liferay-ui:section>
						<div class="sidebar-body workflow-definition-sidebar">
							<liferay-util:include page="/definition/view_workflow_definition_history.jsp" servletContext="<%= application %>">
								<liferay-util:param name="redirect" value="<%= redirect %>" />
							</liferay-util:include>
						</div>
					</liferay-ui:section>
				</liferay-ui:tabs>
			</div>
		</div>
	</c:if>

	<div class="sidenav-content">
		<aui:form action="<%= editWorkflowDefinitionURL %>" method="post" name="fm">
			<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
			<aui:input name="name" type="hidden" value="<%= name %>" />
			<aui:input name="version" type="hidden" value="<%= version %>" />
			<aui:input name="content" type="hidden" value="<%= content %>" />

			<div class="card-horizontal main-content-card">
				<div class="card-row-padded">
					<liferay-ui:error exception="<%= RequiredWorkflowDefinitionException.class %>" message="you-cannot-deactivate-or-delete-this-definition" />
					<liferay-ui:error exception="<%= WorkflowDefinitionFileException.class %>" message="please-enter-a-valid-definition-before-publishing" />
					<liferay-ui:error exception="<%= WorkflowDefinitionTitleException.class %>" message="please-name-your-workflow-before-publishing" />

					<aui:fieldset cssClass="workflow-definition-content">
						<aui:col>
							<aui:field-wrapper label="title">
								<liferay-ui:input-localized name="title" xml='<%= BeanPropertiesUtil.getString(workflowDefinition, "title") %>' />
							</aui:field-wrapper>
						</aui:col>

						<aui:col cssClass="workflow-definition-upload">
							<liferay-util:buffer var="importFileMark">
								<aui:a href="#" id="uploadLink">
									<%= StringUtil.toLowerCase(LanguageUtil.get(request, "import-a-file")) %>
								</aui:a>
							</liferay-util:buffer>

							<liferay-ui:message arguments="<%= importFileMark %>" key="write-your-definition-or-x" translateArguments="<%= false %>" />
							<input class="workflow-definition-upload-source" id="<portlet:namespace />upload" type="file" />
						</aui:col>

						<aui:col cssClass="workflow-definition-content-source-wrapper" id="contentSourceWrapper">
							<div class="workflow-definition-content-source" id="<portlet:namespace />contentEditor"></div>
						</aui:col>
					</aui:fieldset>
				</div>
			</div>

			<aui:button-row>

				<%
				String taglibOnClick = "Liferay.fire('" + liferayPortletResponse.getNamespace() + "publishDefinition');";
				%>

				<aui:button cssClass="btn-lg" onClick="<%= taglibOnClick %>" primary="<%= true %>" value='<%= (workflowDefinition == null) ? "publish" : "update" %>' />
			</aui:button-row>
		</aui:form>
	</div>
</div>

<aui:script use="aui-ace-editor,liferay-xml-formatter">
	var STR_VALUE = 'value';

	var contentEditor = new A.AceEditor(
		{
			boundingBox: '#<portlet:namespace />contentEditor',
			height: 600,
			mode: 'xml',
			tabSize: 4,
			width: '100%'
		}
	).render();

	var editorContentElement = A.one('#<portlet:namespace />content');

	if (editorContentElement) {
		contentEditor.set(STR_VALUE, editorContentElement.val());
	}

	var uploadFile = $('#<portlet:namespace />upload');

	uploadFile.on(
		'change',
		function(evt) {
			var files = evt.target.files;

			if (files) {
				var reader = new FileReader();

				reader.onloadend = function(evt) {

					if (evt.target.readyState == FileReader.DONE) {
						contentEditor.set(STR_VALUE, evt.target.result);
					}
				};

				reader.readAsText(files[0]);
			}
		}
	);

	var uploadLink = A.one('#<portlet:namespace />uploadLink');

	uploadLink.on(
		'click',
		function(event) {
			event.preventDefault();
			uploadFile.trigger('click');
		}
	);

	Liferay.on(
		'<portlet:namespace />publishDefinition',
		function(event) {
			var form = AUI.$('#<portlet:namespace />fm');

			form.fm('content').val(contentEditor.get(STR_VALUE));

			submitForm(form);
		}
	);
</aui:script>