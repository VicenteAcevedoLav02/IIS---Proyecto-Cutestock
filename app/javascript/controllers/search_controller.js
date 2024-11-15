import { Controller } from "stimulus"
import { debounce } from "debounce"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.debouncedSearch = debounce(this.performSearch, 300) // Debounce the search for 300ms
  }

  search() {
    this.debouncedSearch()
  }

  performSearch() {
    const query = this.inputTarget.value
    Turbo.visit(`/search?query=${query}`, { action: 'replace' })
  }
}
