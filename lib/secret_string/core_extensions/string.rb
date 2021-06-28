class SecretString

  module CoreExtensions

    # Make sure a String can be used as a SecretString.
    # This helps in avoiding code like "if my_str.is_a?(SecretString)" to access to its content.
    module String

      # Return the unprotected String
      #
      # Result::
      # * String: Unprotected string
      def to_unprotected
        self
      end

      # Erase the string
      def erase
        # Nothing to do
      end

    end

  end

end

String.include SecretString::CoreExtensions::String
