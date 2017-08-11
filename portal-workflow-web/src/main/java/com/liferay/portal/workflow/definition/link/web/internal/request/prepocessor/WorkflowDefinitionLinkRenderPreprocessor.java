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

package com.liferay.portal.workflow.definition.link.web.internal.request.prepocessor;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.service.WorkflowDefinitionLinkLocalService;
import com.liferay.portal.workflow.definition.link.web.internal.display.context.WorkflowDefinitionLinkDisplayContext;
import com.liferay.portal.workflow.web.internal.constants.WorkflowWebKeys;
import com.liferay.portal.workflow.web.internal.request.prepocessor.WorkflowRenderPreprocessor;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Adam Brandizzi
 */
@Component(service = WorkflowDefinitionLinkRenderPreprocessor.class)
public class WorkflowDefinitionLinkRenderPreprocessor
	implements WorkflowRenderPreprocessor {

	@Override
	public void prepareRender(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws PortletException {

		try {
			WorkflowDefinitionLinkDisplayContext displayContext =
				new WorkflowDefinitionLinkDisplayContext(
					renderRequest, renderResponse,
					_workflowDefinitionLinkLocalService);

			renderRequest.setAttribute(
				WorkflowWebKeys.WORKFLOW_DEFINITION_LINK_DISPLAY_CONTEXT,
				displayContext);
		}
		catch (PortalException pe) {
			throw new PortletException(pe);
		}
	}

	@Reference(unbind = "-")
	private WorkflowDefinitionLinkLocalService
		_workflowDefinitionLinkLocalService;

}