#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Canvas::Plugins::Validators::EtherpadValidator
  def self.validate(settings, plugin_setting)
    if settings.map(&:last).all?(&:blank?)
      {}
    else
      if settings.map(&:last).any?(&:blank?)
        plugin_setting.errors.add_to_base(I18n.t('canvas.plugins.errors.all_fields_required', 'All fields are required'))
        false
      else
        settings.slice(:domain, :name)
        settings[:domain] = settings[:domain].sub(/https?:/, '').gsub(/\//, '')
        settings[:name] ||= "EtherPad"
        settings
      end
    end
  end
end