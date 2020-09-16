# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe FileComposer::Stores::Local do
  let(:input_path)     { File.join(TEMP_DIR, 'local_input_store') }
  let(:root)           { File.join(TEMP_DIR, 'local_output_store') }
  let(:input_filename) { File.join(input_path, "#{SecureRandom.uuid}.txt") }
  let(:date)           { Date.parse('1999-12-31') }
  let(:date_shard)     { File.join(date.year.to_s, date.month.to_s, date.day.to_s) }
  let(:data)           { 'hello world!' }

  subject { described_class.new(root: root, date: date) }

  before(:each) do
    FileUtils.mkdir_p(input_path)
    IO.write(input_filename, data)
  end

  describe '#move!' do
    it 'returns path with date parts as folders' do
      file_resultname = subject.move!(input_filename)

      expect(file_resultname).to include(date_shard)
    end

    it 'copies file' do
      file_resultname = subject.move!(input_filename)

      expect(File.exist?(file_resultname)).to be true

      actual_data = IO.read(file_resultname)

      expect(actual_data).to eq(data)
    end

    it 'removes old file' do
      subject.move!(input_filename)

      expect(File.exist?(input_filename)).to be false
    end
  end
end
