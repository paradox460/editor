class Editors
  module Helpers
    # Helpers for generating editor invocation commands
    #
    # @author Jeff Sandberg
    module EditorSyntax
      def editor_name
        File.basename(default_editor).split(' ').first
      end
      # The blocking flag for this particular editor.
      #
      # @param blocking [Boolean] If false, returns nothing
      #
      # @return [String, Nil]
      def blocking_flag_for_editor(blocking)
        case editor_name
        when /^emacsclient/
          '--no-wait'
        when /^[gm]vim/
          '--nofork'
        when /^jedit/
          '-wait'
        when /^mate/, /^subl/, /^redcar/
          '-w'
        end if blocking
      end

      # The starting line syntax for the user's editor
      # @param file_name [String] File name/path
      # @param line_number [Fixnum]
      #
      # @return [String]
      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      def start_line_syntax_for_editor(file_name, line_number)
        return file_name if line_number <= 1

        case editor_name
        when /^[gm]?vi/, /^emacs/, /^nano/, /^pico/, /^gedit/, /^kate/
          "+#{line_number} #{file_name}"
        when /^mate/, /^geany/
          "-l #{line_number} #{file_name}"
        when /^subl/
          "#{file_name}:#{line_number}"
        when /^uedit32/
          "#{file_name}/#{line_number}"
        when /^jedit/
          "#{file_name} +line:#{line_number}"
        when /^redcar/
          "-l#{line_number} #{file_name}"
        else
          if windows?
            "#{file_name}"
          else
            "+#{line_number} #{file_name}"
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength
    end
  end
end
