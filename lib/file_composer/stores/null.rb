# frozen_string_literal: true

#
# Copyright (c) 2020-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module FileComposer
  module Stores
    # Default store, does nothing but provide a stand-in when you do not actually
    # want to transfer files.
    class Null
      def move!(local_filename)
        local_filename
      end
    end
  end
end
