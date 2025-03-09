import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# 目标网站URL
url = "https://jeffhuang.com/best_paper_awards/"

# 设置保存PDF的目录
output_dir = "downloaded_pdfs"
os.makedirs(output_dir, exist_ok=True)

# 获取网页内容
response = requests.get(url)
response.raise_for_status()  # 检查请求是否成功

# 解析HTML
soup = BeautifulSoup(response.text, "html.parser")

# 查找所有的链接
pdf_links = []
for link in soup.find_all("a", href=True):
    href = link["href"]
    # 检查链接是否指向PDF文件
    if href.lower().endswith(".pdf"):
        # 将相对URL转换为绝对URL
        full_url = urljoin(url, href)
        pdf_links.append(full_url)

# 下载PDF文件
for pdf_url in pdf_links:
    try:
        # 获取PDF文件名
        pdf_name = os.path.basename(pdf_url)
        pdf_path = os.path.join(output_dir, pdf_name)

        # 下载文件
        print(f"Downloading {pdf_url}...")
        pdf_response = requests.get(pdf_url)
        pdf_response.raise_for_status()

        # 保存文件
        with open(pdf_path, "wb") as pdf_file:
            pdf_file.write(pdf_response.content)
        print(f"Saved {pdf_name} to {output_dir}")
    except Exception as e:
        print(f"Failed to download {pdf_url}: {e}")

print("Download complete!")