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
    # Can compress documents together into a zip file.
    class Zip < Base
      attr_reader :blueprint

      def initialize(filename:, blueprint: {})
        super(filename: filename)

        @blueprint = Blueprint.make(blueprint)
      end

      def write!(temp_root = '', store = Stores::Null.new)
        results               = blueprint.write!(temp_root)
        write_time_in_seconds = results.sum(&:time_in_seconds)
        physical_filename     = nil

        zip_time_in_seconds = Benchmark.measure do
          physical_filename = zip!(temp_root, results)
        end.real

        total_time_in_seconds = write_time_in_seconds + zip_time_in_seconds

        cleanup(results)

        final_filename = store.move!(physical_filename)
        file_result = FileResult.new(filename, final_filename)

        Result.new(file_result, total_time_in_seconds)
      end

      private

      def zip!(temp_root, results)
        make_temp_filename(temp_root).tap do |physical_filename|
          ::Zip::File.open(physical_filename, ::Zip::File::CREATE) do |zipfile|
            results.each do |result|
              result.file_results.each do |file_result|
                zipfile.add(file_result.logical_filename, file_result.physical_filename)
              end
            end
          end
        end
      end

      def cleanup(results)
        results.each do |result|
          result.file_results.each do |file_result|
            FileUtils.rm(file_result.physical_filename, force: true)
          end
        end
      end
    end
  end
end
