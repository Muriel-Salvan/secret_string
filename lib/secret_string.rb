require 'forwardable'
require 'stringio'
require 'secret_string/core_extensions/string'

# Protect sensitive data in Strings by erasing it from memory when not needed anymore.
class SecretString

  class << self

    # Securely erase a String from memory
    #
    # Parameters::
    # * *secret* (String): The secret to erase from memory
    def erase(secret)
      secret_size = secret.bytesize
      io = StringIO.new("\0" * secret_size)
      io.read(secret_size, secret)
    end

    # Protect a String by giving access only to a secured version of it.
    # Make sure the String will be erased at the end of its access.
    #
    # Parameters::
    # * *str* (String): String to protect
    # * *silenced_str* (String): The protected representation of this string [default: 'XXXXX']
    # * Proc: Code called with the string secured
    #   * Parameters::
    #     * *secretstring* (SecretString): The secret string
    def protect(str, silenced_str: 'XXXXX')
      secret_string = SecretString.new(str, silenced_str: silenced_str)
      yield secret_string
    ensure
      secret_string.erase
    end

  end

  # Constructor
  #
  # Parameters::
  # * *str* (String): The original string to protect
  # * *silenced_str* (String): The silenced representation of this string [default: 'XXXXX']
  def initialize(str, silenced_str: 'XXXXX')
    @str = str
    # Make sure we manipulate @str without cloning or modifying it from now on.
    @silenced_str = silenced_str
  end

  extend Forwardable

  # Delegate the String representations methods to the silenced String
  def_delegators :@silenced_str, *%i[
    inspect
    to_s
  ]

  # Delegate the String identity methods to the unprotected String
  def_delegators :@str, *%i[
    ==
    =~
    match
    size
  ]

  # Return the unprotected String
  #
  # Result::
  # * String: Unprotected string
  def to_unprotected
    @str
  end

  # Erase the string
  def erase
    SecretString.erase(@str)
  end

end
