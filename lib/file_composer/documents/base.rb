# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'result'
require_relative 'file_result'

module FileComposer
  class Documents
    # Parent class for all documents.
    class Base
      acts_as_hashable

      attr_reader :filename

      def initialize(filename:)
        raise ArgumentError, 'filename is required' if filename.to_s.empty?

        @filename = filename.to_s
      end

      private

      def make_temp_filename(temp_root)
        temp_filename = "#{SecureRandom.uuid}#{extension}"

        temp_root.to_s.empty? ? temp_filename : File.join(temp_root, temp_filename)
      end

      def extension
        File.extname(filename)
      end
    end
  end
end
