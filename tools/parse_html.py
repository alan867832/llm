import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# 目标网址
base_url = "https://jeffhuang.com/best_paper_awards/"
output_folder = "downloaded_pdfs"

# 创建输出文件夹
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 记录已经访问过的 URL
visited_urls = set()

def block_url(url):
    if "jeffhuang.com" in url:
        print(f"Blocked: {url}")
        return False
    return True

# 下载文件的函数
def download_file(url, folder):
    """下载文件并保存到指定文件夹"""
    local_filename = os.path.join(folder, os.path.basename(url))
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    print(f"Downloaded: {local_filename}")
    return local_filename

# 递归查找和下载 PDF 文件的函数
def find_and_download_pdfs(url, folder):
    """递归查找页面中的 PDF 文件并下载"""
    if url in visited_urls:  # 如果 URL 已经访问过，则跳过
        return
    visited_urls.add(url)  # 将当前 URL 标记为已访问
    print(f"Visiting: {url}")

    try:
        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        # 查找页面中的所有链接
        for link in soup.find_all('a', href=True):
            href = link['href']
            full_url = urljoin(url, href)

            # 如果链接指向 PDF 文件，则下载
            if href.lower().endswith('.pdf'):
                try:
                    download_file(full_url, folder)
                except Exception as e:
                    print(f"Failed to download {full_url}: {e}")

            # 如果链接指向其他页面，则递归查找
            elif not full_url.startswith(('http://', 'https://')) or base_url in full_url:  # 限制在当前网站内
                if block_url(full_url):
                    find_and_download_pdfs(full_url, folder)
    except Exception as e:
        print(f"Failed to visit {url}: {e}")

# 开始从目标网址查找和下载 PDF
find_and_download_pdfs(base_url, output_folder)

print("PDF 下载完成！")