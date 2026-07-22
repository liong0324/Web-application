// LUMORA - JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Theme Toggle
    const toggle = document.getElementById('themeToggle');
    if (toggle) {
        toggle.addEventListener('click', function() {
            const html = document.documentElement;
            const isDark = html.getAttribute('data-theme') === 'dark';
            html.setAttribute('data-theme', isDark ? 'light' : 'dark');
            toggle.innerHTML = isDark ? '<i class="bi bi-moon-fill"></i>' : '<i class="bi bi-sun-fill"></i>';
            localStorage.setItem('theme', isDark ? 'light' : 'dark');
        });
        const saved = localStorage.getItem('theme');
        if (saved) {
            document.documentElement.setAttribute('data-theme', saved);
            toggle.innerHTML = saved === 'dark' ? '<i class="bi bi-sun-fill"></i>' : '<i class="bi bi-moon-fill"></i>';
        }
    }
});

function togglePassword(inputId, icon) {
    var input = document.getElementById(inputId);
    var i = icon.querySelector('i');
    if (input.type === 'password') {
        input.type = 'text';
        i.classList.remove('bi-eye');
        i.classList.add('bi-eye-slash');
    } else {
        input.type = 'password';
        i.classList.remove('bi-eye-slash');
        i.classList.add('bi-eye');
    }
}

function validateTerms(sender, args) {
    var checkbox = document.getElementById('chkTerms');
    args.IsValid = checkbox && checkbox.checked;
}
