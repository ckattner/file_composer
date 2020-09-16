# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module FileComposer
  class Documents
    # Writes basic, static text file
    class Text < Base
      attr_reader :data

      def initialize(filename:, data: '')
        super(filename: filename)

        @data = data
      end

      def write!(temp_root = '', store = Stores::Null.new)
        temp_filename = make_temp_filename(temp_root)

        time_in_seconds = Benchmark.measure do
          # First, write out the temporary file
          FileUtils.mkdir_p(File.dirname(temp_filename))
          IO.write(temp_filename, data)
        end.real

        # Then copy the file to permanent store
        physical_filename = store.move!(temp_filename)
        file_result       = FileResult.new(filename, physical_filename)

        Result.new(file_result, time_in_seconds)
      end
    end
  end
end
