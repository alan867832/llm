import os
from PyPDF2 import PdfReader

input_folder = 'downloaded_pdfs'
output_folder = 'markdown_files'

# 创建输出文件夹（如果不存在）
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 遍历输入文件夹中的所有 PDF 文件
for filename in os.listdir(input_folder):
    if filename.endswith('.pdf'):
        # 构建完整的文件路径
        pdf_path = os.path.join(input_folder, filename)
        markdown_path = os.path.join(output_folder, filename.replace('.pdf', '.md'))

        # 使用 PyPDF2 提取 PDF 文本
        reader = PdfReader(pdf_path)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"  # 提取每一页的文本

        # 将文本保存为 Markdown 文件
        with open(markdown_path, 'w', encoding='utf-8') as md_file:
            md_file.write(text)

        print(f"Converted {filename} to {markdown_path}")

print("All PDFs have been converted to Markdown.")