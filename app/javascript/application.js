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

window.collapseDiv = function collapseDiv(divId) {
    var div = document.getElementById(divId);
    if (div.style.bottom === "0px") {
        div.style.bottom = "-440px";
    } else {
        div.style.bottom = "0px";
    }
}
console.log('fe2')