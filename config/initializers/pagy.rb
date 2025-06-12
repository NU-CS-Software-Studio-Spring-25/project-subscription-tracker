require 'pagy/extras/bootstrap'

# Set default items per page to 10
Pagy::DEFAULT[:items] = 10

# Explicitly set default limit to 10 as well for consistency
Pagy::DEFAULT[:limit] = 10

# Set maximum items per page (security measure)
Pagy::DEFAULT[:max_items] = 49

# Disable items parameter override to enforce the items per page setting
Pagy::DEFAULT[:items_param] = nil

# Explicitly disable the items extra (which can use session)
Pagy::DEFAULT[:items_extra] = false

# Enable overflow handling
# :last_page - redirect to last page if page number is too high
# :empty_page - return empty results if page number is too high
Pagy::DEFAULT[:overflow] = :last_page