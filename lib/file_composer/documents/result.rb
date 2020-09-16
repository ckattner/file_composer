# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module FileComposer
  class Documents
    # Returns the result of a FileComposer::Document#write! call.  Each #write! call can produce
    # N number of documents and each document will be represented in this instance's file_results
    # attribute.
    class Result
      attr_reader :file_results,
                  :time_in_seconds

      def initialize(file_results, time_in_seconds)
        @file_results    = Array(file_results)
        @time_in_seconds = time_in_seconds

        freeze
      end
    end
  end
end
