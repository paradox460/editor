require 'english'
require 'editors/version'
require 'editors/helpers/editor_syntax'
require 'editors/helpers/platform_detection'

# Editor class. Lets you edit both real and temporary files, and returns their values after editing.
#
# @author Jeff Sandberg
#
class Editors
  include Editors::Helpers::PlatformDetection
  include Editors::Helpers::EditorSyntax
  attr_reader :content

  # Initialize a new editor, with options. You should probably use Editor.edit or Editor.new instead of these
  # You must pass a file OR temp string, but NOT both
  #
  # @param options [Hash]
  # @option file [String] options (nil) A file path to edit
  # @option temp [String] options (nil) The content of the tempfile, prior to editing
  # @option line [String] options (1) The line of the file to place the cursor at
  # @option blocking [Boolean] options (true) Pass the editor a blocking flag
  # @return [Editor] Editor object, with #content set to the return value from the file
  def initialize(options = {})
    opts = { file: nil, temp: nil, line: 1, blocking: true }.merge(options)
    if !opts_is_valid?opts
      fail ArgumentError, 'define file OR temp'
    elsif opts[:file]
      edit_file(opts)
    elsif opts[:temp]
      edit_temp(opts)
    end
  end

  class << self
    # Edit a file from the filesystem, and return its value
    # @param file [String] A file path to edit
    # @param line [Fixnum] The line of the file to place the cursor at
    # @param blocking [Boolean] Pass the editor a blocking flag
    #
    # @return [String] The value of the file AFTER it was edited
    def file(file, line = 1, blocking = true)
      new(file: file, line: line, blocking: blocking).content
    end

    # Edits a temporary file, and return its value
    # @param initial_content [String] The content of the tempfile, prior to editing
    # @param line [Fixnum] Tempfile line to place cursor at
    #
    # @return [String] The value of the tempfile AFTER it was edited
    def temp(initial_content, line = 1)
      new(temp: initial_content, line: line, blocking: true).content
    end
  end

  private

  # Checks if an options hash contains both file and temp values
  # @param opts [Hash] Options hash
  #
  # @return [Boolean]
  def opts_is_valid?(opts = {})
    !(opts[:file].nil? && opts[:temp].nil?) || (opts[:file] && opts[:temp])
  end

  # Open the file in the users editor of choice
  # @param opts [Hash] Options hash
  # @option file [String] options (nil) A file path to edit
  # @option line [String] options (1) The line of the file to place the cursor at
  # @option blocking [Boolean] options (true) Pass the editor a blocking flag
  #
  # @return [String] The value of the tempfile AFTER it was edited
  def edit_file(opts = {})
    File.open(opts[:file]) do |f|
      invoke_editor(f.path, opts[:line], opts[:blocking])
      @content = File.read(f.path)
    end
  end

  # Put a string in a temp file and present it to the user for editing
  # @param opts [Hash] Options hash
  # @option temp [String] options (nil) The content of the tempfile, prior to editing
  # @option line [String] options (1) The line of the file to place the cursor at
  #
  # @return [String] The value of the tempfile AFTER it was edited
  def edit_temp(opts = {})
    temp_file do |f|
      f.puts(opts[:temp])
      f.flush
      f.close(false)
      invoke_editor(f.path, opts[:line], true)
      @content = File.read(f.path)
    end
  end

  # Open the users default editor with the params specified
  # @param file [String] File path
  # @param line [Fixnum] Line number to place cursor at
  # @param blocking = true [Boolean] If the editor should be blocking
  def invoke_editor(file, line = 1, blocking = true)
    fail 'Please export $VISUAL or $EDITOR' unless default_editor

    editor_invocation = build_editor_invocation_string(file, line, blocking)
    return nil unless editor_invocation

    if jruby?
      open_editor_on_jruby(editor_invocation)
    else
      open_editor(editor_invocation)
    end
  end

  # Create and yield a tempfile
  # @param ext [String] File extension for the file to user
  #
  # @yieldparam [File] The tempfile object
  def temp_file(ext = '.rb')
    file = Tempfile.new(['editors', ext])
    yield file
  ensure
    file.close(true) if file
  end

  # Builds the string that is used to call the editor
  # @param file [String] File path
  # @param line [Fixnum] Line number
  # @param blocking [Boolean]
  #
  # @return [String] Editor invocation string
  def build_editor_invocation_string(file, line, blocking)
    sanitized_file = windows? ? file.gsub(/\//, '\\') : Shellwords.escape(file)
    "#{default_editor} #{blocking_flag_for_editor(blocking)} #{start_line_syntax_for_editor(sanitized_file, line)}"
  end

  # Open the editor
  # @param editor_invocation [String] Value from #build_editor_invocation_string
  def open_editor(editor_invocation)
    system(*Shellwords.split(editor_invocation)) || fail("`#{editor_invocation}` gave exit status: #{$CHILD_STATUS.exitstatus}")
  end

  # jRuby doesn't like open_editor, so we have to muck about with this
  # @param editor_invocation [String] Value from #build_editor_invocation_string
  def open_editor_on_jruby(editor_invocation)
    require 'spoon'
    pid = Spoon.spawnp(*Shellwords.split(editor_invocation))
    Process.waitpid(pid)
    rescue FFI::NotFoundError
      system(editor_invocation)
  end

  # Get the user's configured visual or editor ENV
  #
  # @return [String] The editor command
  def default_editor
    # Visual = Advanced editor
    return ENV['VISUAL'] if ENV['VISUAL'] && !ENV['VISUAL'].empty?
    # Editor = basic editor
    return ENV['EDITOR'] if ENV['EDITOR'] && !ENV['EDITOR'].empty?
    if windows?
      'notepad'
    else
      %w(editor nano vi).find do |editor|
        system("which #{editor} > /dev/null 2>&1")
      end
    end
  end
end
