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
    document.getElementById('turbo-chat-message-field').reset();
    this.targetElements[0].scrollIntoView({block: "end", behavior: "smooth"});
};
Turbo.StreamActions.show_chat = function () {
    const target = this.targetElements[0];
    document.getElementById('turbo-chat-inside').style.display = "block";
    target.style.display = "block";
    target.style.bottom = "0px";
};
Turbo.StreamActions.retain_scroll = function () {
    this.targetElements[0].parentNode.scrollBy(0, 1); // xD retain scroll on prepend
};
Turbo.StreamActions.scroll_messages = function () {
    this.targetElements[0].scrollIntoView({block: "end"});
};
Turbo.StreamActions.slow_scroll_messages = function () {
    this.targetElements[0].scrollIntoView({block: "end", behavior: "smooth"});
};

window.collapseChat = function collapseChat() {
    const div = document.getElementById('turbo-chat-container');
    const form = document.getElementById('turbo-chat-message-field')
    if (div.style.bottom === "0px") {
        div.style.bottom = "-440px";
        if (form){
            form.style.display = "none";
        }
    } else {
        div.style.bottom = "0px";
        if (form){
            form.style.display = "block";
        }
    }
}
