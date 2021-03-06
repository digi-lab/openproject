//-- copyright
// OpenProject is a project management system.
// Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License version 3.
//
// OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
// Copyright (C) 2006-2013 Jean-Philippe Lang
// Copyright (C) 2010-2013 the ChiliProject Team
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
// See doc/COPYRIGHT.rdoc for more details.
//++

import {opApiModule} from '../../../../angular-modules';
import {HalRequestService} from '../hal-request/hal-request.service';
import {
  HelpTextResource,
  HelpTextResourceInterface
} from '../hal-resources/help-text-resource.service';
import {CollectionResource} from "core-components/api/api-v3/hal-resources/collection-resource.service";

export class HelpTextDmService {
  constructor(protected halRequest:HalRequestService,
              protected v3Path:any) {
  }

  public loadAll():ng.IPromise<CollectionResource<HelpTextResourceInterface>> {
    return this.halRequest.get(this.v3Path.help_texts());
  }

  public load(helpTextId:string):ng.IPromise<HelpTextResourceInterface> {
    return this.halRequest.get(this.v3Path.help_texts({ id: helpTextId}));
  }
}

opApiModule.service('helpTextDm', HelpTextDmService);
