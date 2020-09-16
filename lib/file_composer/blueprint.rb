# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'documents'
require_relative 'stores'

module FileComposer
  # The main object model.
  class Blueprint
    acts_as_hashable

    attr_reader :documents

    def initialize(documents: [])
      @documents = Documents.array(documents)
      filenames  = @documents.map { |a| a.filename.downcase }
      not_unique = filenames.uniq.length != @documents.length

      raise ArgumentError, "filenames not unique: #{filenames}" if not_unique
    end

    def write!(temp_root = '', store = Stores::Null.new)
      documents.flat_map { |d| d.write!(temp_root, store) }
    end
  end
end
