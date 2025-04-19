<h1 align="center">🧠 PresentTest-for-JkrGUI</h1>
<p align="center"><i>Lua-based Presentation Engine – like PowerPoint, but cursed</i></p>
<p align="center"><b>Powered by:</b> Lua 🐍 | Custom Engine 🎮 | <a href="https://github.com/theanimatorspal/jkrgui">JkrGUI</a> 🪞</p>

<p align="center">
  <img src="https://img.shields.io/badge/build-chaotic-red?style=flat-square&logo=lua" />
  <img src="https://img.shields.io/badge/docs-none-yellow?style=flat-square&logo=readthedocs" />
  <img src="https://img.shields.io/badge/stability-quantum--fluctuates-orange?style=flat-square&logo=apacherocketmq" />
</p>

---

## 🧵 About

This is a **presentation scripting engine** — made with Lua and running on your homemade `jkrgui`.  
Instead of slides, you get full control over 3D nodes, cameras, buttons, lines, networks... and maybe your own sanity.

> 💡 It's like Prezi, if Prezi was a demon.  

---

## 🔥 Features

| What                     | Status       | Description                              |
|--------------------------|--------------|------------------------------------------|
| Presentation Scripts     | ✅ Working    | Just write Lua + Frame()s and vibe       |
| Camera Transforms        | ✅ Functional | Pan, zoom, rotate in 3D space            |
| Buttons & Labels         | ✅ There      | Interactive or static, your call         |
| Network Diagrams         | ✅ Cursed     | Animate packets like no one's watching   |
| Rendering Engine         | ✅ Custom     | 100% `jkrgui` with no external deps      |
| UX Consistency           | ❌ LMAO       | Each frame is a new surprise             |

---

## ⚗️ How to Run This Frankenstein

```bash
# Clone the chaos
git clone https://github.com/theanimatorspal/PresentTest-for-JkrGUI.git
cd PresentTest-for-JkrGUI

# You need Lua and jkrgui installed
# Clone the GUI engine (unless you enjoy suffering)
git clone https://github.com/theanimatorspal/jkrgui.git

# (Assumes you set up LuaJIT + deps correctly)
lua main.lua
```

> 📝 Reminder: No binaries, no package managers, just you and the void.

---

## 🚀 How to Use Triyamik

1. **Clone the Repo**  
   ```bash
   git clone https://github.com/theanimatorspal/PresentTest-for-JkrGUI
   cd PresentTest-for-JkrGUI
   ```

2. **Create Your Lua Presentation**  
   Inside the folder, make a `.lua` file for your custom slides.

3. **Write Your Frames**  
   Use Triyamik’s syntax to define slides. See below for samples.

4. **Run the Show**  
   ```bash
   jkrgui --gr --run yourfile.lua
   ```

5. **Enjoy the Madness**  
   Assuming everything is built right, it'll launch your presentation using the JkrGUI backend.

---

## 🧪 Sample Slides (Lua Format)

```lua
P = {
  Frame {
    CSection { t = "Welcome" },
    CTitlePage {
      t = "Triyamik",
      st = "A Graphics Engine based on JkrGUI",
      names = {
        "077bct022 Bishal Jaiswal",
        "077bct024 Darshan Koirala",
        "077bct027 Dipesh Regmi",
      }
    }
  },
  Frame {
    s1 = CSection { t = "Topics" },
    points = CEnumerate {
      items = {
        "What is Triyamik?",
        "Architecture Overview",
        "Live Demonstration"
      },
      hide = "all"
    }
  },
  Frame {
    s1 = CSection {},
    points = CEnumerate { view = 2 }
  }
}
```

🧩 **Components**:

- `Frame {}`: Represents a single slide
- `CSection { t = "..." }`: Slide heading
- `CTitlePage { t, st, names }`: Title + Subtitle + Devs
- `CEnumerate { items, hide, view }`: Bullet lists that appear incrementally

---

## 💀 Known Weirdness

- Frame sequencing is manual. Don’t mess up the order.
- `Presentations[1]`, `[2]`, etc. — pick one and pray.
- No error handling. If it breaks, it breaks.
- Fonts, transforms, button logic — magical if they work.

---

## 🤘 Why This Exists

This is a **creative chaos engine** for making visually rich presentations, especially for teaching or demonstrating infosec topics.
---

> 🧠 Made by a mad dev, for mad devs. Built on top of 🔮 [JkrGUI](https://github.com/theanimatorspal/jkrgui) — your very own GUI framework.
