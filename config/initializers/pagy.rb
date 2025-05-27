require 'pagy/extras/bootstrap'

# Set default items per page to 9 (3x3 grid)
Pagy::DEFAULT[:items] = 9

# Set maximum items per page (security measure)
Pagy::DEFAULT[:max_items] = 49

# Enable overflow handling
# :last_page - redirect to last page if page number is too high
# :empty_page - return empty results if page number is too high
Pagy::DEFAULT[:overflow] = :last_page