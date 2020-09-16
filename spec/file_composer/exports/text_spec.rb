# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'file_helper'

describe FileComposer::Documents::Text do
  let(:temp_root) { File.join(TEMP_DIR, 'text_spec') }
  let(:filename)  { 'some/dir/hello_world.txt' }
  let(:data)      { 'HELLO WORLD!' }
  let(:store)     { FileComposer::Stores::Null.new }

  subject { described_class.make(filename: filename, data: data) }

  describe '#write!' do
    it 'calls Store#move!' do
      expect(store).to receive(:move!)

      subject.write!(temp_root, store)
    end

    it 'writes temp file as returned file' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      actual_contents = IO.read(file_result.physical_filename)

      expect(actual_contents).to eq(data)
    end

    it 'returns logical filename' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      expect(file_result.logical_filename).to eq(filename)
    end

    it 'returns physical filename' do
      result = subject.write!(temp_root)

      expect(result.file_results.length).to eq(1)

      file_result = result.file_results.first

      expect(file_result.physical_filename).to include(temp_root)
      expect(file_result.physical_filename).to include('.txt')
    end

    it 'returns time in seconds' do
      result = subject.write!(temp_root)

      expect(result.time_in_seconds).to be_positive
    end
  end
end
