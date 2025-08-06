# Pagy initializer file
# First require the base pagy gem
require 'pagy'

# Then require the extras
require 'pagy/extras/bootstrap'
require 'pagy/extras/metadata'

# Configure default settings
Pagy::DEFAULT[:limit] = 10
Pagy::DEFAULT[:size] = 9

# Configure Javascript for Turbo and Stimulus
Pagy::DEFAULT[:enable_items_extra] = true

Pagy::DEFAULT.freeze