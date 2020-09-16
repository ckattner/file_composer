# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module FileComposer
  class Documents
    # A singular file result for a document.
    class FileResult
      attr_reader :logical_filename, :physical_filename

      def initialize(logical_filename, physical_filename)
        @logical_filename  = logical_filename
        @physical_filename = physical_filename

        freeze
      end
    end
  end
end
