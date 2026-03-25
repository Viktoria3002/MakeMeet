function getToken() {
  return localStorage.getItem("token")
}

function checkAuth() {
  if (!getToken()) {
    window.location.href = "/admin_mini/login"
  }
}

function logout() {
  localStorage.removeItem("token")
  window.location.href = "/admin_mini/login"
}

function createPostAPI() {
  const input = document.getElementById("content")
  const content = input.value.trim()

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
      post: { content: content }
    })
  })
    .then(r => r.json())
    .then(() => {
      input.value = ""
      loadPosts()
    })
}

function approvePostAPI(postId) {
  fetch(`/api/posts/${postId}/moderate`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + getToken()
    },
    body: JSON.stringify({
      status: "approved",
      moderation_comment: "Одобрено через Mini App"
    })
  })
    .then(r => r.json())
    .then(() => loadPosts())
}

async function loadPosts() {
  const list = document.getElementById("posts-list")
  if (!list) return

  const res = await fetch("/api/posts", {
    headers: {
      "Authorization": "Bearer " + getToken()
    }
  })

  const posts = await res.json()
  console.log("posts from API:", posts)

  list.innerHTML = ""

  if (!Array.isArray(posts) || posts.length === 0) {
    list.innerHTML = '<li class="admin-mini-empty">Постов пока нет</li>'
    return
  }

  posts.forEach(post => {
    const item = document.createElement("li")
    item.className = "admin-mini-post-item"

    item.innerHTML = `
      <div class="admin-mini-post-content">${post.content}</div>
      <div class="admin-mini-post-meta">
        <span><strong>Статус:</strong> ${post.status}</span>
        <span><strong>Автор ID:</strong> ${post.author_id}</span>
      </div>
      <div class="admin-mini-post-actions">
        <button type="button" class="admin-mini-button" onclick="approvePostAPI(${post.id})">Одобрить через API</button>
      </div>
    `

    list.appendChild(item)
  })
}

window.addEventListener("DOMContentLoaded", () => {
  if (window.location.pathname.includes("/admin_mini/posts")) {
    checkAuth()
    loadPosts()
  }
})

window.logout = logout
window.createPostAPI = createPostAPI
window.approvePostAPI = approvePostAPI
window.loadPosts = loadPosts