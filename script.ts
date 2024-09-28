document.getElementById("contact-form")?.addEventListener("submit", (event) => {
    event.preventDefault();
    const name = (document.getElementById("name") as HTMLInputElement).value;
    const email = (document.getElementById("email") as HTMLInputElement).value;
    const message = (document.getElementById("message") as HTMLTextAreaElement).value;

    console.log("Contact Form Submitted:", { name, email, message });
    alert("Thank you for your message, " + name + "!");
});
