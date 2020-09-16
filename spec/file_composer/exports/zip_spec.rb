# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'file_helper'

describe FileComposer::Documents::Zip do
  let(:temp_root) { File.join(TEMP_DIR, 'zip_spec') }
  let(:filename)  { 'hello_worlds.zip' }
  let(:blueprint) { read_yaml_file('spec', 'fixtures', 'hello_worlds_zip.yaml') }
  let(:store)     { FileComposer::Stores::Null.new }

  subject { described_class.make(filename: filename, blueprint: blueprint) }

  describe '#write!' do
    it 'calls Store#move!' do
      expect(store).to receive(:move!)

      subject.write!(temp_root, store)
    end

    it 'file has correct logical name' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      expect(file_result.logical_filename).to eq(filename)
    end

    it 'file has correct physical name' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      expect(file_result.physical_filename).to include(temp_root)
      expect(file_result.physical_filename).to include('.zip')
    end

    # It should generation 1 zip with 3 files:
    # - 2 text files
    # - 1 zip file inner zip should have 1 text file.
    it 'contains expected data' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      Zip::File.open(file_result.physical_filename) do |zip_file|
        expect(zip_file.entries.length).to eq(3)

        actual_hello_world_1_content = zip_file.entries[0].get_input_stream.read
        expect(actual_hello_world_1_content).to eq(blueprint.dig('documents', 0, 'data'))

        actual_hello_world_2_content = zip_file.entries[1].get_input_stream.read
        expect(actual_hello_world_2_content).to eq(blueprint.dig('documents', 1, 'data'))

        nested_zip = zip_file.entries[2].get_input_stream.read

        Zip::File.open_buffer(nested_zip) do |nested_zip_file|
          content = nested_zip_file.entries[0].get_input_stream.read
          expect(content).to eq(blueprint.dig('documents', 2, 'blueprint', 'documents', 0, 'data'))
        end
      end
    end

    it 'returns requested logical filenames' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      expect(file_result.logical_filename).to eq(filename)

      Zip::File.open(file_result.physical_filename) do |zip_file|
        expect(zip_file.entries.length).to eq(3)

        expect(zip_file.entries[0].name).to eq(blueprint.dig('documents', 0, 'filename'))
        expect(zip_file.entries[1].name).to eq(blueprint.dig('documents', 1, 'filename'))

        nested_zip = zip_file.entries[2].get_input_stream.read

        Zip::File.open_buffer(nested_zip) do |nested_zip_file|
          expected = blueprint.dig('documents', 2, 'blueprint', 'documents', 0, 'filename')
          expect(nested_zip_file.entries[0].name).to eq(expected)
        end
      end
    end
  end
end
