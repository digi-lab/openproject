#-- encoding: UTF-8

#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2017 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module WorkPackage::CustomActions
  extend ActiveSupport::Concern

  included do
    def custom_actions(user)
      # TODO adapt selector from registered custom action conditions
      has_current_status = CustomAction.includes(:statuses).where(custom_actions_statuses: { status_id: status_id })
      has_no_status = CustomAction.includes(:statuses).where(custom_actions_statuses: { status_id: nil })

      status_scope = has_current_status
                     .or(has_no_status)

      roles_in_project = Role.joins(:members).where(members: { project_id: project_id, user_id: user.id }).select(:id)

      has_current_role = CustomAction.includes(:roles).where(custom_actions_roles: { role_id: roles_in_project })
      has_no_role = CustomAction.includes(:roles).where(custom_actions_roles: { role_id: nil })

      role_scope = has_current_role
                   .or(has_no_role)

      status_scope.merge(role_scope)
    end
  end
end