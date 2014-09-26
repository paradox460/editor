class Editors
  module Helpers
    # Utilities for detecting which platform and which version of ruby the user is running
    #
    # @author Jeff Sandberg
    module PlatformDetection
      def windows?
        RbConfig::CONFIG['host_os'] =~ /mswin|mingw/
      end

      # Determines if we can use ANSI on windows
      #
      # @return [Boolean]
      def windows_ansi?
        defined?(Win32::Console) || ENV['ANSICON'] || (windows? && mri_2?)
      end

      def jruby?
        RbConfig::CONFIG['ruby_install_name'] == 'jruby'
      end

      def jruby_19?
        jruby? && RbConfig::CONFIG['ruby_version'] == '1.9'
      end

      def rbx?
        RbConfig::CONFIG['ruby_install_name'] == 'rbx'
      end

      def mri?
        RbConfig::CONFIG['ruby_install_name'] == 'ruby'
      end
      # rubocop:disable Style/DoubleNegation
      def mri_19?
        !!(mri? && RUBY_VERSION =~ /^1\.9/)
      end

      def mri_2?
        !!(mri? && RUBY_VERSION =~ /^2/)
      end

      def mri_20?
        !!(mri? && RUBY_VERSION =~ /^2\.0/)
      end

      def mri_21?
        !!(mri? && RUBY_VERSION =~ /^2\.1/)
      end
      # rubocop:enable Style/DoubleNegation
    end
  end
end
