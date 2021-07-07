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

      # Compare the String with another object
      #
      # Parameters::
      # * *other* (Object): Other object
      # Result::
      # * Boolean: Are objects equal?
      def ==(other)
        if other.is_a?(SecretString)
          other == self
        else
          super
        end
      end

    end

  end

end

String.prepend SecretString::CoreExtensions::String
