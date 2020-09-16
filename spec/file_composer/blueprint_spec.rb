# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe FileComposer::Blueprint do
  def clean(results)
    results.each do |result|
      result.file_results.each do |file_result|
        FileUtils.rm(file_result.physical_filename)
      end
    end
  end

  describe '#initialize' do
    describe 'preventing duplicate document names' do
      let(:case_documents) do
        [
          { type: :text, filename: 'hello_world_1.txt' },
          { type: :text, filename: 'hello_WORLD_1.txt' }
        ]
      end

      let(:type_documents) do
        [
          { type: :text, filename: 123 },
          { type: :text, filename: '123' }
        ]
      end

      it 'is case-insensitive' do
        expect { described_class.new(documents: case_documents) }.to raise_error(ArgumentError)
      end

      it 'is type-insensitive' do
        expect { described_class.new(documents: type_documents) }.to raise_error(ArgumentError)
      end
    end
  end

  # Superficial tests to ensure syntax for examples.
  # We have deeper unit tests at the document class level.
  describe 'README examples' do
    let(:two_text_files) do
      {
        documents: [
          {
            type: :text,
            filename: 'hello.txt',
            data: 'hello world!'
          },
          {
            type: :text,
            filename: 'hello2.txt',
            data: 'hello world again!'
          }
        ]
      }
    end

    let(:two_text_and_one_zip) do
      {
        documents: [
          {
            type: :text,
            filename: 'hello.txt',
            data: 'hello world!'
          },
          {
            type: :text,
            filename: 'hello2.txt',
            data: 'hello world again!'
          },
          {
            type: :zip,
            filename: 'hello3.zip',
            blueprint: {
              documents: [
                {
                  type: :text,
                  filename: 'hello4.txt',
                  data: 'hello world again... again!'
                }
              ]
            }
          }
        ]
      }
    end

    specify 'Writing Text Files' do
      blueprint = FileComposer::Blueprint.make(two_text_files)

      results = blueprint.write!

      expect(results.length).to eq(2)

      clean(results)
    end

    specify 'Configuring the Temporary Store' do
      config = {
        documents: [
          {
            type: :text,
            filename: 'hello.txt',
            data: 'hello world!'
          },
          {
            type: :text,
            filename: 'hello2.txt',
            data: 'hello world again!'
          }
        ]
      }

      temp_path = File.join('tmp', 'file_composer')
      blueprint = FileComposer::Blueprint.make(config)

      results = blueprint.write!(temp_path)

      expect(results.length).to eq(2)

      clean(results)
    end

    specify 'Writing to Permanent Storage' do
      root      = 'storage'
      store     = FileComposer::Stores::Local.new(root: root)
      temp_path = File.join('tmp', 'file_composer')
      blueprint = FileComposer::Blueprint.make(two_text_files)

      results = blueprint.write!(temp_path, store)

      expect(results.length).to eq(2)

      FileUtils.rm_rf(root)
    end

    specify 'Writing Zip Archives' do
      blueprint = FileComposer::Blueprint.make(two_text_and_one_zip)

      results = blueprint.write!

      expect(results.length).to eq(3)

      clean(results)
    end
  end
end
