module PaginationHelper
  def pagy_nav(pagy) # rubocop:disable Metrics/MethodLength,Metrics/PerceivedComplexity
    html = %(<div class="flex items-center justify-between gap-4 my-4">)

    # Page info
    html << %(<div class="text-sm text-base-content/70">
                Showing #{pagy.from} to #{pagy.to} of #{pagy.count} entries
              </div>)

    # Navigation
    html << %(<div class="join">)

    # Previous button
    prev_btn_class = "join-item btn btn-sm #{pagy.prev ? '' : 'btn-disabled'}"
    html << if pagy.prev
              %(<a href="#{pagy_url_for(pagy, pagy.prev)}" class="#{prev_btn_class}" aria-label="Previous">
                  <i class="fas fa-chevron-left text-xs"></i>
                </a>)
            else
              %(<button class="#{prev_btn_class}" aria-disabled="true" aria-label="Previous">
                  <i class="fas fa-chevron-left text-xs"></i>
                </button>)
            end

    # Page numbers and gaps
    pagy.series.each do |item|
      case item
      when Integer
        html << %(<a href="#{pagy_url_for(pagy, item)}" class="join-item btn btn-sm min-w-[2.5rem]">#{item}</a>)
      when String # Current page
        html << %(<button class="join-item btn btn-sm btn-active bg-primary text-primary-content hover:bg-primary min-w-[2.5rem]"
                          aria-current="page" aria-disabled="true">#{item}</button>)
      when :gap
        html << %(<button class="join-item btn btn-sm btn-disabled min-w-[2.5rem]" aria-disabled="true">
                    <i class="fas fa-ellipsis-h text-xs"></i>
                  </button>)
      end
    end

    # Next button
    next_btn_class = "join-item btn btn-sm #{pagy.next ? '' : 'btn-disabled'}"
    html << if pagy.next
              %(<a href="#{pagy_url_for(pagy, pagy.next)}" class="#{next_btn_class}" aria-label="Next">
                  <i class="fas fa-chevron-right text-xs"></i>
                </a>)
            else
              %(<button class="#{next_btn_class}" aria-disabled="true" aria-label="Next">
                  <i class="fas fa-chevron-right text-xs"></i>
                </button>)
            end

    html << %(</div>)
    html << %(</div>)

    html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
