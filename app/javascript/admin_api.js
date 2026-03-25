function getToken() {
  return localStorage.getItem("token")
}

// ===== AUTH =====
function checkAuth() {
  if (!getToken()) {
    window.location.href = "/admin_mini/login"
  }
}

function logout() {
  localStorage.removeItem("token")
  window.location.href = "/admin_mini/login"
}

// ===== CREATE =====
function createPostAPI() {
  const contentInput = document.getElementById("content")
  const content = contentInput.value.trim()

  if (!content) {
    alert("Введите текст поста")
    return
  }

  fetch("/api/posts", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + getToken()
    },
    body: JSON.stringify({
      post: { content }
    })
  }).then(() => {
    contentInput.value = ""
    loadPosts()
  })
}

// ===== READ =====
async function loadPosts() {
  const res = await fetch("/api/posts", {
    headers: {
      "Authorization": "Bearer " + getToken()
    }
  })

  const posts = await res.json()

  const list = document.getElementById("posts-list")
  list.innerHTML = ""

  posts.forEach(post => {
    const li = document.createElement("li")

    li.innerHTML = `
      <strong>${post.content}</strong>
      <br>
      Статус: ${post.status}
      <br>
      Автор ID: ${post.author_id}
      <br>
      <button onclick="approvePostAPI(${post.id})">Одобрить</button>
      <hr>
    `

    list.appendChild(li)
  })
}

// ===== UPDATE (MODERATION) =====
function approvePostAPI(postId) {
  fetch(`/api/posts/${postId}/moderate`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + getToken()
    },
    body: JSON.stringify({
      status: "approved"
    })
  }).then(() => loadPosts())
}

// ===== INIT =====
window.addEventListener("DOMContentLoaded", () => {
  if (window.location.pathname.includes("/admin_mini/posts")) {
    checkAuth()
    loadPosts()
  }
})

// экспорт для HTML
window.logout = logout
window.createPostAPI = createPostAPI
window.approvePostAPI = approvePostAPI