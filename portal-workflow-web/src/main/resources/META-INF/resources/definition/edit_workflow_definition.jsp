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
String randomNamespace = StringUtil.randomId() + StringPool.UNDERLINE;
String redirect = ParamUtil.getString(request, "redirect");

WorkflowDefinition workflowDefinition = (WorkflowDefinition)request.getAttribute(WebKeys.WORKFLOW_DEFINITION);

String name = BeanParamUtil.getString(workflowDefinition, request, "name");
int version = BeanParamUtil.getInteger(workflowDefinition, request, "version");
String content = BeanParamUtil.getString(workflowDefinition, request, "content");
boolean active = BeanParamUtil.getBoolean(workflowDefinition, request, "active");

String duplicationTitle = workflowDefinitionDisplayContext.getDuplicateTitle(workflowDefinition);

portletDisplay.setShowBackIcon(true);
portletDisplay.setURLBack(redirect);

renderResponse.setTitle((workflowDefinition == null) ? LanguageUtil.get(request, "new-workflow") : workflowDefinition.getTitle(LanguageUtil.getLanguageId(request)));
%>

<liferay-ui:error exception="<%= RequiredWorkflowDefinitionException.class %>">

	<%
	RequiredWorkflowDefinitionException requiredWorkflowDefinitionException = (RequiredWorkflowDefinitionException)errorException;

	Object[] messageArguments = workflowDefinitionDisplayContext.getMessageArguments(requiredWorkflowDefinitionException.getWorkflowDefinitionLinks());

	String messageKey = workflowDefinitionDisplayContext.getMessageKey(requiredWorkflowDefinitionException.getWorkflowDefinitionLinks());
	%>

	<liferay-ui:message arguments="<%= messageArguments %>" key="<%= messageKey %>" translateArguments="<%= false %>" />
</liferay-ui:error>

<liferay-portlet:actionURL name='<%= (workflowDefinition == null) ? "addWorkflowDefinition" : "updateWorkflowDefinition" %>' var="editWorkflowDefinitionURL">
	<portlet:param name="mvcPath" value="/definition/edit_workflow_definition.jsp" />
</liferay-portlet:actionURL>

<liferay-portlet:actionURL name="duplicateWorkflowDefinition" var="duplicateWorkflowDefinition">
	<portlet:param name="mvcPath" value="/definition/edit_workflow_definition.jsp" />
	<portlet:param name="redirect" value="<%= currentURL %>" />
</liferay-portlet:actionURL>

<c:if test="<%= workflowDefinition != null %>">
	<liferay-frontend:info-bar>
		<div class="container-fluid-1280">
			<div class="info-bar-item">
				<c:choose>
					<c:when test="<%= active %>">
						<span class="label label-info label-lg">
							<liferay-ui:message key="published" />
						</span>
					</c:when>
					<c:otherwise>
						<span class="label label-lg label-secondary">
							<liferay-ui:message key="not-published" />
						</span>
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
		<div class="lfr-portal-workflow-sidenav">
			<div class="sidebar sidebar-light">
				<div class="sidebar-header">
					<aui:icon cssClass="icon-monospaced sidenav-close text-default visible-xs-inline-block" image="times" markupView="lexicon" url="javascript:;" />

					<h4>
						<%= workflowDefinition.getTitle(LanguageUtil.getLanguageId(request)) %>
					</h4>
				</div>

				<liferay-ui:tabs cssClass="navbar-no-collapse panel panel-default" names="details,revision-history" refresh="<%= false %>" type="tabs nav-tabs-default ">
					<liferay-ui:section>
						<div class="sidebar-list">

							<%
							String creatorUserName = workflowDefinitionDisplayContext.getCreatorUserName(workflowDefinition);
							%>

							<div class="card-row-padded created-date">
								<div>
									<span class="info-title">
										<liferay-ui:message key="created" />
									</span>
								</div>

								<span class="info-content lfr-card-modified-by-text">
									<c:choose>
										<c:when test="<%= creatorUserName == null %>">
											<%= dateFormatTime.format(workflowDefinitionDisplayContext.getCreatedDate(workflowDefinition)) %>
										</c:when>
										<c:otherwise>
											<liferay-ui:message arguments="<%= new String[] {dateFormatTime.format(workflowDefinitionDisplayContext.getCreatedDate(workflowDefinition)), creatorUserName} %>" key="x-by-x" translateArguments="<%= false %>" />
										</c:otherwise>
									</c:choose>
								</span>
							</div>

							<%
							String userName = workflowDefinitionDisplayContext.getUserName(workflowDefinition);
							%>

							<div class="card-row-padded last-modified">
								<div>
									<span class="info-title">
										<liferay-ui:message key="last-modified" />
									</span>
								</div>

								<span class="info-content lfr-card-modified-by-text">
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

							<div class="card-row-padded">
								<div>
									<span class="info-title">
										<liferay-ui:message key="total-modifications" />
									</span>
								</div>

								<span class="info-content lfr-card-modified-by-text">
									<liferay-ui:message arguments='<%= new String[] {workflowDefinitionDisplayContext.getWorkflowDefinitionCount(workflowDefinition) + ""} %>' key="x-revisions" translateArguments="<%= false %>" />
								</span>
							</div>
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
			<aui:input name="successMessage" type="hidden" value='<%= active ? LanguageUtil.get(request, "workflow-updated-successfully") : LanguageUtil.get(request, "workflow-published-successfully") %>' />

			<div class="card-horizontal main-content-card">
				<div class="card-row-padded">
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

				<aui:button onClick="<%= taglibOnClick %>" primary="<%= true %>" value='<%= (workflowDefinition == null || !active) ? "publish" : "update" %>' />
			</aui:button-row>
		</aui:form>
	</div>
</div>

<c:if test="<%= workflowDefinition != null %>">
	<div class="hide" id="<%= randomNamespace %>titleInputLocalized">
		<aui:col>
			<aui:field-wrapper label="title">
				<liferay-ui:input-localized name="title" xml="<%= duplicationTitle %>" />
			</aui:field-wrapper>
		</aui:col>

		<aui:col>
			<liferay-ui:message key="copy-does-not-include-revisions" />
		</aui:col>
	</div>

	<div class="hide" id="<%= randomNamespace %>contentInput">
		<aui:input name="content" type="hidden" value="<%= workflowDefinition.getContent() %>" />
		<aui:input name="duplicatedDefinitionTitle" type="hidden" value="<%= workflowDefinition.getTitle(LanguageUtil.getLanguageId(request)) %>" />
		<aui:input name="name" type="hidden" value="<%= PortalUUIDUtil.generate() %>" />
	</div>
</c:if>

<aui:script use="aui-ace-editor,liferay-xml-formatter,liferay-workflow-web">
	var STR_VALUE = 'value';

	var title = '<liferay-ui:message key="duplicate-workflow" />';

	var contentEditor = new A.AceEditor(
		{
			boundingBox: '#<portlet:namespace />contentEditor',
			height: 600,
			mode: 'xml',
			tabSize: 4,
			width: '100%'
		}
	).render();

	var xmlFormatter = new Liferay.XMLFormatter();

	var editorContentElement = A.one('#<portlet:namespace />content');

	if (editorContentElement) {
		var content = xmlFormatter.format(editorContentElement.val());

		contentEditor.set(STR_VALUE, content);
	}

	var uploadFile = $('#<portlet:namespace />upload');

	var previousContent = '';

	uploadFile.on(
		'change',
		function(evt) {
			var files = evt.target.files;

			if (files) {
				var reader = new FileReader();

				reader.onloadend = function(evt) {
					if (evt.target.readyState == FileReader.DONE) {
						previousContent = contentEditor.get(STR_VALUE);

						contentEditor.set(STR_VALUE, evt.target.result);

						uploadFile.val('');

						Liferay.WorkflowWeb.showDefinitionImportSuccessMessage('<portlet:namespace />');
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

	Liferay.on(
		'<portlet:namespace />undoDefinition',
		function(event) {
			if (contentEditor) {
				contentEditor.set(STR_VALUE, previousContent);

				Liferay.WorkflowWeb.showActionUndoneSuccessMessage();
			}
		}
	);

	Liferay.on(
		'<portlet:namespace />duplicateDefinition',
		function(event) {
			Liferay.WorkflowWeb.confirmBeforeDuplicateDialog(this,'<%= duplicateWorkflowDefinition %>', title, '<%= randomNamespace %>');
		}
	);
</aui:script>