import os
import requests
import json
from lxml import etree

# 文件夹路径
markdown_folder = "markdown_files"

# Ollama API 地址
ollama_api_url = "http://localhost:11434/api/chat"

class MarkdownFile:
    def __init__(self, filename, content):
        self.filename = filename
        self.content = content

# 读取 Markdown 文件内容
def read_markdown_files(folder):
    """读取文件夹中的所有 Markdown 文件并返回文件名和内容"""
    markdown_data = []
    for filename in os.listdir(folder):
        if filename.endswith(".md"):
            file_path = os.path.join(folder, filename)
            with open(file_path, "r", encoding="utf-8") as file:
                print(f"读取文件: {filename}")
                content = file.read()
                # 按 "文件名: 内容" 格式存储
                markdown_data.append(MarkdownFile(filename, content))
    return markdown_data

# 将 Markdown 文件列表转换为 XML 字符串
def markdown_files_to_xml(markdown_files):
    root = etree.Element("MarkdownFiles")
    for markdown_file in markdown_files:
        item = etree.SubElement(root, "MarkdownFile")
        filename = etree.SubElement(item, "filename")
        filename.text = markdown_file.filename
        content = etree.SubElement(item, "content")
        # 使用 CDATA 区块包裹 content
        cdata = etree.CDATA(markdown_file.content)
        content.append(cdata)
    return etree.tostring(root, pretty_print=True, encoding="unicode", method="xml")

# 组装数据并调用 Ollama API
def send_to_ollama(contents):
    """将 Markdown 内容发送到 Ollama 的 /api/chat 接口"""
    # 将 Markdown 文件列表转换为 XML 字符串
    xml_string = markdown_files_to_xml(contents)
    
    # 发送 POST 请求
    response = requests.post(ollama_api_url, 
        json={
            "messages": [{"role": "user", "content": xml_string+" 请对xml格式的文档进行总结分类"}],
            "model": "qwq:32b",
            "stream": True
        },
        headers={
            "accept": "application/json",
            "Content-Type": "application/json"
        },
        timeout=None,
        stream=True,
        )

    # 检查响应状态
    if response.status_code == 200:
        print("Ollama API 响应成功！")
        
        for chunk in response.iter_lines():
            if chunk:
                # 解码二进制数据为字符串
                json_str = chunk.decode('utf-8')
                if json_str:
                    chunk_data = json.loads(json_str)
                    # 从choices中获取content
                    if "message" in chunk_data and chunk_data["message"]:
                        message = chunk_data["message"]
                        content = message["content"]
                        if content:
                            print(content, end="")
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
