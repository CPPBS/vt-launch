# launch – 启用 VT 终端支持的进程启动器（Windows）

*A Windows tool to launch command-line programs with virtual terminal (VT) support enabled.*

---

## 简介 | Introduction

这是一个轻量级的 Windows 工具，包含 `launch.bat` 和 `launch.ps1` 两个脚本，用于在 Windows 控制台中启动任意命令行程序，并**自动启用虚拟终端（VT）模式**，使 ANSI 转义序列（如颜色、光标控制等）能够正常显示。

*This is a lightweight Windows tool consisting of `launch.bat` and `launch.ps1` that launches any command-line program in the Windows console with **virtual terminal (VT) mode automatically enabled**, allowing ANSI escape sequences (e.g., colors, cursor control) to display correctly.*

---

## 使用方法 | Usage

使用批处理入口（推荐）：
*Use the batch entry (recommended):*

```batch
launch.bat <命令> [参数...]
```

或者直接调用 PowerShell 脚本（需要设置执行策略）：
*Or invoke the PowerShell script directly (execution policy must be set):*

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File launch.ps1 <命令> [参数...]
```

### 示例 | Examples

启动 Python 脚本并启用 VT 支持：
*Launch a Python script with VT support:*

```batch
launch.bat python myscript.py
```

启动带有颜色输出的程序（如 npm run build）：
*Launch a program with colored output (e.g., npm run build):*

```batch
launch.bat npm run build
```

启动任意可执行文件：
*Launch any executable:*

```batch
launch.bat myapp.exe --verbose
```

---

## 工作原理 | How It Works

1. **VT 模式启用**  
   脚本通过 P/Invoke 调用 `kernel32.dll` 中的 `GetStdHandle`、`GetConsoleMode` 和 `SetConsoleMode`，将当前控制台的标准输出句柄的 Mode 标志位添加上 `ENABLE_VIRTUAL_TERMINAL_PROCESSING`（值为 `0x0004`），使控制台能够正确解析并显示 ANSI 转义序列。  
   *The script uses P/Invoke to call `GetStdHandle`, `GetConsoleMode`, and `SetConsoleMode` from `kernel32.dll`, adding the `ENABLE_VIRTUAL_TERMINAL_PROCESSING` flag (`0x0004`) to the Mode bits of the current console's standard output handle. This allows the console to correctly parse and display ANSI escape sequences.*

2. **进程启动**  
   使用 `Start-Process` 启动目标程序，并保证：  
   *The target program is started via `Start-Process` with the following guarantees:*  
   - `-Wait`：脚本等待目标进程结束再退出，便于批处理或 CI/CD 流程控制。  
     *`-Wait` makes the script wait for the target process to exit before returning, facilitating batch or CI/CD workflow control.*  
   - `-NoNewWindow`：目标进程运行在当前控制台窗口中，不弹出新窗口，输出直接显示在当前终端。  
     *`-NoNewWindow` runs the target process in the current console window without opening a new one, so all output appears directly in the existing terminal.*

---

## 注意事项 | Notes

- 脚本以**当前控制台窗口**为作用范围，若目标进程自己创建新窗口，则该新窗口的 VT 模式需要自行配置。  
  *The script only affects the **current console window** – if the target process creates its own new window, VT mode for that window needs to be configured separately.*

- 某些旧版 Windows（如 Win7）可能不完整支持 VT 模式，此时脚本仍会尝试设置，但效果不保证。  
  *Some older Windows versions (e.g., Win7) may not fully support VT mode – the script will still attempt to enable it, but results are not guaranteed.*

- 参数中的特殊字符（如空格、引号）请按常规命令行转义规则处理。  
  *Special characters (e.g., spaces, quotes) in arguments should be escaped according to standard command-line rules.*

- 当未提供任何参数时，脚本返回错误码 `1`。  
  *The script returns error code `1` when no arguments are provided.*

---

## 许可证 | License

本脚本采用 [MIT 许可证](LICENSE)，可自由使用、修改和分发。  
*This script is provided under the [MIT License](LICENSE) – feel free to use, modify, and distribute.*
