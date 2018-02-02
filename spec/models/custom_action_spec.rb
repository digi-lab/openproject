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

require 'spec_helper'

describe CustomAction, type: :model do
  let(:stubbed_instance) { FactoryGirl.build_stubbed :custom_action }
  let(:instance) { FactoryGirl.create :custom_action, name: 'zzzzzzzzz' }
  let(:other_instance) { FactoryGirl.create :custom_action, name: 'aaaaa' }

  describe '#name' do
    it 'can be set and read' do
      stubbed_instance.name = 'blubs'

      expect(stubbed_instance.name)
        .to eql 'blubs'
    end
  end

  describe 'validations' do
    it 'is invalid with a name longer than 255 chars' do
      stubbed_instance.name = 'a' * 256

      expect(stubbed_instance)
        .to be_invalid
    end

    it 'is invalid with a nil name' do
      stubbed_instance.name = nil

      expect(stubbed_instance)
        .to be_invalid
    end

    it 'is invalid with an empty name' do
      stubbed_instance.name = ''

      expect(stubbed_instance)
        .to be_invalid
    end
  end

  describe '.order_by_name' do
    before do
      instance
      other_instance
    end

    it 'returns the actions ordered by name' do
      expect(described_class.order_by_name.to_a)
        .to eql [other_instance, instance]
    end
  end

  describe '.actions' do
    it 'is empty initially' do
      expect(stubbed_instance.actions)
        .to be_empty
    end

    it 'can be set and read' do
      stubbed_instance.actions = [CustomActions::Actions::AssignedTo.new(1)]

      expect(stubbed_instance.actions.map { |a| [a.key, a.values] })
        .to match_array [[:assigned_to, [1]]]
    end

    it 'can be persisted' do
      instance.actions = [CustomActions::Actions::AssignedTo.new(1)]

      instance.save!

      expect(CustomAction.find(instance.id).actions.map { |a| [a.key, a.values] })
        .to match_array [[:assigned_to, [1]]]
    end
  end

  describe '.all_actions' do
    it 'returns all available actions with the default value initialized' do
      expect(stubbed_instance.all_actions.map { |a| [a.key, a.values] })
        .to include([:assigned_to, []], [:status, []])
    end

    it 'returns the activated actions with their selected value and all other with the default value' do
      stubbed_instance.actions = [CustomActions::Actions::AssignedTo.new(1)]

      expect(stubbed_instance.all_actions.map { |a| [a.key, a.values] })
        .to include([:assigned_to, [1]], [:status, []])
    end
  end

  describe '.conditions' do
    let(:status) { FactoryGirl.create(:status) }
    let(:role) { FactoryGirl.create(:role) }

    it 'is empty initially' do
      expect(stubbed_instance.conditions)
        .to be_empty
    end

    it 'can be set and read' do
      stubbed_instance.conditions = [CustomActions::Conditions::Status.new(status.id),
                                     CustomActions::Conditions::Role.new(role.id)]

      expect(stubbed_instance.conditions.map { |a| [a.key, a.values] })
        .to match_array [[:status, [status.id]],
                         [:role, [role.id]]]
    end

    it 'can be persisted' do
      instance.conditions = [CustomActions::Conditions::Status.new(status.id),
                             CustomActions::Conditions::Role.new(role.id)]

      instance.save!

      expect(CustomAction.find(instance.id).conditions.map { |a| [a.key, a.values] })
        .to match_array [[:status, [status.id]],
                         [:role, [role.id]]]
    end
  end

  describe '.all_conditions' do
    it 'returns all available conditions with the default value initialized' do
      expect(stubbed_instance.all_conditions.map { |a| [a.key, a.values] })
        .to match_array [[:status, []],
                         [:role, []]]
    end
  end
end