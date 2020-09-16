# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'documents/text'
require_relative 'documents/zip'

module FileComposer
  # Factory for building documents.  To register new document types:
  # - Implement a subclass for FileComposer::Documents::Base or a document compliant class.
  #   The only real constraint is that it is hashable using the acts_as_hashable class method
  #   and implements #write!(temp_root = '', store = Stores::Null.new)
  # - Call FileComposer::Documents#register(name, class_constant_or_name)
  class Documents
    acts_as_hashable_factory

    register 'text', Documents::Text
    register 'zip',  Documents::Zip
  end
end
