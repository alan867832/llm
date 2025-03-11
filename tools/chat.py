import os
import requests

# 文件夹路径
markdown_folder = "markdown_files"

# Ollama API 地址
ollama_api_url = "http://localhost:11434/api/chat"

# 读取 Markdown 文件内容
def read_markdown_files(folder):
    """读取文件夹中的所有 Markdown 文件并返回文件名和内容"""
    markdown_data = []
    for filename in os.listdir(folder):
        if filename.endswith(".md"):
            file_path = os.path.join(folder, filename)
            with open(file_path, "r", encoding="utf-8") as file:
                content = file.read()
                # 按 "文件名: 内容" 格式存储
                markdown_data.append(f"文件名: {filename}, 内容: {content}")
    return markdown_data

# 组装数据并调用 Ollama API
def send_to_ollama(contents):
    """将 Markdown 内容发送到 Ollama 的 /api/chat 接口"""
    # 组装 messages
    messages = []
    for content in contents:
        messages.append({"role": "assistant", "content": content})
    
    # 加入总结请求
    messages.append({"role": "user", "content": "请总结分类上面的文档"})

    # 组装请求数据
    payload = {
        "model": "qwq:32b",  # 替换为你的模型名称
        "messages": messages
    }

    # 发送 POST 请求
    response = requests.post(ollama_api_url, json=payload)

    # 检查响应状态
    if response.status_code == 200:
        print("Ollama API 响应成功！")
        print("响应内容：", response.json())
    else:
        print(f"请求失败，状态码：{response.status_code}")
        print("错误信息：", response.text)

# 主函数
def main():
    # 读取 Markdown 文件
    markdown_contents = read_markdown_files(markdown_folder)

    if not markdown_contents:
        print("未找到 Markdown 文件！")
        return

    # 发送到 Ollama API
    send_to_ollama(markdown_contents)

if __name__ == "__main__":
    main()