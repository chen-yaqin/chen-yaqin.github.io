from PIL import Image
import os

def resize_image(input_path, output_path, size=(720, 720)):
    with Image.open(input_path) as img:
        img_resized = img.resize(size, Image.LANCZOS)  # 使用 LANCZOS 保持高质量
        img_resized.save(output_path)
        print(f"Resized image saved to: {output_path}")

# 示例使用：
input_file = "D:\Study_Information\个人信息\证件照\侧面.png"   # 替换为你的文件路径
output_file = "D:\Study_Information\个人信息\证件照\侧面_720.png"  # 输出文件名

resize_image(input_file, output_file)
