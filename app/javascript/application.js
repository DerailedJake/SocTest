// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]')
const popoverList = [...popoverTriggerList].map(popoverTriggerEl => new bootstrap.Popover(popoverTriggerEl))

Turbo.StreamActions.add_message = function () {
    const target = this.targetElements[0];
    document.getElementById('turbo-chat-message-field').reset()
    target.scrollIntoView({block: "end", behavior: "smooth"});
};

window.collapseChat = function collapseChat() {
    var div = document.getElementById('turbo-chat-container');
    var div_inner = document.getElementById('turbo-chat-inside');
    if (div.style.bottom === "0px") {
        div.style.bottom = "-440px";
        div_inner.style.display = "none";
    } else {
        div.style.bottom = "0px";
        div_inner.style.display = "block";
    }
}
