# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe FileComposer::Stores::Null do
  let(:filename) { '123.txt' }

  describe '#move!' do
    it 'returns argument verbatim' do
      expect(subject.move!(filename)).to eq(filename)
    end
  end
end
